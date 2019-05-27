# CURATOR-DOCKERFILE

Just a docker image to use curator as a cronjob in a kubernetes cluster.

## Why this docker image?

There is a problem with [curator](https://github.com/elastic/curator), the last version only supports `http_auth` on the config file, and if you want to use an environment variable, you need the whole `user:password` string on an environment variable, as explained in the documentation [here](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/envvars.html):

```
When using environment variables, the value must only be the environment variable.

Using extra text, such as:

logfile: ${LOGPATH}/extra/path/information/file.log

is not supported at this time.
```

Since I deploy elasticsearch using [ECK](https://github.com/elastic/cloud-on-k8s), I don't have the username and password avaiable in that format.

And then I found [this!](https://juanmatiasdelacamara.wordpress.com/2019/01/09/elasticsearch-and-a-kubernetes-curator/), which is a great idea (so, all the credit for: Juan Matias de la Camara :) ), but doesn't provide any docker image or github repo to fork so... let's do it ourselves! :)

## ConfigMap example

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: curator-config
  namespace: logging-system
  labels:
    app: curator
data:
  actions.yaml: |-
    ---
    actions:
      1:
        action: delete_indices
        description: >-
          Delete indices older than 7 days (based on index name), for logstash-
          prefixed indices. Ignore the error if the filter does not result in an
          actionable list of indices (ignore_empty_list) and exit cleanly.
        options:
          ignore_empty_list: True
          timeout_override:
          continue_if_exception: False
          disable_action: False
        filters:
        - filtertype: pattern
          kind: prefix
          value: logstash-
          exclude:
        - filtertype: age
          source: name
          direction: older
          timestring: '%Y.%m.%d'
          unit: days
          unit_count: 7
          exclude:

  config.yaml: |-
    ---
    client:
      hosts:
        - "https://##-ELASTIC_URL-##"
      port: 9200
      url_prefix:
      use_ssl: True
      certificate: '/var/ca/ca.pem'
      client_cert: 
      client_key: '/var/ca_key/private.key'
      ssl_no_validate: False
      http_auth: "##-ELASTIC_USER-##:##-ELASTIC_PASSWORD-##"
      timeout: 30
      master_only: False
    logging:
      loglevel: INFO
      logfile:
      logformat: default
      blacklist: ['elasticsearch', 'urllib3']
```

## CronJob example

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: curator
  namespace: logging-system
  labels:
    app: curator
spec:
  schedule: "0 3 * * *"
  successfulJobsHistoryLimit: 1
  failedJobsHistoryLimit: 3
  concurrencyPolicy: Forbid
  startingDeadlineSeconds: 120
  jobTemplate:
    spec:
      template:
        spec:
          securityContext:
            runAsUser: 1000
            fsGroup: 1000
          containers:
          - image: belitre/curator:5.7.6
            securityContext:
              runAsUser: 1000
            name: curator
            command: ["/bin/sh","-c","'/curator/bootup.sh'"]
            env:
            - name: ELASTIC_URL
              value: 'elasticsearch-es:9200'
            - name: ELASTIC_USER
              value: "elastic"
            - name: ELASTIC_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: elasticsearch-elastic-user
                  key: elastic
            volumeMounts:
            - name: config
              mountPath: /var/curator
            - name: elastic-ca
              mountPath: /var/ca
              readOnly: true
            - name: elastic-ca-private-key
              mountPath: /var/ca_key
              readOnly: true
          volumes:
          - name: config
            configMap:
              name: curator-config
          - name: elastic-ca
            secret:
              secretName: elasticsearch-ca
          - name: elastic-ca-private-key
            secret:
              secretName: elasticsearch-ca-private-key
          restartPolicy: OnFailure
```
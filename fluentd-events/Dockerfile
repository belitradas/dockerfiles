FROM gcr.io/fluentd-elasticsearch/fluentd:v2.5.2

RUN apt-get update && apt-get install ruby2.3-dev build-essential --yes

RUN gem install fluent-plugin-kubernetes_metadata_input

CMD ["/run.sh"]

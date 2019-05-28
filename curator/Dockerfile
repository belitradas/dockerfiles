FROM python:3-alpine 

ARG CURATOR_VERSION=5.7.6
 
RUN mkdir -p /curator && \
    chmod 777 /curator
 
COPY bootup.sh /curator/bootup.sh
 
RUN chmod ug+x /curator/bootup.sh
 
WORKDIR /curator
 
RUN pip install elasticsearch-curator==$CURATOR_VERSION
 
CMD /bin/sh -c '/curator/bootup.sh'

FROM centos:centos7

RUN yum update -y && yum install -y \
    wget \
    tar \
    perl-Digest-SHA

RUN useradd -s /bin/bash user_elastic && \
    mkdir var/lib/elasticsearch && \
    chown user_elastic /var/lib/elasticsearch

USER user_elastic

RUN cd /tmp && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.3-linux-x86_64.tar.gz && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512

RUN cd /tmp && \
    tar -xzf elasticsearch-8.1.3-linux-x86_64.tar.gz && \
    mkdir ~/elasticsearch && \
    mv elasticsearch-8.1.3/* ~/elasticsearch

RUN rm /tmp/elasticsearch-8.1.3-linux-x86_64.tar.gz \
    /tmp/elasticsearch-8.1.3-linux-x86_64.tar.gz.sha512

ENV ES_HOME /home/user_elastic/elasticsearch
ENV ES_PATH_CONF $ES_HOME/config
ENV PATH $PATH:$ES_HOME/bin

RUN echo 'node.name: netology_test' >> $ES_PATH_CONF/elasticsearch.yml && \
    echo 'path.data: /var/lib/elasticsearch' >> $ES_PATH_CONF/elasticsearch.yml

#COPY elasticsearch.yml $ES_HOME/config

EXPOSE 9200
EXPOSE 9300

CMD ["elasticsearch"]
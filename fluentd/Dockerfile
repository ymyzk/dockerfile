FROM ruby:2.3-slim
MAINTAINER Yusuke Miyazaki <miyazaki.dev@gmail.com>

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            build-essential \
        && rm -rf /var/lib/apt/lists/*

RUN gem install fluentd --no-document

RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/log
RUN mkdir -p /fluentd/plugins

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/
ONBUILD COPY plugins /fluentd/plugins/

EXPOSE 24224

CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf", "-p", "/fluentd/plugins"]

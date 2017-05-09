FROM ruby:2.3-slim

RUN apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            build-essential \
        && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document fluentd -v "~> 0.12.0"
RUN gem install --no-document fluent-plugin-bigquery -v "~> 0.4.0"
RUN gem install --no-document fluent-plugin-elasticsearch -v "~> 1.9.0"
RUN gem install --no-document fluent-plugin-rewrite-tag-filter -v "~> 1.5.0"

RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/log
RUN mkdir -p /fluentd/plugins

COPY fluent.conf /fluentd/etc/

EXPOSE 24224

CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf", "-p", "/fluentd/plugins"]

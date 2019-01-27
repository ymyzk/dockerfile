FROM ruby:2.3-slim

RUN apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            build-essential \
        && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /fluentd/
WORKDIR /fluentd
RUN bundle install

RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/log
RUN mkdir -p /fluentd/plugins

COPY fluent.conf /fluentd/etc/

EXPOSE 24224

CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf", "-p", "/fluentd/plugins"]

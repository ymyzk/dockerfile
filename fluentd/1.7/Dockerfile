FROM fluent/fluentd:v1.7-1

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install \
      fluent-plugin-bigquery:2.2.0 \
      fluent-plugin-elasticsearch:3.5.5 \
      fluent-plugin-rewrite-tag-filter:2.2.0 \
      fluent-plugin-prometheus:1.6.0 \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

USER fluent

FROM alpine:3.8

RUN apk upgrade --update --no-cache

RUN addgroup -S test && adduser -S test -G test

USER test

ADD . /etc/onos-helm-charts

ADD build/_output/bin/onos-helm-charts-tests /usr/local/bin/onos-helm-charts-tests

ENTRYPOINT ["onos-helm-charts-tests"]
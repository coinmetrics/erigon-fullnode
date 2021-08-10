# Build image
FROM alpine:latest AS build

ARG VERSION

RUN apk --no-cache add make gcc g++ linux-headers git bash ca-certificates libgcc libstdc++ alpine-sdk go
RUN git clone --depth 1 -b v${VERSION} https://github.com/ledgerwatch/erigon /opt/erigon

WORKDIR /opt/erigon

RUN make erigon rpcdaemon integration sentry


# Final image
FROM alpine:latest

RUN apk add --no-cache ca-certificates libgcc libstdc++ tzdata
COPY --from=build /opt/erigon/build/bin/* /usr/local/bin/

RUN adduser -D -u 1000 runner
USER runner
WORKDIR /home/runner

USER runner

EXPOSE 8545 8546 30303 30303/udp 30304 30304/udp 8080 9090 6060

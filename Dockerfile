FROM golang:1.19 as builder
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 make build


FROM alpine:3
ARG VERSION
COPY --from=builder /build/dist/linky-exporter-${VERSION}-linux-armv7 linky-exporter
RUN addgroup -S exporter && adduser -S exporter -G exporter
USER exporter
ENTRYPOINT [ "./linky-exporter" ]

FROM golang:latest AS app
RUN mkdir /app
COPY /. /app
RUN apt update && apt install -y ca-certificates
WORKDIR /app
RUN go mod download
RUN go build ./cmd/web

FROM ubuntu:22.04
COPY --from=app /app/. /app/.
COPY --from=app /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
RUN apt update && apt install -y tzdata
WORKDIR /app
RUN chmod o+r yandex_8b1f9b27e01feaa8.html
USER nobody
EXPOSE 4000
CMD ["/app/web"]
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache ca-certificates git

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o iptv-proxy .

FROM alpine:3.18
RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /build/iptv-proxy /usr/local/bin/iptv-proxy

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/iptv-proxy"]

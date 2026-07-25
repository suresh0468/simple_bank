# Stage 1
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o main .

RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.1/migrate.linux-amd64.tar.gz | tar xvz

# Stage 2
FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate .
COPY app.env .
COPY start.sh .
COPY db/migration ./db/migration

EXPOSE 8081
CMD ["/app/main"]
ENTRYPOINT ["/app/start.sh"]
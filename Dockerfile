# Stage 1
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o main .


# Stage 2
FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/main .
COPY app.env .
COPY db/migration ./db/migration

EXPOSE 8081
CMD ["/app/main"]
ENTRYPOINT ["/app/main"]
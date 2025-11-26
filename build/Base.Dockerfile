FROM goreleaser/goreleaser-cross:v1.23.1 AS builder

WORKDIR /app
COPY . .

RUN goreleaser release --snapshot --skip=publish,announce,docker -f .goreleaser.yaml

FROM scratch
COPY --from=builder /app/dist .

# Этап сборки
FROM golang:1.21 AS builder

WORKDIR /app

# Копируем go.mod и go.sum для установки зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем всё остальное и собираем приложение
COPY . .
RUN go build -o parcel-tracker main.go

# Финальный минимальный образ
FROM debian:bullseye-slim

WORKDIR /app

# Устанавливаем необходимые библиотеки для SQLite (modernc.org/sqlite использует C-библиотеки)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Копируем собранный бинарник и БД
COPY --from=builder /app/parcel-tracker .
COPY tracker.db .

# Запускаем приложение
CMD ["./parcel-tracker"]

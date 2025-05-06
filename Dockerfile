# Этап сборки
FROM golang:1.21 AS builder

WORKDIR /app

# Копируем go.mod и go.sum, устанавливаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код и собираем приложение
COPY . .
RUN go build -o parcel-tracker main.go

# Финальный образ
FROM scratch

WORKDIR /app

# Копируем бинарник и SQLite-базу из builder-образа
COPY --from=builder /app/parcel-tracker .
COPY --from=builder /app/tracker.db .

# Указываем команду по умолчанию
CMD ["./parcel-tracker"]

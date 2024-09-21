#!/bin/bash

# Скрипт развертывания / Deploy Script

# Остановка и удаление существующих контейнеров / Stop and remove existing containers
docker-compose down

# Сборка образов / Build images
docker-compose build

# Запуск контейнеров / Start containers
docker-compose up -d

# Применение миграций / Run migrations
docker-compose run web mix ecto.create
docker-compose run web mix ecto.migrate

echo "Развертывание завершено. Приложение доступно по адресу http://localhost:4000"
echo "Deployment completed. The application is available at http://localhost:4000"


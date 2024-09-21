#!/bin/bash

# Скрипт подготовки к развертыванию / Prepare Deployment Script

# Проверка наличия Docker / Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker не установлен. Пожалуйста, установите Docker перед продолжением."
    echo "Docker is not installed. Please install Docker before continuing."
    exit 1
fi

# Проверка наличия Docker Compose / Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose не установлен. Пожалуйста, установите Docker Compose перед продолжением."
    echo "Docker Compose is not installed. Please install Docker Compose before continuing."
    exit 1
fi

# Создание .env файла, если он не существует / Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "SECRET_KEY_BASE=$(mix phx.gen.secret)" > .env
    echo "DATABASE_URL=ecto://postgres:postgres@db/url_shortener" >> .env
    echo ".env файл создан / .env file created"
else
    echo ".env файл уже существует / .env file already exists"
fi

echo "Подготовка к развертыванию завершена / Preparation for deployment completed"

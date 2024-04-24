include .env

build-services:
        docker compose up -d --no-recreate

rebuild-services:
        docker compose up -d --build

stop-services:
        docker compose down

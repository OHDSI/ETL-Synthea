PROJECT_NAME=omop-dataops

.PHONY: help build up down run-etl full-cycle

help:
	@echo "Доступные команды:"
	@echo "  make build      - Собрать Docker-образы"
	@echo "  make up         - Запустить базу данных PostgreSQL"
	@echo "  make run-etl    - Запустить маппинг"
	@echo "  make full-cycle - Сборка + Запуск БД + ETL"

build:
	docker-compose build

up:
	docker-compose up -d db
	@echo "Waiting for database to be ready..."
	powershell -Command "Start-Sleep -Seconds 10"

run-etl:
	docker-compose up etl-worker

full-cycle: build up run-etl

down:
	docker-compose down -v
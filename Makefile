# Nome do serviço principal (ajuste se for diferente no seu docker-compose.yml)
SERVICE = web

.PHONY: setup migrate seed test console bash logs up down restart lint

setup:
	docker compose run --rm $(SERVICE) bin/setup

migrate:
	docker compose run --rm $(SERVICE) rails db:migrate

seed:
	docker compose run --rm $(SERVICE) rails db:seed

test:
	docker compose run --rm $(SERVICE) rails db:test:prepare
	docker compose run --rm $(SERVICE) rails test

console:
	docker compose run --rm $(SERVICE) rails console

bash:
	docker compose run --rm $(SERVICE) bash

logs:
	docker compose logs -f $(SERVICE)

up:
	docker compose up

down:
	docker compose down

restart:
	docker compose down && docker compose up

lint:
	docker compose run --rm $(SERVICE) rubocop

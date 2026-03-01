.PHONY: up down stop clean

up:
	docker compose up

down:
	docker compose down

stop:
	docker compose stop

clean:
	docker compose down -v

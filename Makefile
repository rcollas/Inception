all:
	docker compose --env-file ./srcs/.env -f ./srcs/docker-compose.yml up --build -d

up:
	docker compose -f ./srcs/docker-compose.yml up --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean:
	docker compose -f ./srcs/docker-compose.yml down 
	sudo rm -rf ~/data/wordpress_vol/*
	sudo rm -rf ~/data/mariadb_vol/*
	docker system prune -a

.PHONY: all up down clean

#-----------------------------------------------------------
# Docker
#-----------------------------------------------------------

# Wake up docker containers
up:
	docker-compose up -d

# Shut down docker containers
down:
	docker-compose down

# Show a status of each container
status:
	docker-compose ps

# Status alias
s: status

# Show logs of each container
logs:
	docker-compose logs

# Restart all containers
restart: down up


# Build and up docker containers
build:
	docker-compose up -d --build

# Build containers with no cache option
build-no-cache:
	docker-compose build --no-cache

# Build and up docker containers
rebuild: down build



# Run terminal of the client container
client:
	docker-compose exec php_front /bin/sh


# npm run dev

dev:
	docker exec php_front  bash -c  "npm run dev"

bui:
	docker exec php_front  bash -c  "npm run build"

upd: up dev

upb: up bui


#-----------------------------------------------------------
# Database
#-----------------------------------------------------------

# Run database migrations
db-migrate:
	docker-compose exec php php artisan migrate

# Migrate alias
migrate: db-migrate

# Run migrations rollback
db-rollback:
	docker-compose exec php php artisan migrate:rollback

# Rollback alias
rollback: db-rollback

# Run seeders
db-seed:
	docker-compose exec php php artisan db:seed

# Fresh all migrations
db-fresh:
	docker-compose exec php php artisan migrate:fresh

# Dump database into file
db-dump:
	docker-compose exec postgres pg_dump -U app -d app > docker/postgres/dumps/dump.sql



#-----------------------------------------------------------
# Testing
#-----------------------------------------------------------

# Run phpunit tests
test:
	docker-compose exec php vendor/bin/phpunit --order-by=defects --stop-on-defect

# Run all tests ignoring failures.
test-all:
	docker-compose exec php vendor/bin/phpunit --order-by=defects

# Run phpunit tests with coverage
coverage:
	docker-compose exec php vendor/bin/phpunit --coverage-html tests/report

# Run phpunit tests
dusk:
	docker-compose exec php php artisan dusk

# Generate metrics
metrics:
	docker-compose exec php vendor/bin/phpmetrics --report-html=api/tests/metrics api/app



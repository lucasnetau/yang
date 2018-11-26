.PHONY: help
.DEFAULT_GOAL := help

$(VERBOSE).SILENT:

help:
    grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
    cut -d: -f2- | \
    sort -d | \
    awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: composer-install composer-update test

composer-install:
	docker run --rm --interactive --tty --volume $(PWD):/app --user $(id -u):$(id -g) composer install --ignore-platform-reqs

composer-update:
	docker run --rm --interactive --tty --volume $(PWD):/app --user $(id -u):$(id -g) composer update --ignore-platform-reqs

test:
	docker-compose up

cs:
	docker-compose run yang-php /var/www/vendor/bin/phpcs \
	    --standard=/var/www/phpcs.xml \
	    --encoding=UTF-8 \
	    --report-full \
	    --extensions=php \
	   /var/www/src/

cs-fix:
	docker-compose run yang-php /var/www/vendor/bin/phpcbf \
	    --standard=/var/www/phpcs.xml \
	    --extensions=php \
	   /var/www/src/

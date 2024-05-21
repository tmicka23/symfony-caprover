#!/usr/bin/env bash
 
composer update -n
composer install -n
./bin/console doctrine:migrations:migrate --no-interaction
 
exec "$@"
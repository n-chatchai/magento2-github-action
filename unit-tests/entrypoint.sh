#!/bin/bash

composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD

cd $GITHUB_WORKSPACE

COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

./vendor/bin/phpunit -c $PHP_UNIT_CONFIG_FILE
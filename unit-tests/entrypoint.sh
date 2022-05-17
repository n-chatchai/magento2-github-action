#!/bin/bash

composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD

cd $GITHUB_WORKSPACE

COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

./vendor/bin/phpunit -c $INPUT_PHPUNIT_CONFIG_FILE
#!/bin/bash

composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD
composer global config github-oauth.github.com $GITHUB_OAUTH_TOKEN

cd $GITHUB_WORKSPACE

COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

php bin/magento setup:di:compile

./vendor/bin/phpunit -c $INPUT_PHPUNIT_CONFIG_FILE
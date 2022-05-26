#!/bin/bash
set -e

echo "Setup Magento Composer Credentials:"
test -z "${MAGENTO_MARKETPLACE_USERNAME}" || composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD
test -z "${GITHUB_OAUTH_TOKEN}" || composer global config github-oauth.github.com $GITHUB_OAUTH_TOKEN

echo "Composer Install:"
COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

echo "APP Code Path: $INPUT_APP_CODE_PATH"
echo "Configuration file: $INPUT_PHPSTAN_CONFIG_FILE"
echo "Level: $INPUT_PHPSTAN_LEVEL"

echo "Running PHPStan:"
cd ${GITHUB_WORKSPACE}

vendor/bin/phpstan analyse \
    --level $INPUT_PHPSTAN_LEVEL \
    --no-progress \
    --memory-limit=4G \
    --configuration ${INPUT_PHPSTAN_CONFIG_FILE} \
    ${GITHUB_WORKSPACE}/${INPUT_APP_CODE_PATH}


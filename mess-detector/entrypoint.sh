#!/bin/sh -l

cd $GITHUB_WORKSPACE

echo "Report Formate: ${INPUT_REPORT_FORMAT}"
echo "Ruleset: ${INPUT_RULESET}"
echo "App Code Pah: ${GITHUB_WORKSPACE}/$INPUT_APP_CODE_PATH"

echo "Setup Magento Composer Credentials:"
test -z "${MAGENTO_MARKETPLACE_USERNAME}" || composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD
test -z "${GITHUB_OAUTH_TOKEN}" || composer global config github-oauth.github.com $GITHUB_OAUTH_TOKEN

echo "Composer Install:"
COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

echo "App Code Path: ${GITHUB_WORKSPACE}/${INPUT_APP_CODE_PATH}"

echo "App Code Content: ${GITHUB_WORKSPACE}/${INPUT_APP_CODE_PATH}"
ls -al $GITHUB_WORKSPACE/$INPUT_APP_CODE_PATH

sh -c "${GITHUB_WORKSPACE}/vendor/phpmd/phpmd/src/bin/phpmd \
    $INPUT_APP_CODE_PATH $INPUT_REPORT_FORMAT $INPUT_RULESET"
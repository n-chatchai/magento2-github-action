#!/bin/bash

set -e

echo "MySQL Service Check:"
nc -z -w1 mysql 3306 || (echo "MySQL is not running" && exit)

echo "MySQL Create Test Databases:"
mysql --host mysql --port 3306 -uroot -proot -e "CREATE DATABASE IF NOT EXISTS magento_integration_tests;" || exit

echo "MySQL Databases:"
mysql --host mysql --port 3306 -uroot -proot -e "SHOW DATABASES;" || exit

echo "Setup Magento Composer Credentials:"
test -z "${MAGENTO_MARKETPLACE_USERNAME}" || composer global config http-basic.repo.magento.com $MAGENTO_MARKETPLACE_USERNAME $MAGENTO_MARKETPLACE_PASSWORD

cd $GITHUB_WORKSPACE

echo "Composer Install:"
COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --no-progress

echo "Run Magento setup: $SETUP_ARGS"

SETUP_ARGS="--base-url=http://magento2.test/ \
--db-host=mysql --db-name=magento_integration_tests --db-user=root --db-password=root \
--admin-firstname=John --admin-lastname=Doe \
--admin-email=johndoe@example.com \
--admin-user=johndoe --admin-password=johndoe!1234 \
--backend-frontname=admin --language=en_US \
--currency=$INPUT_CURRENCY --timezone=$INPUT_TIMEZONE \
--elasticsearch-host=es --elasticsearch-port=9200 --elasticsearch-enable-auth=0 \
--sales-order-increment-prefix=ORD_ --session-save=db \
--use-rewrites=1"

php bin/magento setup:install $SETUP_ARGS

echo "Using PHPUnit file: $GITHUB_WORKSPACE/$INPUT_PHPUNIT_CONFIG_FILE"

echo "Prepare for integration tests:"

cp /install-config-mysql-with-es.php dev/tests/integration/etc/install-config-mysql.php

php -r "echo ini_get('memory_limit').PHP_EOL;"

echo "Run the integration tests:"

cd $GITHUB_WORKSPACE/dev/tests/integration && ../../../vendor/bin/phpunit -c $GITHUB_WORKSPACE/$INPUT_PHPUNIT_CONFIG_FILE


#!/bin/sh -l

# Copy the matcher to a shared volume with the host; otherwise "add-matcher"
# can't find it.

cp /problem-matcher.json ${HOME}/

cd $GITHUB_WORKSPACE

test -z "${PHPCS_STANDARD}" && PHPCS_STANDARD=$INPUT_PHPCS_STANDARD
test -z "${PHPCS_SEVERITY}" && PHPCS_SEVERITY=$INPUT_PHPCS_SEVERITY
test -z "${PHPCS_REPORT}" && PHPCS_REPORT=$INPUT_PHPCS_REPORT
test -z "${PHPCS_EXTENSIONS}" && PHPCS_EXTENSIONS=$INPUT_PHPCS_EXTENSIONS

test -z "${PHPCS_STANDARD}" && PHPCS_STANDARD=Magento2
test -z "${PHPCS_SEVERITY}" && PHPCS_SEVERITY=8
test -z "${PHPCS_REPORT}" && PHPCS_REPORT=full
test -z "${PHPCS_EXTENSIONS}" && PHPCS_EXTENSIONS=php

echo "PHPCS report: ${PHPCS_REPORT}"
echo "PHPCS standard: ${PHPCS_STANDARD}"
echo "PHPCS severity: ${PHPCS_SEVERITY}"
echo "PHPCS severity: ${PHPCS_EXTENSIONS}"
echo "App Code Path: ${GITHUB_WORKSPACE}/${INPUT_APP_CODE_PATH}"

echo "App Code Content: ${GITHUB_WORKSPACE}/${INPUT_APP_CODE_PATH}"
ls -al $GITHUB_WORKSPACE/$INPUT_APP_CODE_PATH

sh -c "/root/.composer/vendor/bin/phpcs \
  --report=${PHPCS_REPORT} \
  --extensions=${PHPCS_EXTENSIONS} \
  --severity=${PHPCS_SEVERITY} \
  --standard=$PHPCS_STANDARD  $GITHUB_WORKSPACE/$INPUT_APP_CODE_PATH \
  -s $*"

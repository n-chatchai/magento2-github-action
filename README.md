# Magento 2 Code Auality Github Actions

While [extdn/github-actions-m2](https://github.com/extdn/github-actions-m2) is really good at Magento2 extension development but this one is for Magento2 application development.

Currently supports PHP8.1 hence Magento 2.4.4 or newer.

# [Coding Standardard](code-standard/)
## Sample workflow
```yaml
name: Coding Standard

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  coding-standard:
    name: Coding Standard
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: n-chatchai/magento2-github-action/coding-standard@main
        with:
          app_code_path: app/code/XyzCom
```

# [PHPStan](phpstan/)
## Sample workflow
```yaml
name: PHPStan

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  phpstand:
    name: PHPStan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: n-chatchai/setup-magento2-github-action/phpstan@main
        with:
          app_code_path: app/code/XyzCom
          phpstan_configuration_file: dev/tests/static/testsuite/Magento/Test/Php/_files/phpstan/phpstan.neon
          phpstan_level: 1
        env:
        MAGENTO_MARKETPLACE_USERNAME: ${{ secrets.MAGENTO_MARKETPLACE_USERNAME }}
        MAGENTO_MARKETPLACE_PASSWORD: ${{ secrets.MAGENTO_MARKETPLACE_PASSWORD }}
```

# [Mess Detection](mess-detector/)
## Sample workflow
```yaml
name: Mess Detection

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  mess-detection:
    name: Mess Detection
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: n-chatchai/magento2-github-action/mess-detector@main
        with:
          app_code_path: app/code/XyzCom
          report_format: ansi
          ruleset: cleancode
        env:
        MAGENTO_MARKETPLACE_USERNAME: ${{ secrets.MAGENTO_MARKETPLACE_USERNAME }}
        MAGENTO_MARKETPLACE_PASSWORD: ${{ secrets.MAGENTO_MARKETPLACE_PASSWORD }}
```

# [Unit Testing](unit-tests/)
## Sample workflow
```yaml
name: Unit Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  contents: read

jobs:
  unit-tests:
    name: Unit Testing
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    - name: Unit Test
      uses: n-chatchai/setup-magento2-github-action/unit-tests@main
      env:
        MAGENTO_MARKETPLACE_USERNAME: ${{ secrets.MAGENTO_MARKETPLACE_USERNAME }}
        MAGENTO_MARKETPLACE_PASSWORD: ${{ secrets.MAGENTO_MARKETPLACE_PASSWORD }}
        PHP_UNIT_CONFIG_FILE: dev/tests/unit/phpunit.xml
```

# [Intgeration Test](intgeratoi-tests/)
## Sample workflow

```yaml
name: Integration Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  contents: read


jobs:
  integration-tests:
    name: Magento 2 Integration Tests
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:8.0.21
        env:
          MYSQL_ROOT_HOST: "%"
          MYSQL_ROOT_PASSWORD: root
          MYSQL_SQL_TO_RUN: 'GRANT ALL ON *.* TO "root"@"%";'
        ports:
          - 3306:3306
        options: --tmpfs /tmp:rw --tmpfs /var/lib/mysql:rw --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3
      es:
        image: docker.io/wardenenv/elasticsearch:7.8
        ports:
          - 9200:9200
        env:
          'discovery.type': single-node
          'xpack.security.enabled': false
          ES_JAVA_OPTS: "-Xms64m -Xmx512m"
        options: --health-cmd="curl localhost:9200/_cluster/health?wait_for_status=yellow&timeout=60s" --health-interval=10s --health-timeout=5s --health-retries=3
    steps:

      - uses: actions/checkout@v3
      - uses: n-chatchai/magento2-github-action/integration-tests@main
        with:
          php_unit_file: dev/tests/integration/phpunit.xml
        env:
        MAGENTO_MARKETPLACE_USERNAME: ${{ secrets.MAGENTO_MARKETPLACE_USERNAME }}
        MAGENTO_MARKETPLACE_PASSWORD: ${{ secrets.MAGENTO_MARKETPLACE_PASSWORD }}
```


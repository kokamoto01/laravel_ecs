FROM php:8.1-fpm-buster

# タイムゾーン設定
ENV TZ=UTC \
  # ロケール設定
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  # Composer環境設定
  ## Composerを管理者権限で実行を許可する
  ## Composerがグローバルにインストールされた場合、Composerの設定ファイルが/composerフォルダに保存される
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

# Composerの公式イメージから/usr/bin/composerをDockerコンテナにコピー
## Dockerコンテナ内でComposerコマンドを使えるようにする
COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# ライブラリインストール
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    locales \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && docker-php-ext-install \
    intl \
    pdo_mysql \
    zip \
    bcmath \
  && composer config -g process-timeout 3600

# 設定ファイルのコピー
## php.iniとアプリソースをDockerコンテナにコピーする
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./src /var/www/html/app

# ここから下のコマンドは以下のディレクトリで実行
WORKDIR /var/www/html/app

# Laravel起動設定
RUN composer install -q -n --no-ansi --no-progress --prefer-dist \
  && chown -R www-data:www-data ./ \
  && chmod -R 777 storage bootstrap/cache

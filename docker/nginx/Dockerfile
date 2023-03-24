FROM nginx:1.22-alpine

ENV TZ=Asia/Tokyo

COPY ./docker/nginx/*.conf /etc/nginx/conf.d/
COPY ./src /var/www/html/app

EXPOSE 80

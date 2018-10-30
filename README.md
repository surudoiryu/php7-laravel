# php7 laravel image

# Structure for your project
```
root:
  docker-compose.yml
  - fpm:
    Dockerfile
    php.ini
    supervisord.conf
  - nginx:
    default.conf
    Dockerfile
  - www:
    All the laravel files
```


# docker-compose.yml example:
```
version: '2'

services:

  fpm:
    image: tst_fpm
    build:
      context: .
      dockerfile: ./fpm/Dockerfile
    volumes:
      - ./www:/var/www
      - ./.env-laravel:/var/www/.env
    networks:
      - t-network

  nginx:
    image: tst_nginx
    build:
      context: .
      dockerfile: ./nginx/Dockerfile
    working_dir: /var/www
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf #name default if only 1 on server
    ports:
      - 8084:80
      - 443:443
    networks:
      - t-network

  db:
    image: mysql:5.7
    volumes:
      - mysql-ng:/var/lib/mysql
    ports:
      - 3308:3306
    environment:
      MYSQL_ROOT_PASSWORD: mysqlrootpassword
      MYSQL_USER: dev
      MYSQL_PASSWORD: dev
      MYSQL_DATABASE: dev
    networks:
      - t-network
 

volumes:
  mysql-ng:

networks:
  t-network:
```

# Start it:
```
$ docker-compose up -d
$ docker-compose exec fpm bash
$ container: composer install
```

 # And you are ready to start programming!
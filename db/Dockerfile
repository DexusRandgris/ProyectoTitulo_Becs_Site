# POSTGRESQL DATABASE DOCKER IMAGE
FROM postgres:16.8-alpine3.20
#DEFINED LENGUAGE OS
ENV LANG ne_US.UTF-8
ENV LANGUAGE en_US:en
#DEFINED DATABASE RNV
ENV DB_USER user_becs    
ENV DB_PASSWORD becs123
ENV DB_NAME database_becs
ENV POSTGRES_PASSWORD admin123
#COPY SCRIPT SQL FILES
COPY ./scripts/ /docker-entrypoint-initdb.d/
#DATABASE SCRIPT OVERRIDE
RUN sed -i "s/DB_USER/${DB_USER}/g" /docker-entrypoint-initdb.d/01-create-database.sql
RUN sed -i "s/DB_PASSWORD/${DB_PASSWORD}/g" /docker-entrypoint-initdb.d/01-create-database.sql
RUN sed -i "s/DB_NAME/${DB_NAME}/g" /docker-entrypoint-initdb.d/01-create-database.sql
RUN sed -i "s/DB_USER/${DB_USER}/g" /docker-entrypoint-initdb.d/02-create-schema.sql
RUN sed -i "s/DB_NAME/${DB_NAME}/g" /docker-entrypoint-initdb.d/02-create-schema.sql
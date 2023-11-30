ARG PG_MAJOR
FROM postgres:${PG_MAJOR}-bullseye

ENV PGDATA=/pgdata

COPY . /src
WORKDIR /src

# Prepare the environment
RUN pwd

USER postgres

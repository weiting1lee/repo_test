ARG PG_MAJOR
FROM postgres:${PG_MAJOR}-bullseye

ENV PGDATA=/pgdata

#COPY . /workdir
WORKDIR /

# Prepare the environment
RUN pwd && \
  ls

USER postgres

ENTRYPOINT pwd && \
  ls

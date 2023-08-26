# Simple Docker mlflow server

Very over-simplistic way to publish a docker image with the dependencies needed to run an instance of mlflow server using a postgres backend and s3 store, this to enable tracking as explained in the [mlflow docs](https://mlflow.org/docs/latest/tracking.html#scenario-4-mlflow-with-remote-tracking-server-backend-and-artifact-stores).

![Diagram](.github/img/mlflow-deploy.png)

## Usage

This image is intended to be used through `docker compose`. I am going to deploy this using portainer in my homelab.

Example docker compose:

```yaml
version: '3.7'

services:
  db:
    restart: unless-stopped
    image: postgres:15
    ports:
      - "${POSTGRES_PORT}:5432"
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - dbdata:/var/lib/mysql
  mlflow:
    restart: unless-stopped
    build: keanrawr/mlflow
    image: mlflow_server
    depends_on:
      - db
    ports:
      - "5000:5000"
    environment:
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    command: |
      mlflow server --backend-store-uri postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:${POSTGRES_PORT}/${POSTGRES_DB} --artifacts-destination ${S3_ROOT} --host 0.0.0.0

volumes:
    dbdata:

```

#!/bin/sh
set -e

# Run the database upgrade
mlflow db upgrade "$MLFLOW_BACKEND_STORE_URI"

# Start the MLflow server
exec mlflow server 
    --backend-store-uri "$MLFLOW_BACKEND_STORE_URI" 
    --default-artifact-root "$MLFLOW_DEFAULT_ARTIFACT_ROOT" 
    --host "$MLFLOW_HOST" 
    --port "$MLFLOW_PORT"

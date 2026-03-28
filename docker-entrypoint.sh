#!/bin/sh
set -eu

if [ "${1:-}" = "server" ]; then
  : "${BACKEND_URI:?BACKEND_URI must be set}"
  : "${ARTIFACTS_DESTINATION:?ARTIFACTS_DESTINATION must be set}"

  python /usr/local/bin/wait-for-db.py "${BACKEND_URI}"
  mlflow db upgrade "${BACKEND_URI}"

  exec mlflow server \
    --backend-store-uri "${BACKEND_URI}" \
    --artifacts-destination "${ARTIFACTS_DESTINATION}" \
    --host "${MLFLOW_HOST:-0.0.0.0}" \
    --port "${MLFLOW_PORT:-5000}"
fi

exec "$@"

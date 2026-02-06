FROM python:3.11-slim-bullseye

# Install python packages
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/

# Set environment variables
ENV MLFLOW_HOST=0.0.0.0
ENV MLFLOW_PORT=5000
ENV MLFLOW_BACKEND_STORE_URI=""
ENV MLFLOW_DEFAULT_ARTIFACT_ROOT=""

# Expose the port
EXPOSE 5000

# Run the entrypoint script
ENTRYPOINT ["entrypoint.sh"]

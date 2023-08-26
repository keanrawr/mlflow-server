FROM python:3.11-slim-bullseye

# Install python packages
COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

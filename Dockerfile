# We use this base image because it contains docker
FROM ghcr.io/opensafely/cohortextractor:latest

COPY requirements.txt /requirements.txt
RUN python -m pip install --requirement /requirements.txt
# Always install latest opensafely-cli
RUN python -m pip install opensafely

COPY entrypoint.py /entrypoint.py

ENTRYPOINT ["python", "/entrypoint.py"]

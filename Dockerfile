FROM ghcr.io/opensafely/cohortextractor:latest

COPY requirements.txt /requirements.txt
RUN python -m pip install --requirement /requirements.txt

COPY entrypoint.py /entrypoint.py

ENTRYPOINT ["python", "/entrypoint.py"]

FROM python:3.8

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
EXPOSE 8000
WORKDIR /docs
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]


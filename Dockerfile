FROM python:3.12-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libc6-dev libpq-dev default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*
RUN python -m venv /venv
COPY requirements.txt /tmp/requirements.txt
RUN /venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt
 
FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 libmariadb3 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /venv /venv
ENV PATH=/venv/bin:$PATH
WORKDIR /app
COPY app.py .
ARG VERSION=5.0
RUN echo "$VERSION" > /app/VERSION
ENV APP_PORT=5011
ENV MARKER=datalab
ENV PYTHONDONTWRITEBYTECODE=1
EXPOSE 5011
STOPSIGNAL SIGINT
CMD ["python", "app.py"]



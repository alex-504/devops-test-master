FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_CREATE=false

WORKDIR /app

RUN apt-get update && apt-get install -y curl build-essential \
  && curl -sSL https://install.python-poetry.org | python3 - \
  && ln -s /root/.local/bin/poetry /usr/local/bin/poetry \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY app/pyproject.toml app/poetry.lock* ./

RUN poetry install --no-root --no-interaction --no-ansi

COPY ./app .

CMD ["poetry", "run", "python", "-m", "flask", "--app", "beer_catalog/app", "run", "--host=0.0.0.0"]
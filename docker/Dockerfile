FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_HOME="/opt/poetry" 

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

RUN apt-get update && apt-get install -y curl build-essential \
  && curl -sSL https://install.python-poetry.org | python3 - \
  && ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PATH="${POETRY_HOME}/bin:${PATH}"

COPY app/pyproject.toml app/poetry.lock* ./

RUN poetry install --no-root --no-interaction --no-ansi

COPY ./app .

# Change ownership to non-root user (permission only to /app)
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

CMD ["poetry", "run", "python", "-m", "flask", "--app", "beer_catalog/app", "run", "--host=0.0.0.0"]

# Issues: user is root UID = 0, can access any file in the system. It has to be changed to appuser and limit it to /app
# Issues: HEALTHCHECK not implemented: ECS will not be able to check if the app is running.
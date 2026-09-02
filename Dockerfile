# Base image. The lab hint says python:3.12-slim. It is a Debian based official image with Python preinstalled
FROM python:3.12-slim

# Every instruction after this runs relative to /app, and it is where the app code will live.
WORKDIR /app

# Copy only requirements.txt first, before the rest of the code.
COPY requirements.txt /app

# Install dependencies. This creates a new layer in the image.
RUN pip3 install --no-cache-dir -r requirements.txt

# Now copy everything else from the build context into /app.
COPY . /app

# By default containers run as root. This allows for some safety.
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# runs as appuser instead of root.
USER appuser

# set the default executable
ENTRYPOINT ["python3"]
CMD ["app.py"]
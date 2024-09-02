FROM nvidia/cuda:12.5.0-devel-ubuntu22.04

# # Set non interactive environment
ENV DEBIAN_FRONTEND=noninteractive

# Set shell to bash
SHELL ["/bin/bash", "-c"]

WORKDIR /app

COPY . /app

# Install packages
RUN apt-get update && apt-get install -y \
    python3-dev \
    python3-pip \
    build-essential \
    curl \
    unzip \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O -L "https://github.com/grafana/loki/releases/download/v3.1.1/promtail-linux-amd64.zip" \
    && unzip promtail-linux-amd64.zip \
    && chmod +x promtail-linux-amd64

# Set environment variables
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
ENV PATH="/usr/local/cuda/bin:${PATH}"
# Set environment variables for unbuffered output
ENV PYTHONUNBUFFERED=1

# Install any dependencies if needed
RUN pip install -r requirements.txt

# Expose the port that Uvicorn will run on
EXPOSE 8000

# # Run the application using Uvicorn
# CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
# Run supervisord
CMD ["supervisord", "-c", "/app/svconfig/api2.conf"]

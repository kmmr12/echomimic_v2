FROM runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Clone EchoMimic V2 repository
RUN git clone https://github.com/kmmr12/echomimic_v2.git /app/echomimic_v2

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Install EchoMimic V2 dependencies
WORKDIR /app/echomimic_v2
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Install runpod
RUN pip install --no-cache-dir runpod

# Copy handler
COPY handler.py /app/handler.py

# Set Python path
ENV PYTHONPATH=/app/echomimic_v2:${PYTHONPATH}

# Create model cache directory
RUN mkdir -p /app/models

WORKDIR /app

# Run handler
CMD ["python", "-u", "handler.py"]

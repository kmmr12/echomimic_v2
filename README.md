# EchoMimic V2 - RunPod Serverless Deployment

Audio-driven talking head video generation using EchoMimic V2 on RunPod serverless infrastructure.

## Overview

This repository contains everything needed to deploy EchoMimic V2 as a RunPod serverless endpoint.

## Quick Deploy via RunPod Hub

1. Fork/clone this repository
2. Go to https://www.runpod.io/console/hub
3. Click "Submit Endpoint"
4. Link your repository
5. RunPod builds and deploys automatically

## API Usage

### Input
```json
{
  "input": {
    "audio_base64": "base64_audio",
    "image_base64": "base64_image"
  }
}
```

### Output
```json
{
  "output": {
    "video_base64": "base64_video"
  }
}
```

## Requirements

- GPU: NVIDIA A40 (48GB VRAM) minimum
- Container Disk: 40 GB
- Python 3.10+

## Files

- Dockerfile - Container definition
- handler.py - RunPod serverless handler
- requirements.txt - Dependencies
- runpod_hub.json - Hub configuration

## Author

[@kmmr12](https://github.com/kmmr12)

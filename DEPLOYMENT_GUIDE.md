# EchoMimic V2 RunPod Deployment Guide

## Files Created
-  - Container definition
-  - RunPod serverless handler
-  - Python dependencies
-  - RunPod Hub configuration
-  - Test definitions

## Deployment Steps

### Option A: Deploy via RunPod CLI (Recommended)

1. **Install RunPod CLI**
   ```bash
   pip install runpod
   runpod login
   ```

2. **Build and Push Docker Image**
   ```bash
   cd /opt/echomimic_v2_deploy
   
   # Build image
   docker build -t your-dockerhub-username/echomimic-v2:latest .
   
   # Push to Docker Hub
   docker login
   docker push your-dockerhub-username/echomimic-v2:latest
   ```

3. **Create RunPod Endpoint**
   ```bash
   runpod create endpoint \
     --name echomimic-v2 \
     --image your-dockerhub-username/echomimic-v2:latest \
     --gpu-type "NVIDIA A40" \
     --min-workers 0 \
     --max-workers 3
   ```

### Option B: Deploy via RunPod Web Console

1. **Build Docker Image Locally**
   ```bash
   cd /opt/echomimic_v2_deploy
   docker build -t your-dockerhub-username/echomimic-v2:latest .
   docker push your-dockerhub-username/echomimic-v2:latest
   ```

2. **Go to RunPod Console**
   - Navigate to https://www.runpod.io/console/serverless
   - Click "New Endpoint"

3. **Configure Endpoint**
   - Name: `echomimic-v2`
   - Container Image: `your-dockerhub-username/echomimic-v2:latest`
   - Container Disk: `40 GB`
   - GPU Type: `NVIDIA A40` or `NVIDIA A6000`
   - Min Workers: `0`
   - Max Workers: `3`
   - Idle Timeout: `5 seconds`

4. **Copy Endpoint Details**
   After deployment, copy:
   - Endpoint ID (e.g., `abc123def456`)
   - API Key (e.g., `rpa_XXX...`)
   
   Your endpoints will be:
   - RUN: `https://api.runpod.ai/v2/{endpoint-id}/run`
   - STATUS: `https://api.runpod.ai/v2/{endpoint-id}/status`

### Option C: Deploy to RunPod Hub (Public)

1. **Create GitHub Repository**
   ```bash
   cd /opt/echomimic_v2_deploy
   git init
   git add .
   git commit -m Initial EchoMimic V2 RunPod deployment
   git remote add origin https://github.com/YOUR_USERNAME/echomimic-v2-runpod.git
   git push -u origin main
   ```

2. **Submit to RunPod Hub**
   - Go to https://www.runpod.io/console/hub
   - Click "Submit Endpoint"
   - Link your GitHub repo
   - RunPod will:
     - Read `runpod_hub.json` for configuration
     - Build your Docker image
     - Run tests from `runpod_tests.json`
     - Publish to RunPod Hub

## Next Steps After Deployment

1. **Get your endpoint credentials:**
   ```bash
   RUNPOD_ECHOMIMIC_KEY=rpa_YOUR_KEY_HERE
   RUNPOD_ECHOMIMIC_RUN=https://api.runpod.ai/v2/YOUR_ENDPOINT_ID/run
   RUNPOD_ECHOMIMIC_STATUS=https://api.runpod.ai/v2/YOUR_ENDPOINT_ID/status
   ```

2. **Add to VIDS Pro .env:**
   ```bash
   ssh root@135.181.99.172
   nano /opt/vids_pro/.env
   # Uncomment and fill in the ECHOMIMIC variables
   ```

3. **Update RunPod Adapter:**
   The backend is already configured to use these credentials.

4. **Test the integration:**
   ```bash
   curl -X POST http://135.181.99.172:8003/jobs/talking-head \
     -H "X-VIDS-KEY: your_vids_api_key" \
     -F "audio=@test_audio.wav" \
     -F "image=@test_portrait.png"
   ```

## Important Notes

### Model Weights
EchoMimic V2 requires downloading model weights. You have two options:

1. **Download during build** (slower build, faster cold start):
   Add to Dockerfile before CMD:
   ```dockerfile
   RUN python /app/echomimic_v2/download_models.py
   ```

2. **Download on first run** (faster build, slower cold start):
   Models download automatically on first inference (already configured)

### Estimated Costs
- **Build time**: ~10-15 minutes
- **Image size**: ~8-12 GB
- **Inference time**: ~30-60 seconds per video
- **Cost per run**: ~/bin/zsh.10-0.20 (depending on GPU type and duration)

### GPU Requirements
- Minimum: NVIDIA A40 (48GB VRAM)
- Recommended: NVIDIA A6000 or RTX 4090
- Not recommended: RTX 3090 (may run out of VRAM)

## Troubleshooting

### Build Fails
- Check Docker has enough disk space (40GB+)
- Verify GitHub repo is accessible
- Check requirements.txt for version conflicts

### Inference Fails
- Verify model weights downloaded correctly
- Check GPU VRAM usage (needs ~30GB)
- Review handler.py logs in RunPod console

### Slow Performance
- Increase GPU type (A40 → A6000)
- Pre-download models during build
- Increase min workers for faster cold starts

## Support

- RunPod Docs: https://docs.runpod.io/
- EchoMimic V2: https://github.com/kmmr12/echomimic_v2
- VIDS Pro Integration: Check backend/routes/talking_head.py

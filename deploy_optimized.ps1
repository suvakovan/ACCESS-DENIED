# Optimized Deployment Script for Google Cloud Run
# Goal: Free Tier compatible, Low Maintenance, "Serverless"

# 1. Get Project ID (Automatic detection or User Input)
$currentProject = gcloud config get-value project 2>$null
if ([string]::IsNullOrWhiteSpace($currentProject)) {
    Write-Error "No active Google Cloud project found. Please run: gcloud config set project <YOUR_PROJECT_ID>"
    exit 1
}
Write-Host "Using Project: $currentProject" -ForegroundColor Cyan

# 2. Variables
$APP_NAME = "cyber-portfolio"
$REGION = "us-central1" # Best availability for free tier
$IMAGE_TAG = "gcr.io/$currentProject/$APP_NAME"

# 3. Build Container (Using Cloud Build - No local Docker needed)
Write-Host "`n[1/3] Building Container Image in Google Cloud..." -ForegroundColor Yellow
gcloud builds submit --tag $IMAGE_TAG .
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 4. Deploy to Cloud Run
Write-Host "`n[2/3] Deploying to Cloud Run (Optimized)..." -ForegroundColor Yellow
# Flags explanation:
# --memory 128Mi: Nginx is very light, 128MB is plenty. Saves money.
# --max-instances 1: Prevents unexpected bills if traffic spikes.
# --min-instances 0: Scales to zero when no one is visiting (FREE).
gcloud run deploy $APP_NAME `
    --image $IMAGE_TAG `
    --platform managed `
    --region $REGION `
    --allow-unauthenticated `
    --memory 128Mi `
    --cpu 1 `
    --max-instances 1 `
    --min-instances 0 `
    --port 80

Write-Host "`n[3/3] Deployment Complete!" -ForegroundColor Green

# Deploy to Google Cloud Run (PowerShell)

# Variables
$PROJECT_ID = "YOUR_PROJECT_ID" # Replace with your GCC Project ID
$APP_NAME = "cyber-portfolio"
$REGION = "us-central1" # Choose your region
$TAG = "gcr.io/$PROJECT_ID/$APP_NAME"

Write-Host "1. Building Docker Image..."
docker build -t $APP_NAME .

# Check if gcloud is installed
if (Get-Command "gcloud" -ErrorAction SilentlyContinue) {
    Write-Host "2. Tagging Image for GCR..."
    docker tag "${APP_NAME}:latest" $TAG

    Write-Host "3. Pushing Image to GCR..."
    docker push $TAG

    Write-Host "4. Deploying to Cloud Run..."
    gcloud run deploy $APP_NAME --image $TAG --platform managed --region $REGION --allow-unauthenticated
} else {
    Write-Host "gcloud CLI is not installed or not in PATH."
    Write-Host "To deploy, please install Google Cloud SDK and authenticate."
    Write-Host "Then run manually:"
    Write-Host "  docker tag ${APP_NAME}:latest $TAG"
    Write-Host "  docker push $TAG"
    Write-Host "  gcloud run deploy $APP_NAME --image $TAG --platform managed --region $REGION --allow-unauthenticated"
}

kubectl apply -f starter/apps/blue-green/green.yml
until kubectl rollout status deployment/green -n udacity; do
  echo "Deploying..."
  sleep 1
done

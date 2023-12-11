#!/bin/bash -xe

max_attempts=60
attempt=1
while [ $attempt -le $max_attempts ]; do
  if ping -c 1 google.com > /dev/null 2>&1; then
    echo "Internet connection established!"
    break
  else
    echo "No internet connection. Attempt $attempt of $max_attempts. Retrying in 1 minute..."
    sleep 60
    ((attempt++))
  fi
  if [ $attempt -gt $max_attempts ]; then
    echo "Max attempts reached. Internet connection could not be established."
    exit 1
  fi
done

sudo apt update
sudo apt install -y nginx 
echo "I am ${workload_name} workload." | sudo tee /var/www/html/test
EOL
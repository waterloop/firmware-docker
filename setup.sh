docker build -t firmware_docker .
docker run --name firmware_dev_env -p 2222:2222 -v $HOME:/home/dev/host firmware_docker &
sleep 5
docker stop firmware_dev_env

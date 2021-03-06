#!/bin/bash
set -ex

HOST_NAME="${HOST_NAME:raspberrypi}"
PASSWORD="${PASSWORD:raspberry}"

# copy ssh key to pi and add the host key to .ssh/known_hosts
sed -i '' '/^raspberrypi.local/d' ~/.ssh/known_hosts
ssh-keyscan raspberrypi.local >> ~/.ssh/known_hosts
echo raspberry | sshpass ssh-copy-id -f pi@raspberrypi.local

set +e
export HOST_NAME=$HOST_NAME PASSWORD=$PASSWORD
ENV_VARS='$HOST_NAME:$PASSWORD'
envsubst "$ENV_VARS" < provision.sh | ssh pi@raspberrypi.local sh -
#set -e
set +x
printf "%s" "Waiting for $HOST_NAME to reboot and come back online"
for i in {1..25}
do
    sleep 1
    printf "%c" "."
done
echo
set -ex

# copy ssh key to pi and add the host key to .ssh/known_hosts
sed -i '.bkp' '/^'"$HOST_NAME"'/d' ~/.ssh/known_hosts
ssh-keyscan $HOST_NAME >> ~/.ssh/known_hosts

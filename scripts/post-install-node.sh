#!/usr/bin/env bash

# Note: This script runs after the ansible install, use it to make configuration
# changes which would otherwise be overwritten by ansible.
sudo su

# Update the docker config to allow OpenShift's local insecure registry. Also
# use json-file for logging, so our Splunk forwarder can eat the container logs.
# json-file for logging
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver=json-file --log-opt max-size=1M --log-opt max-file=3"' /etc/sysconfig/docker
systemctl restart docker

curl -s https://repo.toast.sh/helper/slack.sh | \
 bash -s -- --token=TATRUQ6P2/BAY9WSD7C/1bCckidSMB8KctWf2CgbHGtN --color=good Post Installed: \`node\` $(hostname)

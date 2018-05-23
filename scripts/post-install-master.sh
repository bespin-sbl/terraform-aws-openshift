#!/usr/bin/env bash

# Note: This script runs after the ansible install, use it to make configuration
# changes which would otherwise be overwritten by ansible.
sudo su

curl -s http://repo.toast.sh/helper/slack.sh | \
 bash -s -- --token=T95EAPLT1/B9CNR2Q9M/0c31312w1aEts55hKVBVFttG Post Install: \`master\` $(hostname)

# Create an htpasswd file, we'll use htpasswd auth for OpenShift.
htpasswd -cb /etc/origin/master/htpasswd developer password#123

# Update the docker config to allow OpenShift's local insecure registry. Also
# use json-file for logging, so our Splunk forwarder can eat the container logs.
# json-file for logging
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver=json-file --log-opt max-size=1M --log-opt max-file=3"' /etc/sysconfig/docker
systemctl restart docker

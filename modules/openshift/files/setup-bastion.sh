#!/usr/bin/env bash

# This script template is expected to be populated during the setup of a
# OpenShift bastion. It runs on host startup.

curl -s http://repo.toast.sh/helper/slack.sh | \
 bash -s -- --token=TATRUQ6P2/BAY9WSD7C/1bCckidSMB8KctWf2CgbHGtN --color=good Started: \`bastion\` $(hostname)

#!/usr/bin/env bash

cd ~/terraform-aws-openshift

eval `ssh-agent -s`

V=$1

echo "" > /tmp/make-${V}.log
echo ">> start ${V}.. $(date)" >> /tmp/make-${V}.log
make ${V}                      >> /tmp/make-${V}.log
echo ">> end ${V}..   $(date)" >> /tmp/make-${V}.log

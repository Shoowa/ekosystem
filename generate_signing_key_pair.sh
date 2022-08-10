#!/bin/bash
step certificate create root.linkerd.cluster.local /tmp/ca.crt /tmp/ca.key \
    --profile root-ca --no-password --insecure &&
    kubectl create secret tls linkerd-trust-anchor \
    --cert=/tmp/ca.crt --key=/tmp/ca.key --namespace=linkerd

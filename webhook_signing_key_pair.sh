#!/bin/bash
step certificate create webhook.linkerd.cluster.local /tmp/webca.crt /tmp/webca.key \
    --profile root-ca --no-password --insecure \
    --san webhook.linkerd.cluster.local &&
    kubectl create secret tls webhook-issuer-tls \
    --cert=/tmp/webca.crt --key=/tmp/webca.key --namespace=linkerd &&
    kubectl create secret tls webhook-issuer-tls \
    --cert=/tmp/webca.crt --key=/tmp/webca.key --namespace=linkerd-viz

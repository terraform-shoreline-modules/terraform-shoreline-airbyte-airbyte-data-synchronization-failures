#!/bin/bash

# Set the namespace and deployment name for Airbyte
NAMESPACE=${NAMESPACE}
DEPLOYMENT_NAME=${DEPLOYMENT_NAME}

# Restart the deployment to restart the data synchronization process
kubectl rollout restart deployment $DEPLOYMENT_NAME -n $NAMESPACE

# Verify that the deployment has restarted successfully
kubectl rollout status deployment $DEPLOYMENT_NAME -n $NAMESPACE
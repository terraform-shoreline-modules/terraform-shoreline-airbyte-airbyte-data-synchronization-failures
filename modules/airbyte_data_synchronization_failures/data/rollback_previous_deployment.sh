bash
#!/bin/bash

# Define the deployment and namespace
DEPLOYMENT=${DEPLOYMENT_NAME}
NAMESPACE=${NAMESPACE}

# Get the current deployment revision
CURRENT_REVISION=$(kubectl rollout history deployment $DEPLOYMENT -n $NAMESPACE | grep -o '[0-9]*' | tail -1)

# Get the previous deployment revision
PREVIOUS_REVISION=$((CURRENT_REVISION - 1))

# Rollback to the previous deployment revision
kubectl rollout undo deployment $DEPLOYMENT -n $NAMESPACE --to-revision=$PREVIOUS_REVISION
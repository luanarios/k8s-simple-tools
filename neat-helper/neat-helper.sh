#!/bin/bash

# This script expects for a CSV file with columns "context, "namespace", "resource_type", "resource_name" comma separated.

if [ $# -eq 0 ];
then
    echo "--- Applied kube-config:"
    find ~/.kube -type l -exec sh -c 'echo "{} -> $(readlink -f "{}")"' \;
    read -r -p "--- Do you want to continue with this kube-config? [Y/n] " response
    if [[ "$response" =~ ^[yY]$ ]];
    then
        read -r -p "--- Desired kube-context: " context
        kubectl config get-contexts $context > /dev/null
        if [ $? -eq 1 ]; then exit 2; fi
        read -r -p "--- Desired namespace: " namespace
        kubectl get namespace $namespace --context $context > /dev/null
        if [ $? -eq 1 ]; then exit 3; fi
        read -r -p "--- Desired resource type (Deployment, Service...): " resource_type
        read -r -p "--- Desired resource name: " resource_name
        YAML=$(kubectl neat get -- -n $namespace $resource_type $resource_name -o yaml --context $context)
        if [ $? -eq 0 ]; then
            echo "$YAML" | kubectl neat > $resource_name.yaml
            echo "--- Exported YAML: $resource_name.yaml" 
        else
            exit 4
        fi
    else
        echo "--- Please set desired kube-config."
        exit 1
    fi
elif [ $# -gt 1 ];
then
    echo "$0: Too many arguments: $@"
    exit 1
else
    awk 'NR > 1 {print}' "$1" | while IFS=, read -r context namespace resource_type resource_name; do
        YAML=$(kubectl neat get -- -n $namespace $resource_type $resource_name --context $context -o yaml)
        if [ $? -eq 0 ]; then
            echo "$YAML" | kubectl neat > $resource_name.yaml
            echo "--- Exported YAML: $resource_name.yaml" 
        else
            exit 5
        fi
    done
fi
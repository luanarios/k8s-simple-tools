#!/bin/bash

# This script expects for a CSV file with columns "context, "namespace", "resource_type", "resource_name" comma separated.

if [ $# -eq 0 ];
then
    echo "$0: Missing arguments"
    exit 1
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
            exit 4
        fi
    done
fi
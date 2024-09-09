#!/bin/bash

csv_file="teste.csv"

awk 'NR > 1 {print}' "$csv_file" | while IFS=, read -r context namespace resource_type resource_name; do
    YAML=$(kubectl neat get -- -n $namespace $resource_type $resource_name --context $context -o yaml)
    if [ $? -eq 0 ]; then
        echo "$YAML" | kubectl neat > $resource_name.yaml
        echo "--- YAML exportado em: $resource_name.yaml" 
    else
        exit 4
    fi
done
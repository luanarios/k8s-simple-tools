#!/bin/bash

echo "--- Kube-config atual:"
find ~/.kube -type l -exec sh -c 'echo "{} -> $(readlink -f "{}")"' \;
read -r -p "--- Deseja utilizar esse config? [Y/n] " response
if [[ "$response" =~ ^[yY]$ ]];
then
    read -r -p "--- Informe o context: " context
    kubectl config get-contexts $context > /dev/null
    if [ $? -eq 1 ]; then exit 2; fi
    read -r -p "--- Informe o namespace: " namespace
    kubectl get namespace $namespace --context $context > /dev/null
    if [ $? -eq 1 ]; then exit 3; fi
    read -r -p "--- Informe o tipo do recurso (Deployment, Service...): " resource_type
    read -r -p "--- Informe o nome do recurso: " resource_name
    YAML=$(kubectl neat get -- -n $namespace $resource_type $resource_name -o yaml --context $context)
    if [ $? -eq 0 ]; then
        echo "$YAML" | kubectl neat > $resource_name.yaml
        echo "--- YAML exportado em: $resource_name.yaml" 
    else
        exit 4
    fi
else
    echo "--- Configure o kube-config desejado"
    exit 1
fi
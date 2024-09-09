# neat-helper

Use this to apply kubectl-neat on multiple Kubernetes manifests.

## Requirements

- kubectl-neat
https://github.com/itaysk/kubectl-neat/tree/master

## Usage

There are two modes of usage, which depends on desired input size.

### Interactive way

If you want to export a single manifest, you could simple run:

```bash
chmod +x ./neat-helper/neat-helper.sh

./neat-helper/neat-helper.sh
```

Then the terminal will ask for input data (context, namespace, resource type and resource name)

### Importing CSV

This method is invoked by passing a csv file as argument, it's useful for multiple export.

```bash
chmod +x ./neat-helper/neat-helper.sh

./neat-helper/neat-helper.sh sample.csv
```
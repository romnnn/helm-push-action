### Helm push action

GiHub action to package and publish your helm chart to a registry such as chartmuseum or harbor.

```yaml
name: build and push chart
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: romnnn/helm-push-action@v1
      with:
        charts-dir: '.'
        chart-name: 'my-awesome-chart'
        force: true
        chart-version: '1.2.5'
        app-version: '1.2.5'
        registry: 'https://my.registry.com'
        user: '${{ secrets.HELM_REGISTRY_USER }}'
        password: ${{ secrets.HELM_REGISTRY_PASSWORD }}
```

#### License

[MIT](LICENSE)

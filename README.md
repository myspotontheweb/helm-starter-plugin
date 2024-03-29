# helm-starter-plugin

Helm plugin designed to generate the files required for CI/CD

# Software Dependencies

On Ubuntu

```
sudo apt-get install -y make git gettext-base
```

On Mac

```
brew install make git gettext
```

# Installation

```
helm plugin install https://github.com/myspotontheweb/helm-starter-plugin.git
```

or to update an existing installation

```
helm plugin update starter
```

# Usage

The default starter repo is [myspotontheweb/helm-default-starter](https://github.com/myspotontheweb/helm-default-starter) and available without authentication 
when using the https protocol.

```
export GIT_PROTO=https://github.com/

helm starter NAME=my-project NAMESPACE=myteam PORT=9001 
```

## Recreating files

You can regenerate the files by first deleting them

```
$ helm starter clean
rm -rf chart
rm -f Dockerfile
rm -f .travis.yml

$ helm starter NAME=my-project NAMESPACE=myteam PORT=9001 ORG=myspotontheweb STARTER=default
Creating myproject
cat chart/.ci/Dockerfile | envsubst '$NAME $FILTERED_NAME $NAMESPACE $PORT' > Dockerfile
cat chart/.ci/.travis.yml | envsubst '$NAME $FILTERED_NAME $NAMESPACE $PORT' > .travis.yml
```

## Remove caching

Helm chart starter packs are stored under the helm client homedir: ~/.helm/starters

```
$ helm starter clean-starter STARTER=default
rm -rf /home/mark/.helm/starters/default
```

# Starter packs

The plugin uses [helm starter packs](https://helm.sh/docs/developing_charts/#chart-starter-packs) to customize the build and deployment for each technology area.

To customize the file generation you can optionally specify the ORG and STARTER settings: 

```
helm starter NAME=my-project NAMESPACE=myteam PORT=9001 ORG=myspotontheweb STARTER=default
```

This will tell the plugin to download the default starter pack located here: 

* [myspotontheweb/helm-default-starter](https://github.com/myspotontheweb/helm-default-starter) 

## Starter pack structure

A starter pack is expected to contain the normal files associated with a helm chart plus
an additional directory container files used for building and deployment

```
├── charts
├── Chart.yaml
├── README.md
├── templates
│   ├── ..
│   └── ..
├── values.yaml
└── .ci
    ├── Dockerfile
    └── .travis.yml
```

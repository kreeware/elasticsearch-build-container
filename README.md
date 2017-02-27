Elasticsearch (and X-Pack) build container, using Docker.

# Installation

## Mac

- `brew cask install docker`, or manually install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)
- Open the app, it will install the cli tools and start the vm

## Windows

- Install [Docker for Windows](https://docs.docker.com/docker-for-windows/)

## Others

- Check [Docker Overview](https://www.docker.com/products/overview) for the package you need

# Building

## Token Creation

You'll need to start by creating a [gitub token](https://github.com/settings/tokens). 

WHen creating your token, choose the following scopes:

- *repo* (Full control of private repositories)
- *read:org*, located under *admin:org*

Click *Generate token* and copy the output.

## Build arguments

Next, copy the `build-args.default` file to `build-args`, open it up, and set all of the values.

- `GH_USER`: Your Github username
- `GH_TOKEN`: The token you created on Github
- `GH_BRANCH`: The branch you want to build, *master* by default
- `ELASTICSEARCH_REPO`: The HTTPS URL to the elasticsearch repo
- `XPACK_REPO`: The HTTPS URL to the x-pack repo

## Create the builds

Now you're ready to build the docker image, which will checkout and build Elasticsearch and X-Pack.

If you're on a unix machine, you can use `./build.sh` to create the image quick and easy.

If you're not on a unix machine, you'll need to pass in some build arguments. Consult `./build.sh` for what to pass in.

# Running the image

There are a limited number of commands you can use:

- `copy` the build output
- `start` Elasticsearch
- `xpack` is used as an alias to commands in `bin/x-pack`

See below for more detailed information about using the commands.

## Copying the build assets

To copy the build zip files, you will need to set up a local path as the `/build` volume and run the image with the `copy` command, like so:

`docker run -v "${BUILD}":/build elastic-build copy`

If you're on a unix machine, simply run `./copy.sh`

## Starting Elasticsearch

To run Elasticsearch, simply use the `start` command: 

`docker run elastic-build start`

Configuration is read from the `/config` path, and copied from the elasticsearch config path by default of no files exist there. Any additional arguments will be passed to elasticsearch executable, so something like this is valid:

`docker run elastic-build start -Ediscovery.zen.ping.unicast.hosts=['']`

## Using X-pack commands

The `xpack` command is a pointed to the binaries available in `bin/x-pack`, so you need to also provide the x-pack command you wish to execute as well as any additional parameters it may need. For example, if you wanted to add a user, it would look something like this:

`docker run elastic-build xpack users useradd admin -r superuser -p notsecure`

Note that normal user prompts will not work, so you must pass in all required parameters.
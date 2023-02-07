# MYROCKERSPATIAL_BUILT

This is a template of My rocker spatial workspace

## Usage

### Pre-requisites

This program runs in a docker container, so all you need is to install
[docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/)
on your system.

### To Run

1. Clone this repository.

```{sh}
git clone git@github.com:naru-T/myrockerspatial_build.git
```

1. Change the directory to the project directory.

```{sh}
cd MyRockerSpatial_build
```

1. With [docker-compose](https://docs.docker.com/compose/install/) installed, simply run:

```{sh}
docker-compose up -d --b
```

1. Access the application at `http://localhost:8787`

1. login name: rstudio / password: passwd

1. To stop the docker container, run:

```{sh}
docker-compose down
```

## To contribute

If an issue doesn't exist, create one. Developments should be made on branches
from `develop` and merge requests made to develop. The `master` branch will
house all working code ready for preview and then later release. Thanks
:smile:

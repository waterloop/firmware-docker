## Firmware Docker Container

This repo contains the docker file which we will use for executing git hub actions to verify that PRs build before we merge them

To run this container use the following command:
```
docker run --rm \
          -v $(pwd):/firmware \
          waterloop-firmware $*
```
and replace `$*` with the python script that you would like to run

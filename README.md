# Home assitiant supervised in an docker container
The point is to have supervised feautures like add-ons in docker
# Note configs we will be temp if volume isn't mounted
## How to run 
### Docker run
``` sh
  docker run -d \
  --name homeassistant-supervised-container \
  --cap-add=SYS_ADMIN \
  --cap-add=NET_ADMIN \
  --security-opt seccomp=unconfined \
  --cgroupns=host \
  --privileged \
  -v /path/for/ha:/homeassistant \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 8123:8123 \
  brrock/home-assistant-supervised:latest
  # no mount 
  docker run -d \
  --name homeassistant-supervised-container \
  --cap-add=SYS_ADMIN \
  --cap-add=NET_ADMIN \
  --security-opt seccomp=unconfined \
  --cgroupns=host \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 8123:8123 \
  brrock/home-assistant-supervised:latest
```
### Docker compose
``` sh
sudo docker compose up -d # make sure to do sudo
```
``` yaml
services:
  homeassistant:
    container_name: homeassistant-supervised-container
    image: brrock/home-assistant-supervised:latest
    privileged: true
    restart: unless-stopped
    volumes:
      - /path/for/ha:/homeassistant
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "8123:8123"

```
#### Image tag not mean HA version updates are handle via HA's GUI 
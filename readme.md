# [edifus/chia](https://github.com/edifus/docker-chia)

[chia-blockchain](https://github.com/Chia-Network/chia-blockchain) - Chia blockchain python implementation (full node, farmer, harvester, timelord, and wallet)

## Supported Architectures

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose (recommended)

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  rutorrent:
    image: ghcr.io/edifus/chia
    container_name: chia
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /path/to/config:/config
      - /path/to/plots:/plots
    ports:
      - 8444:8444 # node - optional
      - 8447:8447 # farmer - optional
      - 8449:8449 # wallet - optional
    restart: unless-stopped
```

### docker cli

```
docker run -d \
  --name=chia \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 8444:8444 `# node - optional` \
  -p 8447:8447 `# farmer - optional` \
  -p 8449:8449 `# wallet - optional` \
  -v /path/to/config:/config \
  -v /path/to/plots:/plots \
  --restart unless-stopped \
  ghcr.io/edifus/chia
```


## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8444` | optional: chia-node port |
| `-p 8447` | optional: chia-farmer port |
| `-p 8449` | optional: chia-wallet port |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e KEYS=generate` | options: 'generate' (default) or path to text file mounted in container (/keys) containing mnemonic |
| `-e CACERTS_DIR=/ca` | optional: provide cacerts on container init for proper communication |
| `-e HARVESTER_ONLY=false` | Boolean to enable/disable harvester, FARMER_ADDRESS and FARMER_PORT required if not running a farmer in same container |
| `-e FARMER_ADRESS=x.x.x.x` | optional: remote farmer IP for harvester to report to |
| `-e FARMER_PORT=8447` | optional: remote farmer port for harvester to report to |
| `-e FARMER_ONLY=false` | Boolean to enable/disable farmer, NODE_ADDRESS required if not running node in same container |
| `-e NODE_ADDRESS=x.x.x.x` | optional: remote node IP for farmer to get new singage points |
| `-e WALLET_ONLY=false` | Boolean to enable/disable wallet, local node in same container required |
| `-e NODE_ONLY=false` | Boolean to enable/disable node |
| `-e TESTNET=false` | Boolean to enable/disable testnet instead of mainnet |
| `-e FULL_NODE_PORT=58444` | Port for testnet connections |
| `-e TAIL_DEBUG_LOGS=false` | Tail debug logs to docker logs |
| `-v /config` | where ruTorrent should store it's config files |
| `-v /plots` | optional: path to your plots folder |
| `-v /keys` | optional: path to your chia mnemonic text file |
| `-v /ca` | optional: path to your cacerts folder |


## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.


## Umask for running applications

This image provides the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod, it masks permissions based on it's value. Please read up [here](https://en.wikipedia.org/wiki/Umask) for more information.


## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


## Application Setup

todo..

* If `FARMER_ONLY`, `HARVESTER_ONLY`, `NODE_ONLY`, `WALLET_ONLY` are not provided a full-node will be started.
* `WALLET_ONLY=true` **requires** `NODE_ONLY=true`.
* `HARVESTER_ONLY=true` and `FARMER_ONLY=false` requires `FARMER_ADDRESS` and `FARMER_PORT` to be set to connect to a remote farmer.
* `FARMER_ONLY=true` and `NODE_ONLY=false` requires `NODE_ADDRESS` to be set to get new signage points.
* `HARVESTER_ONLY=true` requires `CACERTS_DIR` to be set. Copy `ca` certs folder from a previously setup full-node. Information can be found on the official wiki https://github.com/Chia-Network/chia-blockchain/wiki/Farming-on-many-machines.
* `CACERTS_DIR` will import existing cacerts to generate other certificate. This will only be imported once to prevent certs from being regenerated repeatedly, see below.
* **CAUTION: Providing `CACERTS_DIR` after starting a node/wallet will reset certs and require deleteing /config and resyncing the entire blockchain.**


## Docker Mods


## Support Info
* Shell access whilst the container is running: `docker exec -it chia /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f chia`


## Updating Info

Below are the instructions for updating containers:

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull rutorrent`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d rutorrent`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run
* Update the image: `docker pull ghcr.io/edifus/chia`
* Stop the running container: `docker stop chia`
* Delete the container: `docker rm chia`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (only use if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --run-once chia
  ```
* You can also remove the old dangling images: `docker image prune`

### Image Update Notifications - Diun (Docker Image Update Notifier)
* Recommended to use [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended.


## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/edifus/docker-chia.git
cd docker-chia
docker build  --no-cache --pull -t edifus/chia:test .
```


## Versions

* **2021.05.16:** - Inital version, based on linuxserver.io ubuntu base and official chia-docker container

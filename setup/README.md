# Setup
- Run `install.sh` to install packages needed.
- Run `preload.sh` to pre-build some of the docker containers. Tanner especailly takes a long time to build so be sure to preload.
- Change `/etc/ssh/sshd_config` to have the following options.
```
Port 2222
PasswordAuthentication yes
```

# 1 Cowrie Guide
This is a basic guide of how to install and run Cowrie.

## 1.1 Run Cowrie
You can run Cowrie by running the following.
```
cd ~/cowrie/docker/
docker-compose up
```

If you want to stop the running container you will need to press `ctrl+c` to cancel.

Logs can be viewed via:
```
tail ~/cowrie/docker/cowrie-var/log/cowrie/cowrie.json
```

## 1.2 Configuring Cowrie
## Default config
The default config can be viewed here: https://github.com/cowrie/cowrie/blob/master/etc/cowrie.cfg.dist 

## Custom config
The Cowrie config file is under `~/cowrie/docker/cowrie-etc/`. Try changing the default hostname
```
hostname = svr04
```

# 2 Exercises
## 2.1 Fake an attack against the honeypot
- SSH to the server using credentials in the default userdb. Try pulling down a file from the internet using wget and exit the shell.
- The default userdb is here: https://github.com/cowrie/cowrie/blob/master/etc/userdb.example

## 2.2 View a downloaded file
- Connect to the honeypot and download a file using wget. The log will output the filehash of the file.
- Get the file from the honeypot artifacts.

```
sudo cat ~/cowrie/docker/cowrie-var/lib/cowrie/downloads/<filehash>
```

## 2.3 Make your honeypot "sweeter"
- Try configuring a non-default hostname, kernel version, ssh version for the honeypot.
- Modify the default userdb.

# 3 Enable telnet
Run cowrie with the extra port mapping and telnet option.
```
[telnet]

# Enable Telnet support, disabled by default
enabled = true
```
Connect to your server using telnet on port 23.

# 4 Submittting malware samples to MISP
- Uncomment the output_misp module in `~/cowrie/docker/cowrie-etc/cowrie.cfg.dst`
- Replace the base_url and api_key with the ones provided.
- For the purposes of this tutorial only, disable verify_cert.
- Restart the docker container.
- Connect to the honeypot and pull down a file via wget. The file should be pushed to a MISP event.

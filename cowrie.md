# 1 Cowrie Guide
This is a basic guide of how to install and run Cowrie.

## 1.1 Run Cowrie
You can run Cowrie by running the following.
```
docker run -p 22:2222 cowrie/cowrie:latest
```

If you want to stop the running container you will need to press `ctrl+c` to cancel.

## 1.2 Configuring Cowrie
## Default config
The default config can be viewed here: https://github.com/cowrie/cowrie/blob/master/etc/cowrie.cfg.dist 

## Custom config
- Cowrie docker will read in environment variables under the convention `COWRIE_<SECTION>_<VARIABLE>` eg. `COWRIE_HONEYPOT_HOSTNAME`.
- Add a custom hostname value as an environment variable in a new file called `env.txt`.
```
COWRIE_HONEYPOT_HOSTNAME=foobar
```

Run cowrie docker again using the new env file.
```
docker run -p 22:2222 --env-file=env.txt cowrie/cowrie:latest
```

# 2 Exercises
## 2.1 Fake an attack against the honeypot
- SSH to the server using credentials in the default userdb. Try pulling down a file from the internet using wget and exit the shell.
- The default userdb is here: https://github.com/cowrie/cowrie/blob/master/etc/userdb.example

## 2.2 View a downloaded file
- Run docker using a mount for the downloads dir: `-v cowrie:/cowrie/cowrie-git/var/lib/cowrie/downloads`
- Connect to the honeypot and download a file using wget. The log will output the filehash of the file.

```
sudo cat /var/lib/docker/volumes/cow/_data/<filehash>
```

## 2.3 Make your honeypot "sweeter"
- Try configuring a non-default hostname, kernel version, ssh version for the honeypot.

# 3 Enable telnet
Run cowrie with the extra port mapping and telnet option.
```
docker run -p 22:2222 -p 23:2223 -e COWRIE_TELNET_ENABLED=yes cowrie/cowrie:latest
```
Connect to your server using telnet on port 23.

# 4 Submittting malware samples to MISP
- Uncomment the output_misp module in `~/volumes/cowrie_cowrie-etc/_data/cowrie.cfg`
- Replace the base_url and api_key with the ones provided.
- For the purposes of this tutorial only, disable verify_cert.
- Restart the docker container.
- Connect to the honeypot and pull down a file via wget. The file should be pushed to a MISP event.

# Cowrie Guide
This is a basic guide of how to install and run Cowrie.

## Install
The docker-cowrie github repository is already cloned for us. We need to change Docker to listen on port 22 instead of 2222.
Change the docker-compose file `~/docker-cowrie/docker-compose.yml` using `vim` or `nano`. The port section should be as follows:
```
    ports:
      - "22:2222"
      - "23:2223"
```

Now you can run Cowrie by running the following.
```
cd ~/docker-cowrie
docker-compose up
```

If you want to stop the running container you will need to press `ctrl+c` to cancel.

## Configuring Cowrie
There are some default config files we can copy into our docker mount. Note we need sudo permissions to view this folder.

```
sudo cp /var/lib/docker/volumes/cowrie_cowrie-etc/_data/cowrie.cfg.dist /var/lib/docker/volumes/cowrie_cowrie-etc/_data/cowrie.cfg
sudo cp /var/lib/docker/volumes/cowrie_cowrie-etc/_data/userdb.example /var/lib/docker/volumes/cowrie_cowrie-etc/_data/userdb.txt
```

# Exercises
## Fake an attack against the honeypot
- SSH to the server using credentials in your userdb. Try pulling down a file from the internet using wget and exit the shell.

## View the honeypot output
- Review the honeypot report log and dumped files.

```
sudo tail /var/lib/docker/volumes/cowrie_cowrie-var/_data/log/cowrie/cowrie.json | jq
sudo ls -l /var/lib/docker/volumes/cowrie_cowrie-var/_data/lib/cowrie/downloads/
```

## Make your honeypot "sweeter"
- Try configuring a non-default hostname, kernel version, ssh version for the honeypot.
- Also change the usernames and passwords that the honeypot accepts in the `userdb.txt`.

# Elasticsearch and Kibana
Elasticsearch and Kibana have already been insalled using apt.

## Configure Kibana
We need to configure Kibana to listen on an IP that we can access. You should use the private IP address from your server hostname.
```
sudo vim /etc/kibana/kibana.yml
# > server.host: "<IP>" 
sudo systemctl start elasticsearch
sudo systemctl start kibana
```

Note: Kibana can take a minute to start up.
You should now be able to access kibana via `http://<Public_IP>:5601`.

## Configure Filebeat
We need to put config in filebeat so that it will watch for events in the Cowrie report log and send the json events to Elasticsearch.
`sudo vim /etc/filebeat/filebeat.yml`

Under the `filebeat.inputs` section add a new log option.
```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/lib/docker/volumes/cowrie_cowrie-var/_data/log/cowrie/cowrie.json
  json.keys_under_root: true
  processors:
    - decode_json_fields:
            fields: ["inner"]
    - rename:
        fields:
          - from: "url"
            to: "cowrie.url"
        ignore_missing: true
```

Finally start the Filebeat service.
`sudo systemctl restart filebeat`

## Set up the elasticsearch patterns
1. Go to Kibana in a web browser.
2. Select "Use my own data"
3. Go to Management (Cog wheel in left menu)
4. Go to Index Patterns
5. Select Create Index Pattern
6. Type in `filebeat-*` as your pattern
7. Select Next step
8. Choose `@timestamp` as your Time Filter field name
9. Select Create index pattern

## Playing with data

Now you can go to the Discover tab and review your data.

Try creating a data table or pie graph showing top attacker addresses, username, passwords and/or download filehashes.

If you get an attacker connect please be careful with dropped files. Look up their filehashes in VirusTotal.

# Enable telnet
In the `cowrie.cfg` look for the setting to enable telnet. Enable it and restart the docker container.

Connect to your server using telnet on port 23.

# Submittting malware samples to MISP
- Uncomment the output_misp module in `cowrie.cfg`.
- Replace the base_url and api_key with the ones provided.
- For the purposes of this tutorial only, disable verify_cert.
- Restart the docker container.
- Connect to the honeypot and pull down a file via wget. The file should be pushed to a MISP event.
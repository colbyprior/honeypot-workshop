# 1 Cowrie Guide
This is a basic guide of how to install and run Cowrie.

## 1.1 Install
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

## 1.2 Configuring Cowrie
There are some default config files we can copy into our docker mount. Note we may need sudo permissions to view this folder.

If you are having permissions problems then run `sudo chown -R ubuntu /var/lib/docker/volumes` This isn't good practice but it's just a workshop.

```
cp ~/volumes/cowrie_cowrie-etc/_data/cowrie.cfg.dist ~/volumes/cowrie_cowrie-etc/_data/cowrie.cfg
cp ~/volumes/cowrie_cowrie-etc/_data/userdb.example ~/volumes/cowrie_cowrie-etc/_data/userdb.txt
```

# 2 Exercises
## 2.1 Fake an attack against the honeypot
- SSH to the server using credentials in your userdb. Try pulling down a file from the internet using wget and exit the shell.

## 2.2 View the honeypot output
- Review the honeypot report log and dumped files.

```
sudo tail ~/volumes/cowrie_cowrie-var/_data/log/cowrie/cowrie.json | jq
sudo ls -l ~/volumes/cowrie_cowrie-var/_data/lib/cowrie/downloads/
```

## 2.3 Make your honeypot "sweeter"
- Try configuring a non-default hostname, kernel version, ssh version for the honeypot.
- Also change the usernames and passwords that the honeypot accepts in `~/volumes/cowrie_cowrie-etc/_data/userdb.txt` 

# 3 Elasticsearch and Kibana
Elasticsearch and Kibana have already been insalled using apt.

```
sudo systemctl start elasticsearch
sudo systemctl start kibana
```

Note: Kibana can take a minute to start up.
You should now be able to access kibana via `http://<Public_IP>:5601`.

To find the URL kibana should be availalbe on, run the following

```sh
echo http://$(curl -fsq http://169.254.169.254/latest/meta-data/public-ipv4/):5601/
```

## 3.1 Configure Filebeat
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

## 3.2 Set up the elasticsearch patterns
1. Go to Kibana in a web browser.
2. Select "Use my own data"
3. In the left menu go to Discover
4. Select Create Index Pattern
5. Type in `filebeat-*` as your pattern
6. Select Next step
7. Choose `@timestamp` as your Time Filter field name
8. Select Create index pattern

## 3.3 Playing with data

Now you can go to the Discover tab and review your data.

Try creating a data table or pie graph showing top attacker addresses, username, passwords and/or download filehashes.

If you get an attacker connect please be careful with dropped files. Look up their filehashes in VirusTotal.

# 4 Enable telnet
In the `~/volumes/cowrie_cowrie-etc/_data/cowrie.cfg` look for the setting to enable telnet. Enable it and restart the docker container.

Connect to your server using telnet on port 23.

# 5 Submittting malware samples to MISP
- Uncomment the output_misp module in `~/volumes/cowrie_cowrie-etc/_data/cowrie.cfg`
- Replace the base_url and api_key with the ones provided.
- For the purposes of this tutorial only, disable verify_cert.
- Restart the docker container.
- Connect to the honeypot and pull down a file via wget. The file should be pushed to a MISP event.

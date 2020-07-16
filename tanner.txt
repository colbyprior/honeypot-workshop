# Snare and Tanner Guide
This is a basic guide of how to run Snare and Tanner.

## Install
### Tanner
The Snare and Tanner repositories are already cloned into the home directory. First get Tanner running.
```
cd ~/tanner/docker/
docker-compose up
```

### Snare
In a new terminal ssh to your server again to run Snare. Update the Snare config in `~/snare/Dockerfile`. You need to put in a config variable for the page you are going to clone and the local IP of your server.
- The domain will be `demo.dontthinkjustroll.com` for this example.
- The IP will be the private IP presented in the hostname prompt.
```
ARG PAGE_URL=demo.dontthinkjustroll.com
ENV TANNER <your_IP>
```

Now we can simply run the Docker container which will clone the website then serve a copy on port 80.
```
cd ~/snare
docker-compose up
```

## Exercises
### Trigger SQL Injection
- Visit your server in a web browser and try to add a GET parameter that would trigger the SQL injection emulator.
- The page should show a SQL Error message when you succresfully trigger the emulator.
- If you need a hint you can look at https://github.com/client9/libinjection for some hints.

### Viewing data
- Follow the Elasticsearch and Kibana setup as below first to make observing the logs easier for this.
- Look inside of the Tanner config file `~/tanner/docker/tanner/dist/config.yaml` to see what emulators we have enabled by default.

### Trigger RFI attack
Check the file pulled down by tanner after the RFI attack.

### Trigger a XSS attack
Try injecting a javascript alert.

## Elasticsearch and Kibana setup
Add the following log config to the `filebeat.inputs:` section in `/etc/filebeat/filebeat.yml`.
```
- type: log
  enabled: true
  paths:
    - /home/ubuntu/tanner/docker/log/tanner_report.json
  json.keys_under_root: true
```

### Refresh the index
Now we need to make sure the index is refreshed so we can properly search over our new data types.
1. Restart filebeat `systemctl restart filebeat`
2. Visit Kibana and go in to Management
3. Select index management
4. Select your filebeat index
5. Click the refresh icon to refresh the index.

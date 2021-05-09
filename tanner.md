# 1 Snare and Tanner Guide
This is a basic guide of how to run Snare and Tanner.

## 1.1 Tanner Install
The Snare and Tanner repositories are already cloned into the home directory. First get Tanner running.
```
cd ~/tanner/docker/
docker-compose up
```

## 1.2 Snare Install
In a new terminal ssh to your server again to run Snare. Update the Snare config in `~/snare/Dockerfile`. You need to put in a config variable for the page you are going to clone.
- The domain will be `demo.dontthinkjustroll.com` for this example.
```
ARG PAGE_URL=demo.dontthinkjustroll.com
```

Now we can simply run the Docker container which will clone the website then serve a copy on port 80.
```
cd ~/snare
docker-compose up
```

Try and load your web honeypot.

# 2 Elasticsearch and Kibana setup
Add the following log config to the `filebeat.inputs:` section in `/etc/filebeat/filebeat.yml`.
```
- type: log
  enabled: true
  paths:
    - /home/ubuntu/tanner/docker/log/tanner_report.json
  json.keys_under_root: true
```

## 2.1 Refresh the index
Now we need to make sure the index is refreshed so we can properly search over our new data types.
1. Restart filebeat `sudo systemctl restart filebeat`
2. Visit Kibana and go in to Management
3. Select index management
4. Select your filebeat index
5. Click the refresh icon to refresh the index.

# 3 Exercises
Look inside of the Tanner config file `~/tanner/docker/tanner/dist/config.yaml` to see what emulators we have enabled by default.

## 3.1 Trigger a XSS attack
Try injecting a javascript alert.

## 3.2 Trigger SQL Injection
- Visit your server in a web browser and try to add a GET parameter that would trigger the SQL injection emulator.
- The page should show a SQL Error message when you succresfully trigger the emulator.
- If you need a hint you can look at https://github.com/client9/libinjection for some hints.
- See if you are able to get a full sql database dump.
- After you have triggered a sqli attack there will be a db emulator directory in the docker volume. This contains the emulated database for the attack, you can view the contents manually.

```
sqlite3 ~/tanner/docker/log/emulators/db/tanner_db
sqlite> .tables
sqlite> .schema users
sqlite> select * from users limit 1;
```

## 3.3 Trigger RFI attack
- Check the file pulled down by tanner after the RFI attack.
- You will need the filename of your uploaded file to reference an external entitiy.
- Once you have triggered a RFI attack there will be a "files" directory with the files pulled down via RFI emulation.

```
ls ~/tanner/docker/log/emulators/files/
```


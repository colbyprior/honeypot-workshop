# 1.0 Opencanary Guide

## 1.1 Initial setup


First you should enter the Python virtual environment for OpenCanary:

```
source ~/env/bin/activate
cd ~/opencanary
```

Before the first run, generate a default opencanary config
```
opencanaryd --copyconfig
```

This will create a folder and config file in `/etc/opencanaryd/opencanary.conf`


# 2.0 Exercises

## 2.1 Configure opencanary

You must now edit the config file to determine which services and logging options you would like to enable.

`sudo vim /etc/opencanaryd/opencanary.conf`

Play around and try enable the following services:
- SMB
- MSSQL
- MYSQL
- VNC


## 2.2 Run open canary
This will run opencanary in dev mode which will allow you to see the live output from opencanary
```
opencanaryd --start
```


## 2.3 Fake an attack
```sh
ftp SERVER_IP
Connected to SERVER_IP.
220 FTP server ready

Name (SERVER_IP:ubuntu): honeypot

331 Password required for honeypot.
Password: FAKE_PASSWORD
530 Sorry, Authentication failed.
Login failed.

ftp> exit
221 Goodbye.

```

## 2.4 Check your logs

Check that opencanary is picking up your failed ftp authentication logs
`less /var/tmp/opencanary.log`


## 2.5 Elasticsearch and Kibana setup
Add the following log config to the `filebeat.inputs:` section in `/etc/filebeat/filebeat.yml`.
```
- type: log
  enabled: true
  paths:
    - /var/tmp/opencanary.log
  json.keys_under_root: true
  processors:
    - decode_json_fields:
        fields: ["inner"]
    - rename:
        fields:
        - from: "src_host"
          to: "src_ip"
        - from: "logdata.PASSWORD"
          to: "password"
        - from: "logdata.USERNAME"
          to: "username"
        ignore_missing: true
        fail_on_error: false
```


## 2.6 Refresh the index
Now we need to make sure the index is refreshed so we can properly search over our new data types.
1. Restart filebeat `systemctl restart filebeat`
2. Visit Kibana and go in to Management
3. Select index management
4. Select your filebeat index
5. Click the refresh icon to refresh the index.



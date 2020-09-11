# Help I am stuck
## How do I stop a docker container
Press `Ctrl+c` to cancel a running application in linux.

## How do I view the log files and run the docker container at the same time?
You should create a second terminal window and ssh to the server on both.

## I broke filebeat
This command will pull down the fully configured filebeat config.
`sudo wget -q - https://raw.githubusercontent.com/colbyprior/honeypot-workshop/master/filebeat.yml -O /etc/filebeat/filebeat.yml`

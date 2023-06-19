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
docker-compose up --build
```

Try and load your web honeypot.

# 2 Exercises
- Look inside of the Tanner config file `~/tanner/docker/tanner/dist/config.yaml` to see what emulators we have enabled by default.
- Emulator doco is here https://tanner.readthedocs.io/en/latest/emulators.html

## 2.1 Trigger a XSS attack
Try injecting a javascript alert.

## 2.2 Trigger SQL Injection
- Visit your server in a web browser and try to add a GET parameter that would trigger the SQL injection emulator.
- The page should show a SQL Error message when you succresfully trigger the emulator.
- If you need a hint you can look at https://github.com/client9/libinjection for some hints.
- See if you are able to get a full sql database dump.
- After you have triggered a sqli attack there will be a db emulator directory in the docker volume. This contains the emulated database for the attack, you can view the contents manually.

```
sqlite3 ~/tanner/docker/tmp/emulators/db/tanner_db
sqlite> .tables
sqlite> .schema users
sqlite> select * from users limit 1;
```

## 2.3 Trigger RFI attack
- Check the file pulled down by tanner after the RFI attack.
- You will need the filename of your uploaded file to reference an external entitiy.
- Once you have triggered a RFI attack there will be a "files" directory with the files pulled down via RFI emulation.

```
ls ~/tanner/docker/tmp/emulators/files/
```


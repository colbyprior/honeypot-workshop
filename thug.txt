# Thug Guide
This is a basic guide of how to run Thug.

## Install
Run the docker container with an interactive shell.
```
cd thug
docker run --rm -it -v ~/thug:/thug remnux/thug bash
ls -l /thug/samples/
cat /thug/samples/exploits/4594.html
thug -ZF -l /thug/samples/exploits/4594.html
```

## Exercises
Look through some of the thug samples:
```
/thug/samples/exploits/
```

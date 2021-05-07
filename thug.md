# 1 Thug Guide
This is a basic guide of how to run Thug.

## 1.1 Install
Run the docker container with an interactive shell.

```
cd thug
docker run -it -v ~/thug/tests/samples:/samples thug:demo /bin/bash
```

# 2 Running Thug
While in this container you can run thug to find out its command arguments.

```
thug
```

## 2.1 File output
Thug can export extra information to a output.
- The arguments `-ZF` lets thug know to export the results to a json file.
- The argument `-l <file name>` tells thug to run the analysis on a local file.

```
cd /samples/exploits
cat 4594.html
thug -ZF -l 4594.html
```

After running the analysis there will be a output letting you know where the output file is:

```
# Thug analysis logs saved at /tmp/thug/logs/01a14e6f7f3630a8378b3c24698b32ed/20200727044545
less /tmp/thug/logs/aa785aa5193ee38511e4a485c0a7bd0d/20200727044545/analysis/json/analysis.json
cat /tmp/thug/logs/aa785aa5193ee38511e4a485c0a7bd0d/20200727044545/analysis/json/analysis.json | jq ."exploits"
```

# 3 Exercises
For each of the follwing samples:
1. `domino.html`
2. `ssreader_0day.html`
3. `blackhole.html`
The samples are also available for reading via github: https://github.com/buffer/thug/tree/master/tests/samples/exploits

For each sample try to find out the following:
- Look at the raw sample. Can you tell what its trying to do?
- Run thug over the sample with a json file export.
- What CVE's are associated with the code.
- Is the code trying to pull down any malicious payload?
- Is the code trying to run any local commands or code?

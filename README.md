# 📦 DataStax Collector LAB

This repository sets up a local Apache Cassandra 4.1.1 Docker container that supports the [DataStax Diagnostic Collector](https://github.com/datastax/diagnostic-collector). It includes everything needed to gather detailed system, configuration, and JMX metrics for diagnostics.

---

## 🔧 Features

- Pre-installed tools required by the collector (`ethtool`, `lsof`, `iostat`, `jcmd`, etc.)
- SSH server for optional remote collection (user: `root`, password: `root`)
- Dynamic IP configuration for Cassandra
- Validated support for JMX-based metrics export
- Easily deployable via Docker Hub

---

## 📁 Project Structure

```text
.
├── Dockerfile                   # Builds Cassandra container with extra tools
├── start-cassandra.sh          # Starts Cassandra with dynamic IP config
├── start-cassandra-container.sh# Builds and runs the container
├── collector/                  # Extracted diagnostic collector bundle
│   ├── ds-collector            # Main collector script
│   ├── collector.conf          # Configuration file (example provided)
│   └── *_secret.key            # Optional encryption key (if provided)
````

---

## 🚀 Quick Start

### Option A: Use Pre-Built Image from Docker Hub (Recommended)

```bash
docker run -d \
  --name cassandra-collector \
  -p 9042:9042 \
  -p 7199:7199 \
  -p 22:22 \
  dieterfl/cassandra-collector
```

> Replace `<your-dockerhub-username>` with your Docker Hub name.

---

### Option B: Build Locally

```bash
./start-cassandra-container.sh
```

---

## 🐳 Docker Hub: How to Publish

### 1. Log in to Docker Hub

```bash
docker login
```

### 2. Tag your image

```bash
docker tag cassandra-collector <your-dockerhub-username>/cassandra-collector:latest
```

### 3. Push to Docker Hub

```bash
docker push <your-dockerhub-username>/cassandra-collector:latest
```

---

## 📦 Prepare the Diagnostic Collector

If you haven’t already:

```bash
tar -xvf ds-collector.*.tar.gz
cd collector
```

Then:

* Copy the secret key (if applicable):

```bash
cp /path/to/*_secret.key .
```

* Make the collector executable:

```bash
chmod +x ds-collector
```

* Edit the configuration file:

```bash
nano collector.conf
```

---

## 📝 Example `collector.conf`

```bash
use_docker="true"
hostName="cassandra-collector"
skipSudo="true"
jmxHost="127.0.0.1"
jmxPort="7199"
jmxSSL="false"
nodetoolCmd="/opt/cassandra/bin/nodetool"
cqlsh_port=9042
issueId="difli-01"
keyMD5sum="1687214ca092e751c671cda6fbd78669  difli-01_secret.key"
encrypt_uploads="true"
skipS3="false"
keyId="AKI..."
keySecret="NUp..."
git_branch="master"
git_sha="f7505e34640e400076ded906d7e9f212de6cd47f"
```

---

## 🧪 Run Diagnostics

### ✅ Test Connectivity

```bash
./ds-collector -T -f collector.conf -n cassandra-collector
```

### 📥 Collect Diagnostic Snapshot

```bash
./ds-collector -X -d -f collector.conf -n cassandra-collector
```

---

## 🔍 Useful Docker Commands

```bash
docker exec -it cassandra-collector bash          # Shell access
docker exec cassandra-collector nodetool status   # Check Cassandra health
```

---

## 📬 Troubleshooting

Enable verbose mode:

```bash
./ds-collector -X -v -f collector.conf -n cassandra-collector
```

If JMX or connection issues persist, ensure:

* Ports `7199` and `9042` are open
* IP and hostname settings are correctly injected into `cassandra.yaml`
* `start-cassandra.sh` was executed and logs don’t show startup errors

---

## 🏁 Notes

* You can reuse this setup for local debugging and cluster simulations

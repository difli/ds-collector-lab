FROM cassandra:4.1.1

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server \
    iputils-ping \
    net-tools \
    ethtool \
    ifupdown \
    lsof \
    sysstat \
    pciutils \
    dnsutils \
    curl \
    sudo \
    xxd \
    procps \
    iproute2 \
    nano \
    openjdk-17-jdk \
    python2 \
    netcat \
    ntp \
    cron && \
    apt-get clean

# Enable sysstat (SAR data collection)
RUN sed -i 's/^ENABLED="false"/ENABLED="true"/' /etc/default/sysstat && \
    mkdir -p /var/log/sysstat && \
    touch /var/log/sysstat/sa$(date +%d)

# Prepare SSH for debug access
RUN mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create a non-root user (optional)
RUN useradd -ms /bin/bash cassandrauser

# Fix ownership of Cassandra directories
RUN chown -R cassandrauser /var/lib/cassandra /var/log/cassandra /etc/cassandra

# Copy startup scripts
COPY start-cassandra.sh /start-cassandra.sh
COPY docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh
RUN chmod +x /start-cassandra.sh /docker-entrypoint-wrapper.sh

# Expose ports
EXPOSE 9042 7199 7000 22

# Set final entrypoint wrapper
ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]

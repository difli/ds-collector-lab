FROM cassandra:4.1.1

# Install utilities needed by ds-collector
RUN apt-get update && \
    apt-get install -y \
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
    && apt-get clean

# Set up SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy start script
COPY start-cassandra.sh /start-cassandra.sh
RUN chmod +x /start-cassandra.sh

EXPOSE 9042 7199 7000 22

# Create a new user
RUN useradd -ms /bin/bash cassandrauser

# Change ownership of cassandra directories
RUN chown -R cassandrauser /var/lib/cassandra /var/log/cassandra /etc/cassandra

# Switch to that user
USER cassandrauser

CMD ["/start-cassandra.sh"]

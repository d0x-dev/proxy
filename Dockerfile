FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl unzip tini tinyproxy \
    && rm -rf /var/lib/apt/lists/*

# Install ngrok
RUN curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar zx -C /usr/local/bin

# Configure tinyproxy with hardcoded credentials
RUN cat > /etc/tinyproxy.conf <<EOF
User nobody
Group nogroup
Port 8080
Timeout 600
DefaultErrorFile "/usr/share/tinyproxy/default.html"
Logfile "/dev/stdout"
MaxClients 100
Allow 0.0.0.0/0
BasicAuth myuser mypass
EOF

# Expose proxy port (internal only, ngrok tunnels it)
EXPOSE 8080

# Start tinyproxy and ngrok (replace with your real ngrok token)
CMD tinyproxy -d && \
    ngrok config add-authtoken 30Xt1F8pXJpc2no2LdQF4xqrmjT_7rUnMXDivp3iiAKpV1fAc && \
    ngrok http 8080

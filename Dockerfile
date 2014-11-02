FROM ubuntu:latest
MAINTAINER Joshua Lund

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Make sure the repository information is up to date
RUN apt-get update

# Install Steam
RUN apt-get install -y ca-certificates wget
RUN wget http://media.steampowered.com/client/installer/steam.deb -P /tmp/
RUN dpkg -i /tmp/steam.deb || true
RUN apt-get install -fy

# Install OpenSSH
RUN apt-get install -y openssh-server

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd

# Install Pulseaudio
RUN apt-get install -y pulseaudio

# Add the Steam user that will run the browser
RUN adduser --disabled-password --gecos "Steam User" --uid 5001 steam

# Add SSH public key for the steam user
RUN mkdir /home/steam/.ssh
ADD id_rsa.pub /home/steam/.ssh/authorized_keys
RUN chown -R steam:steam /home/steam/.ssh

# Set up the launch wrapper
RUN echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/steam-pulseaudio-forward
RUN echo 'steam' >> /usr/local/bin/steam-pulseaudio-forward
RUN chmod 755 /usr/local/bin/steam-pulseaudio-forward

# Start SSH so we are ready to make a tunnel
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]

# Expose the SSH port
EXPOSE 22

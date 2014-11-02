FROM ubuntu:12.04
MAINTAINER George Schneeloch

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Make sure the repository information is up to date
RUN apt-get update

# Install Steam
RUN apt-get install -y ca-certificates wget
RUN wget http://media.steampowered.com/client/installer/steam.deb -P /tmp/
RUN dpkg -i /tmp/steam.deb || true
RUN apt-get install -fy

# Other Steam dependencies
RUN apt-get install -y ia32-libs
RUN apt-get install -y libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386

# Testing 3D
RUN apt-get install -y mesa-utils

# Install OpenSSH
RUN apt-get install -y openssh-server

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd

# Overwrite sshd_config with our own file
ADD sshd_config /etc/ssh/

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

ENV DISPLAY unix:0.0


# Start SSH so we are ready to make a tunnel
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
VOLUME ["/tmp/.X11-unix", "/tmp/.X11-unix"]

# Expose the SSH port
EXPOSE 22

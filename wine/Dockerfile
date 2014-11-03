FROM ubuntu:12.04
MAINTAINER George Schneeloch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y wine

RUN apt-get install -y mesa-utils

# Install OpenSSH
RUN apt-get install -y openssh-server

# Create OpenSSH privilege separation directory
RUN mkdir /var/run/sshd

# Overwrite sshd_config with our own file
ADD sshd_config /etc/ssh/

# Add the wine user that will run the browser
RUN adduser --disabled-password --gecos "Wine User" --uid 5001 wine

# Add SSH public key for the wine user
RUN mkdir /home/wine/.ssh
ADD id_rsa.pub /home/wine/.ssh/authorized_keys
RUN chown -R wine:wine /home/wine/.ssh

# Start SSH so we are ready to make a tunnel
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
VOLUME ["/tmp/.X11-unix", "/tmp/.X11-unix"]

# Expose the SSH port
EXPOSE 22

Docker! Steam! PulseAudio!
===========================

Run Steam inside an isolated [Docker](http://www.docker.io) container on your Linux desktop! See its sights via X11 forwarding! Hear its sounds through the magic of PulseAudio and SSH tunnels!


Instructions
============

1. Install [PulseAudio Preferences](http://freedesktop.org/software/pulseaudio/paprefs/). Debian/Ubuntu users can do this:

        sudo apt-get install paprefs

1. Launch PulseAudio Preferences, go to the "Network Server" tab, and check the "Enable network access to local sound devices" checkbox

1. Restart PulseAudio

        sudo service pulseaudio restart

   On some distributions, it may be necessary to completely restart your computer. You can confirm that the settings have successfully been applied using the `pax11publish` command. You should see something like this (the important part is in bold):

   > Server: {ShortAlphanumericString}unix:/run/user/1000/pulse/native **tcp:YourHostname:4713 tcp6:YourHostname:4713**

   > Cookie: ReallyLongAlphanumericString

1. [Install Docker](http://docs.docker.io/en/latest/installation/) if you haven't already

1. Clone this repository and get right in there

        git clone https://github.com/jlund/docker-steam-pulseaudio.git && cd docker-steam-pulseaudio

1. Generate an SSH public key, if you don't already have one

        ssh-keygen

1. Copy your SSH public key into place

        cp ~/.ssh/id_rsa.pub .

1. Build the container

        docker build -t steam .

1. Create an entry in your .ssh/config file for easy access. It should look like this:
        
        Host docker-steam
          User      steam
          Port      2222
          HostName  127.0.0.1
          RemoteForward 64713 localhost:4713
          ForwardX11 yes

1. Run the container and forward the appropriate ports

        docker run -d -p 127.0.0.1:2222:22 steam

1. Connect via SSH and launch Steam using the provided PulseAudio wrapper script

        ssh docker-steam steam-pulseaudio-forward


Author Information
==================

Since I upgraded Ubuntu I've been having problems getting Steam to work properly. I forked Joshua Lund's docker-chrome-pulseaudio repo: https://github.com/jlund/docker-chrome-pulseaudio
And adapted it to work with Steam.
FROM registry.fedoraproject.org/fedora:34

# Local directory where all files will be stored
WORKDIR /weechat/

# rpms to install
#     - weechat
#     - python3-websocket-client
#     - google-noto-emoji-color-fonts # for emoji support
#     - tmux (for wrapping weechat)
RUN dnf install -y                    \
        weechat                       \
        python3-websocket-client      \
        google-noto-emoji-color-fonts \
        systemd                       \
        tmux

ADD start-script.txt /weechat/start-script.txt
RUN cat start-script.txt | \
    grep -v '^#'         | \
    tr '\n' ';'          | \
    > start-script

# From https://wiki.archlinux.org/index.php/WeeChat#Tmux_Method
ADD weechat.service  /etc/systemd/system/weechat.service
RUN systemctl enable weechat.service

# A place for our logs, we'll bind mount in a directory here.
VOLUME /weechat/logs/

# Set the timezone for the container
RUN ln -sf ../usr/share/zoneinfo/America/New_York /etc/localtime

# Systemd!!!
CMD [ "/sbin/init" ]

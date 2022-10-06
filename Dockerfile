FROM fedora:latest

RUN dnf install 'dnf-command(copr)' -y
RUN sudo dnf copr enable varlad/helix -y
RUN dnf update -y
RUN dnf install helix -y

COPY ./config/helix ~/.config/
COPY ./bin /usr/local/bin

RUN mkdir /var/src
WORKDIR var/src
CMD ["/bin/bash"]

FROM fedora

RUN dnf install 'dnf-command(copr)' -y
RUN sudo dnf copr enable varlad/helix -y
RUN dnf update -y
RUN dnf install helix -y

WORKDIR usr/baci
COPY ./code ./
COPY ./bin /usr/local/bin
CMD ["/bin/bash"]

FROM fedora

RUN dnf -y update && dnf install -y skopeo

WORKDIR /

COPY check.sh .

CMD ["/bin/bash", "-c", "/check.sh"]
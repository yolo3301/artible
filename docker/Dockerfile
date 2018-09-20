FROM fedora

RUN dnf -y update && dnf install -y skopeo jq curl

WORKDIR /

COPY . .

CMD ["/bin/bash", "-c", "/check.sh"]

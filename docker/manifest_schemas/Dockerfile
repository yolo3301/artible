FROM fedora

RUN dnf -y update && dnf install -y skopeo

WORKDIR /

COPY alpine_v2s1 alpine_v2s1
COPY alpine_v2s2 alpine_v2s2
COPY alpine_oci alpine_oci
COPY check.sh .

CMD ["/bin/bash", "-c", "/check.sh"]

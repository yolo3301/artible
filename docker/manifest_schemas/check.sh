#!/bin/bash

skopeo --insecure-policy copy --format=v2s1 docker://$SRC_REPO/${IMG_NAME} dir:${IMG_NAME}_v2s1
skopeo --insecure-policy copy --format=v2s2 docker://$SRC_REPO/${IMG_NAME} dir:${IMG_NAME}_v2s2
skopeo --insecure-policy copy --format=oci docker://$SRC_REPO/${IMG_NAME} dir:${IMG_NAME}_oci

skopeo --insecure-policy copy --dest-creds=$DST_USER:$DST_PWD dir:${IMG_NAME}_v2s1 docker://$DST_REPO/${IMG_NAME}:v2s1
skopeo --insecure-policy copy --dest-creds=$DST_USER:$DST_PWD dir:${IMG_NAME}_v2s2 docker://$DST_REPO/${IMG_NAME}:v2s2
skopeo --insecure-policy copy --dest-creds=$DST_USER:$DST_PWD dir:${IMG_NAME}_oci docker://$DST_REPO/${IMG_NAME}:oci
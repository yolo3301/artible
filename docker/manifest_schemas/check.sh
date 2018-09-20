#!/bin/bash

RET=0

echo Pushing v2s1 image ${DST_REPO}/alpine:v2s1
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:${DST_PWD} dir:alpine_v2s1 docker://${DST_REPO}/alpine:v2s1
if test $? -eq 0
then
  echo Pushed v2s1 image ${DST_REPO}/alpine:v2s1
else
  echo Failed to push v2s1 image ${DST_REPO}/alpine:v2s1
  RET=1
fi

echo Pushing v2s2 image ${DST_REPO}/alpine:v2s2
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:${DST_PWD} dir:alpine_v2s2 docker://${DST_REPO}/alpine:v2s2
if test $? -eq 0
then
  echo Pushed v2s2 image ${DST_REPO}/alpine:v2s2
else
  echo Failed to push v2s2 image ${DST_REPO}/alpine:v2s2
  RET=1
fi

echo Pushing oci image ${DST_REPO}/alpine:oci
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:${DST_PWD} dir:alpine_oci docker://${DST_REPO}/alpine:oci
if test $? -eq 0
then
  echo Pushed oci image ${DST_REPO}/alpine:oci
else
  echo Failed to push oci image ${DST_REPO}/alpine:oci
  RET=1
fi

exit $RET

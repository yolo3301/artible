#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

RET=0
DST_PREFIX=${DST_HOST}/${DST_REPO}
HTTP_HOST=${HTTP_SCHEMA}${DST_HOST}

echo ============== Start schema checks ===================

echo Pushing v2s1 image ${DST_PREFIX}/alpine:v2s1
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_v2s1 docker://${DST_PREFIX}/alpine:v2s1
if test $? -eq 0
then
  echo -e "${GREEN}Pushed v2s1 image ${DST_PREFIX}/alpine:v2s1${NC}"
else
  echo -e "${RED}[ERROR]: Failed to push v2s1 image ${DST_PREFIX}/alpine:v2s1${NC}"
  RET=1
fi

echo Verifying v2s1 manifest
v2s1_got_schema=$(skopeo --insecure-policy inspect --tls-verify=false --raw --creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:v2s1 | jq .schemaVersion)
if [[ $v2s1_got_schema == 1 ]]
then
  echo -e "${GREEN}Verified the manifest schema version is 1${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest schema version $v2s1_got_schema${NC}"
  RET=1
fi

echo Pulling v2s1 image ${DST_PREFIX}/alpine:v2s1
skopeo --insecure-policy copy --src-tls-verify=false --src-creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:v2s1 dir:alpine_download_v2s1
if test $? -eq 0
then
  echo -e "${GREEN}Downloaded v2s1 image ${DST_PREFIX}/alpine:v2s1${NC}"
else
  echo -e "${RED}[ERROR]: Failed to pull v2s1 image ${DST_PREFIX}/alpine:v2s1${NC}"
  RET=1
fi

echo Pushing v2s2 image ${DST_PREFIX}/alpine:v2s2
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_v2s2 docker://${DST_PREFIX}/alpine:v2s2
if test $? -eq 0
then
  echo -e "${GREEN}Pushed v2s2 image ${DST_PREFIX}/alpine:v2s2${NC}"
else
  echo -e "${RED}[ERROR]: Failed to push v2s2 image ${DST_PREFIX}/alpine:v2s2${NC}"
  RET=1
fi

echo Verifying v2s2 manifest
v2s2_got_schema=$(skopeo --insecure-policy inspect --tls-verify=false --raw --creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:v2s2 | jq .schemaVersion)
if [[ $v2s2_got_schema == 2 ]]
then
  echo -e "${GREEN}Verified the manifest schema version is 2${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest schema version $v2s2_got_schema${NC}"
  RET=1
fi
v2s2_got_type=$(skopeo --insecure-policy inspect --tls-verify=false --raw --creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:v2s2 | jq -r .mediaType)
if [[ "$v2s2_got_type" == "application/vnd.docker.distribution.manifest.v2+json" ]]
then
  echo -e "${GREEN}Verified the manifest mediaType is application/vnd.docker.distribution.manifest.v2+json${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest mediaType $v2s2_got_type${NC}"
  RET=1
fi

echo Pulling v2s2 image ${DST_PREFIX}/alpine:v2s2
skopeo --insecure-policy copy --src-tls-verify=false --src-creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:v2s2 dir:alpine_download_v2s2
if test $? -eq 0
then
  echo -e "${GREEN}Downloaded v2s2 image ${DST_PREFIX}/alpine:v2s2${NC}"
else
  echo -e "${RED}[ERROR]: Failed to pull v2s2 image ${DST_PREFIX}/alpine:v2s2${NC}"
  RET=1
fi

echo Pushing oci image ${DST_PREFIX}/alpine:oci
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_oci docker://${DST_PREFIX}/alpine:oci
if test $? -eq 0
then
  echo -e "${GREEN}Pushed oci image ${DST_PREFIX}/alpine:oci${NC}"
else
  echo -e "${RED}[ERROR]: Failed to push oci image ${DST_PREFIX}/alpine:oci${NC}"
  RET=1
fi

echo Verifying oci manifest
oci_got_schema=$(skopeo --insecure-policy inspect --tls-verify=false --raw --creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:oci | jq .schemaVersion)
if [[ $oci_got_schema == 2 ]]
then
  echo -e "${GREEN}Verified the manifest schema version is 2${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest schema version $oci_got_schema${NC}"
  RET=1
fi
oci_got_type=$(skopeo --insecure-policy inspect --tls-verify=false --raw --creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:oci | jq -r .config.mediaType)
if [[ "$oci_got_type" == "application/vnd.oci.image.config.v1+json" ]]
then
  echo -e "${GREEN}Verified the manifest mediaType is application/vnd.oci.image.config.v1+json${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest mediaType $oci_got_type${NC}"
  RET=1
fi

echo Pulling oci image ${DST_PREFIX}/alpine:oci
skopeo --insecure-policy copy --src-tls-verify=false --src-creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine:oci dir:alpine_download_oci
if test $? -eq 0
then
  echo -e "${GREEN}Downloaded oci image ${DST_PREFIX}/alpine:oci${NC}"
else
  echo -e "${RED}[ERROR]: Failed to pull oci image ${DST_PREFIX}/alpine:oci${NC}"
  RET=1
fi

echo ============== Finished schema checks ==================

echo ============== Start manifest list checks ==================

echo Peparing images...
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine docker://${DST_PREFIX}/alpine_ml:default
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_s390x docker://${DST_PREFIX}/alpine_ml:s390x
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_ppc64le docker://${DST_PREFIX}/alpine_ml:ppc64le
skopeo --insecure-policy copy --dest-tls-verify=false --dest-creds=${DST_USER}:"${DST_PWD}" dir:alpine_aarch64 docker://${DST_PREFIX}/alpine_ml:aarch64
echo Finished preparing images

echo Exchanging docker token...
token=$(curl -s -k -u ${DST_USER}:"${DST_PWD}" "${HTTP_HOST}/v2/token?account=${DST_USER}&scope=repository:${DST_REPO}/alpine_ml:pull,push" | jq -r .token)

echo Putting manifest list...
ml_json=$(cat manifest_list.json)
code=$(curl -s -w %{http_code} -o /dev/null -H "Authorization: Bearer ${token}" -H "Content-Type: application/vnd.docker.distribution.manifest.list.v2+json" -X PUT -d "${ml_json}" ${HTTP_HOST}/v2/${DST_REPO}/alpine_ml/manifests/latest)
if test $code -eq 201 || test $code -eq 200
then
  echo -e "${GREEN}Manifest list created${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected http code when creating manifest list $code${NC}"
  RET=1
fi

echo Verifying manifest list
got_ml_type=$(curl -s -H "Authorization: Bearer ${token}" -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" ${HTTP_HOST}/v2/${DST_REPO}/alpine_ml/manifests/latest | jq -r .mediaType)
if [[ "$got_ml_type" == "application/vnd.docker.distribution.manifest.list.v2+json" ]]
then
  echo -e "${GREEN}Verified the manifest list mediaType is application/vnd.docker.distribution.manifest.list.v2+json${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest list mediaType $got_ml_type${NC}"
  RET=1
fi

echo Pulling image ${DST_PREFIX}/alpine_ml:latest
skopeo --insecure-policy copy --src-tls-verify=false --src-creds=${DST_USER}:"${DST_PWD}" docker://${DST_PREFIX}/alpine_ml:latest dir:alpine_download_ml
if test $? -eq 0
then
  echo -e "${GREEN}Downloaded image ${DST_PREFIX}/alpine_ml:latest${NC}"
else
  echo -e "${RED}[ERROR]: Failed to pull image ${DST_PREFIX}/alpine_ml:latest${NC}"
  RET=1
fi

echo ============== Finished manifest list checks ==================

echo ============== Start schema conversion checks ==================

echo Getting manifest list but accept schema 2

got_ml_s2_type=$(curl -s -H "Authorization: Bearer ${token}" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" ${HTTP_HOST}/v2/${DST_REPO}/alpine_ml/manifests/latest | jq -r .mediaType)
if [[ "$got_ml_s2_type" == "application/vnd.docker.distribution.manifest.v2+json" ]]
then
  echo -e "${GREEN}Verified the manifest mediaType is application/vnd.docker.distribution.manifest.v2+json${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest mediaType $got_ml_s2_type${NC}"
  RET=1
fi

echo Getting manifest list but accept schema 1

got_ml_s1_schema=$(curl -s -H "Authorization: Bearer ${token}" -H "Accept: application/vnd.docker.distribution.manifest.v1+prettyjws" ${HTTP_HOST}/v2/${DST_REPO}/alpine_ml/manifests/latest | jq .schemaVersion)
if test $got_ml_s1_schema -eq 1
then
  echo -e "${GREEN}Verified the manifest schema is 1${NC}"
else
  echo -e "${RED}[ERROR]: Unexpected manifest scehma $got_ml_s1_schema${NC}"
  RET=1
fi

echo ============== Finished schema conversion checks ==================

exit $RET

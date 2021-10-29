#!/bin/bash
# SPDX-FileCopyrightText: 2021-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

# script to create Keycloak configuration
# Usage:
# keycloak-configure.sh URL realm username password file
set -e
#set -x
set -o pipefail
set -u

if [ "$#" -lt 5 ]; then
  echo "At least 5 args are needed. Got $#"
  exit 1
fi
KEYCLOAK_URL=$1
KEYCLOAK_REALM=$2
KEYCLOAK_CLIENT_ID=$3
export KEYCLOAK_CLIENT_SECRET=$4
KEYCLOAK_PATH=$5

export LDAP_ADDR=ldap://fedora389ds:389
export LDAP_ORG="dc=opennetworking,dc=org"

echo "Args:" $KEYCLOAK_URL $KEYCLOAK_REALM $KEYCLOAK_CLIENT_ID $KEYCLOAK_CLIENT_SECRET $KEYCLOAK_PATH

TKN=$(curl -X POST "${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -d "username=${KEYCLOAK_CLIENT_ID}" \
 -d "password=${KEYCLOAK_CLIENT_SECRET}" \
 -d 'grant_type=password' \
 -d 'client_id=admin-cli' | jq -r '.access_token')

echo "$? Got Token $TKN"

curl -i -X PUT "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-binary "@${KEYCLOAK_PATH}/keycloak-realm-config.json"

curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/client-scopes" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-binary "@${KEYCLOAK_PATH}/keycloak-client-scopes-groups.json"

COMPONENT_ID=$(curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/components" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-raw "$(cat ${KEYCLOAK_PATH}/keycloak-ldap-config.json | envsubst)" | grep Location  | cut -d ' ' -f2 | xargs basename)

export COMPONENT_ID=${COMPONENT_ID//[$'\t\r\n']}

echo "Got Component ID $COMPONENT_ID"

curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/testLDAPConnection" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-raw "$(cat ${KEYCLOAK_PATH}/verify-ldap.json | envsubst)"

curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/components" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-raw "$(cat ${KEYCLOAK_PATH}/keycloak-group-mapper.json | envsubst)"

curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/user-storage/${COMPONENT_ID}/sync?action=triggerFullSync" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN"

curl -i -X POST "${KEYCLOAK_URL}/admin/realms/${KEYCLOAK_REALM}/clients" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $TKN" \
--data-binary "@${KEYCLOAK_PATH}/aether-roc-gui-client.json"

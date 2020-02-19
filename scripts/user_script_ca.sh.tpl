#!/bin/bash

# Run this script using root Vault token

# for both sets of users
vault auth enable github
vault secrets enable ssh
vault write auth/github/config organization=lockedsecrets

# CA users
echo "Configure the ssh secrets engine for SSH CA"
vault write ssh/config/ca generate_signing_key=true
vault policy write dev-policy ./policies/dev.hcl

echo "Configure the auth backend for SSH CA"
vault write auth/github/map/teams/dev value=dev-policy
vault write ssh/roles/dev @./roles/dev.json

# OTP users [create a dir named roles to put both json files into]
echo "Configure the ssh secrets engine for SSH OTP"
vault policy write qa-policy ./policies/qa.hcl

echo "Configure the auth backend for SSH OTP"
vault write auth/github/map/teams/qa value=qa-policy
vault write ssh/roles/qa @./roles/qa.json

echo "Enable auditing"
vault audit enable file file_path=/tmp/vault_audit.log
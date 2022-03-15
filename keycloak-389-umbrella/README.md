<!--
SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Keycloak-389-Umbrella Helm chart

[Keycloak] is Open Source Identity and Access Management for Modern Applications and
Services.

It can also act as a Federated [OpenID Connect] provider. It can connect to a variety of backends.
In this deployment it is connected to an [389] directory server, and a management
GUI is provided with [phpLDAPadmin]

This chart can be deployed alongside [onos-umbrella](../onos-umbrella) or any other umbrella
chart that requires an OpenID provider.

## Helm install
Add a couple repos to `helm`, if you don't already have them:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Deploy with

```
helm -n micro-onos install k3u onosproject/keycloak-389-umbrella
```

It will display details of Port Forwarding that need to be made

> These details are not given here, as they will vary by namespace.

* Add `k3u-keycloak` to your `/etc/hosts` file as an alias for localhost
* Port forward the `keycloak` service to 5557

Now GUI applications with security enabled will redirect to this `k3u-keycloak:5557`
and when login is successful will redirect to an authenticated GUI.

> To test it, browse to http://k3u-keycloak:5557/auth/realms/master/.well-known/openid-configuration to see the configuration.


There are 7 users in 6 groups with the LDIF defined in `values.yaml`

```
User             login                 Group:   mixedGroup      charactersGroup    AetherROCAdmin  EnterpriseAdmin  starbucks   acme
=====================================================================================================================================
Alice Admin      alicea@opennetworking.org         ✓                                   ✓
Bob Cratchit     bobc@opennetworking.org           ✓              ✓
Charlie Brown    charlieb@opennetworking.org                      ✓
Daisy Duke       daisyd@opennetworking.org                        ✓                                    ✓              ✓
Elmer Fudd       elmerf@opennetworking.org                        ✓                                                   ✓
Fred Flintstone  fredf@opennetworking.org                         ✓                                    ✓                          ✓
Gandalf The Grey gandalfg@opennetworking.org                      ✓                                                               ✓
```

The password for each is `password`

To use this service with `onos-umbrella` chart, deploy in Helm with the following flags:
```
helm -n micro-onos install onos-umbrella onosproject/onos-umbrella --set onos-config.openidc.issuer=http://k3u-keycloak:80/auth/realms/master --set onos-gui.openidc.issuer=http://k3u-keycloak:5557/auth/realms/master
```
> Note the different port numbers - for `onos-config` to access Keycloak, port 80 must be used, because
Keycloak is inside the cluster with this local deployment

## Adding an organization
See [examples](examples/README.md) on how to add another organization and users at runtime.

## Generate an Access token with REST
```bash
curl --location --request POST 'http://k3u-keycloak:5557/auth/realms/master/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=aether-roc-gui' \
--data-urlencode 'username=alicea' \
--data-urlencode 'password=password' \
--data-urlencode 'scope=openid profile email offline_access groups'
```

[Keycloak]: https://www.keycloak.org/
[OpenID Connect]: https://openid.net/connect/
[389]: https://directory.fedoraproject.org/
[phpLDAPadmin]: http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page


First do a port forward for the OpenLDAP pod
```bash
OPENLDAP_POD_NAME=$(kubectl -n micro-onos get pods -l "app=openldap,release=dex-ldap-umbrella" -o jsonpath="{.items[0].metadata.name}") && kubectl -n micro-onos port-forward $OPENLDAP_POD_NAME 1389:389
```

To add these example users 
```bash
ldapadd -x -w password -p 1389 -h localhost -f siemens.ldif -D cn=admin,dc=opennetworking,dc=org
```

To Modify the EnterpriseAdmin group to add a user:
```bash
ldapmodify -x -w password -p 1389 -h localhost -f siemens-ent-admin.ldif -D cn=admin,dc=opennetworking,dc=org
```

To clean up these entries:
```bash
ldapdelete -x -w password -p 1389 -h localhost -D cn=admin,dc=opennetworking,dc=org \
"cn=Harry Potter,cn=users,dc=opennetworking,dc=org" \
"cn=Indiana Jones,cn=users,dc=opennetworking,dc=org" \
"cn=siemens,cn=groups,dc=opennetworking,dc=org"
```

and remove user from EnterpriseAdmin group:
```bash
ldapmodify -x -w password -p 1389 -h localhost -f siemens-ent-admin-delete.ldif -D cn=admin,dc=opennetworking,dc=org
```


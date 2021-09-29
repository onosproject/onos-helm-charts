
First do a port forward for the OpenLDAP pod
```bash
kubectl -n micro-onos port-forward service/fedora389ds 3389:389 3636:636
```

To add these example users 
```bash
ldapadd -x -w changeme -p 3389 -h localhost -f siemens.ldif -D "cn=Directory Manager"
```

To Modify the EnterpriseAdmin group to add a user:
```bash
ldapmodify -x -w changeme -p 3389 -h localhost -f siemens-ent-admin.ldif -D "cn=Directory Manager"
```

To clean up these entries:
```bash
ldapdelete -x -w changeme -p 3389 -h localhost -D "cn=Directory Manager" \
"cn=Harry Potter,cn=users,dc=opennetworking,dc=org" \
"cn=Indiana Jones,cn=users,dc=opennetworking,dc=org" \
"cn=siemens,cn=groups,dc=opennetworking,dc=org"
```

and remove user from EnterpriseAdmin group:
```bash
ldapmodify -x -w changeme -p 3389 -h localhost -f siemens-ent-admin-delete.ldif -D "cn=Directory Manager"
```


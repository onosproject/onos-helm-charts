This folder contains self-signed certificates for use in testing. _DO NOT USE THESE
CERTIFICATES IN PRODUCTION!_

The certificates were generated with the
https://github.com/onosproject/simulators/blob/master/pkg/certs/generate_certs.sh 
script as
```bash
generate_certs.sh onos-topo.opennetworking.org
```

In this folder they **must** be (re)named
* tls.cacrt
* tls.crt
* tls.key

Use
```bash
openssl x509 -in deployments/helm/onos-topo/files/certs/tls.crt -text -noout
```
to verify the contents (especially the subject).

There is another Cert for onos-config in test/certs but these were created with:
```
generate-certs.sh onos-topo
```
and are left named onf.cacrt, onos-topo.key and onos-topo.crt
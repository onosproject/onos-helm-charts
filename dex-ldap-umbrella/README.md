# DEX-LDAP Helm chart

[Dex] is A Federated [OpenID Connect] provider. It can connect to a variety of backends.
In this deployment it is connected to an [OpenLDAP] server, and a management
GUI is provided with [phpLDAPadmin]

This chart can be deployed alongside [onos-umbrella](../onos-umbrella) or any other umbrella
chart that requires an OpenID provider.

## Helm install
Add a couple repos to `helm`, if you don't already have them:
```
helm repo add stable https://charts.helm.sh/stable
helm repo add cetic https://cetic.github.io/helm-charts
helm repo update
```

Deploy with

```
helm -n micro-onos install dex-ldap-umbrella onosproject/dex-ldap-umbrella
```

It will display details of Port Forwarding that need to be made

> These details are not given here, as they will vary by namespace.

* Add `dex-ldap-umbrella` to your `/etc/hosts` file as an alias for localhost
* Port forward the `dex` service to 32000

Now GUI applications with security enabled will redirect to this `dex-ldap-umbrella:32000`
and when login is successful will redirect to an authenticated GUI.

> To test it, browse to http://dex-ldap-umbrella:32000/.well-known/openid-configuration to see the configuration.


There are 3 users in 3 groups with the LDIF defined in `values.yaml`

```
User            login                 Group:   mixedGroup      charactersGroup    AetherROCAdmin
===============================================================================================
Alice Admin     alicea@opennetworking.org         ✓                                   ✓
Bob Cratchit    bobc@opennetworking.org           ✓              ✓
Charlie Brown   charlieb@opennetworking.org                       ✓
```

The password for each is `password`

To use this service with `onos-umbrella` chart, deploy in Helm with the following flags:
```
helm -n micro-onos install onos-umbrella onosproject/onos-umbrella --set onos-config.openidc.issuer=http://dex-ldap-umbrella:32000 --set onos-gui.openidc.issuer=http://dex-ldap-umbrella:32000
```

## Testing with Dex's example app (optional)
Get the DEX client app to run a test:
```
git clone https://github.com/dexidp/dex.git && cd dex
```

Update `examples/example-app/main.go` to add `groups` to the scope:

```go
diff --git a/examples/example-app/main.go b/examples/example-app/main.go
index e417c8b2..724599f8 100644
--- a/examples/example-app/main.go
+++ b/examples/example-app/main.go
@@ -243,7 +243,7 @@ func (a *app) handleLogin(w http.ResponseWriter, r *http.Request) {
        }
 
        authCodeURL := ""
-       scopes = append(scopes, "openid", "profile", "email")
+       scopes = append(scopes, "openid", "profile", "email", "groups")
        if r.FormValue("offline_access") != "yes" {
                authCodeURL = a.oauth2Config(scopes).AuthCodeURL(exampleAppState)
        } else if a.offlineAsScope {
```
Then make and run the example
```
make bin/example-app
./bin/example-app --issuer http://dex:32000
```
> this runs a web server on localhost:5555

In a browser window, go to http://localhost:5555

Click the login button and you will get redirected to the **dex** login form
at http://dex:32000.

Login as `test@opennetworking.org` with password `password`

Once this is correct it will bring you back to the `example-app` window and display
the token generated. This can then be passed on in a gRPC call to ONOS.

```
ID Token:

eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg2NTk4MTU2MDE3NDBkMDZiYzZkMTg4ZGYwZDMzYmFhYzJkNGY4NTIifQ.eyJpc3MiOiJodHRwOi8vZGV4OjMyMDAwIiwic3ViIjoiQ2dWMGRYTmxjaElFYkdSaGNBIiwiYXVkIjoiZXhhbXBsZS1hcHAiLCJleHAiOjE2MTE3OTE4NjIsImlhdCI6MTYxMTcwNTQ2MiwiYXRfaGFzaCI6IlNnbGpTOEM3bGE2UVpGWjZQbFUwbWciLCJlbWFpbCI6InRlc3RAb3Blbm5ldHdvcmtpbmcub3JnIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImdyb3VwcyI6WyJ0ZXN0R3JvdXAiXSwibmFtZSI6IlRlc3QgVXNlciJ9.a_EdNHfI6EJLpngm480tyZtZxQEFkX0P6S8OErHUIgJvfL0oxdp1eWmVYS8MS-UGBqK-2LTPYCuhKQ9BlD-JNK76sZnGWzjE1eiOe6f4CDXGIDnIvCfASGVrvdPxwqi0T6vyoFO9we9DTOPBYALq8lB6wfIU8TQg6Tyxfd8UWVwHJ6A14me0VJQnrYGliPAB5GDRMZ13gWR24XafDiNjpWBi72xhpwnm99k_3jMn_EPn_d9xecsD0TUBTqFihSG90RpnGcZ00p7N47_smeCb5QDejenKP5JOiSHK_nzqPOwEDWrFkhkNnCNwFt7GO3jKLvtRgv6o9VGHkTeVTTuGwA
Access Token:

eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg2NTk4MTU2MDE3NDBkMDZiYzZkMTg4ZGYwZDMzYmFhYzJkNGY4NTIifQ.eyJpc3MiOiJodHRwOi8vZGV4OjMyMDAwIiwic3ViIjoiQ2dWMGRYTmxjaElFYkdSaGNBIiwiYXVkIjoiZXhhbXBsZS1hcHAiLCJleHAiOjE2MTE3OTE4NjIsImlhdCI6MTYxMTcwNTQ2MiwiYXRfaGFzaCI6IlVJanRGUF9xWE9fT3g4ZEZCR1RJUEEiLCJlbWFpbCI6InRlc3RAb3Blbm5ldHdvcmtpbmcub3JnIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImdyb3VwcyI6WyJ0ZXN0R3JvdXAiXSwibmFtZSI6IlRlc3QgVXNlciJ9.rf_EpJ8tSm7k-XcQdDtbhcWmFFgaM87pzimGg-kCb_xJNOrkyoEVU_-QtW7szK-i7tm7yDFhyzL4wucLdOTZ-S_wXI-0-yCJYLKf8epWrEpkpmMb1FMiLRjr87AP9Tb5wr-xg_GfcYHgYd3Dgt2FnBSpgccorKOtIe3I9rVrGNtH34bHSwIfSMnlU5cq0qQC42l7q8NSNp3xBQjgED8J7lMTz_-RDw9efj3JtNF8JrsN8icXs7bpBbbUR_KiRU9HzApBSh9nBxwNODmy7z4530oROu5ZPjsHVQlRS13BnbXTLFqp7zub7-WuQBsaUY-FYDlPlVaisZtPMX3oKq6D7A
Claims:

{
  "iss": "http://dex:32000",
  "sub": "CgV0dXNlchIEbGRhcA",
  "aud": "example-app",
  "exp": 1611791862,
  "iat": 1611705462,
  "at_hash": "SgljS8C7la6QZFZ6PlU0mg",
  "email": "test@opennetworking.org",
  "email_verified": true,
  "groups": [
    "testGroup"
  ],
  "name": "Test User"
}
```

The adventurous can try copying the ID token or Access token across in to https://jwt.io
to see the decoded value.

> At no point is your password stored anywhere or kept in the example app

## dex grpc interface 
This is only for administering dex - list passwords, create etc
To get the dex grpc-client to work with the helm installed dex server

1) `km port-forward dex-9c4f8cb5d-7xmpn 5150`
2) copy the ca.crt and ca.key from the dex server down to your local machine in the dex source folder
3) run
```bash
mkdir -p {certs,crl,newcerts}
touch index.txt
echo 1000 > serial
```
1) then gen a client cert with the ca key
```bash
# Client private key (unencrypted)
openssl genrsa -out client.key 2048
# Signed client certificate signing request (CSR)
openssl req -config examples/grpc-client/openssl.conf -new -sha256 -key client.key -out client.csr -subj "/CN=fake-client"
# Certificate Authority signs CSR to grant a certificate
openssl ca -batch -config examples/grpc-client/openssl.conf -extensions usr_cert -days 365 -notext -md sha256 -in client.csr -out client.crt -cert ca.crt -keyfile ca.key
```

4) add `dex.example.com` as `127.0.0.1` to your `/etc/hosts`

5) edit `examples/grpc-client/client.go`

```go
diff --git a/examples/grpc-client/client.go b/examples/grpc-client/client.go
index e4cd526d..62dec6ba 100644
--- a/examples/grpc-client/client.go
+++ b/examples/grpc-client/client.go
@@ -57,12 +57,13 @@ func createPassword(cli api.DexClient) error {
        }
 
        // Create password.
-       if resp, err := cli.CreatePassword(context.TODO(), createReq); err != nil || resp.AlreadyExists {
-               if resp.AlreadyExists {
-                       return fmt.Errorf("Password %s already exists", createReq.Password.Email)
-               }
+       resp1, err := cli.CreatePassword(context.TODO(), createReq)
+       if err != nil {
                return fmt.Errorf("failed to create password: %v", err)
        }
+       if resp1.AlreadyExists {
+               return fmt.Errorf("Password %s already exists", createReq.Password.Email)
+       }
        log.Printf("Created password with email %s", createReq.Password.Email)
 
        // List all passwords.
@@ -129,13 +130,14 @@ func main() {
        caCrt := flag.String("ca-crt", "", "CA certificate")
        clientCrt := flag.String("client-crt", "", "Client certificate")
        clientKey := flag.String("client-key", "", "Client key")
+       address := flag.String("address", "127.0.0.1:5557", "address:port")
        flag.Parse()
 
        if *clientCrt == "" || *caCrt == "" || *clientKey == "" {
                log.Fatal("Please provide CA & client certificates and client key. Usage: ./client --ca-crt=<path ca.crt> --client-crt=<path client.crt> --client-key=<path client key>")
        }
 
-       client, err := newDexClient("127.0.0.1:5557", *caCrt, *clientCrt, *clientKey)
+       client, err := newDexClient(*address, *caCrt, *clientCrt, *clientKey)
        if err != nil {
                log.Fatalf("failed creating dex client: %v ", err)
        }
```

1) access the server with 
```bash
./bin/grpc-client -ca-crt=ca.crt -client-crt=client.crt -client-key=client.key -address=dex.example.com:5150
```

Gives a result like
```
2020/07/01 20:38:27 Created password with email test@example.com
2020/07/01 20:38:27 Listing Passwords:
2020/07/01 20:38:27 email:"test@example.com" username:"test" user_id:"test" 
2020/07/01 20:38:27 email:"aether@opennetworking.org" username:"admin" user_id:"08a8684b-db88-4b73-90a9-3cd1661f5467" 
2020/07/01 20:38:27 email:"sean@opennetworking.org" username:"sean" user_id:"08a8684b-db88-4b73-90a9-3cd1661f5468" 
2020/07/01 20:38:27 Verifying Password:
2020/07/01 20:38:28 properly verified correct password: true
2020/07/01 20:38:28 properly failed to verify incorrect password: false
2020/07/01 20:38:28 Listing Passwords:
2020/07/01 20:38:28 email:"test@example.com" username:"test" user_id:"test" 
2020/07/01 20:38:28 email:"aether@opennetworking.org" username:"admin" user_id:"08a8684b-db88-4b73-90a9-3cd1661f5467" 
2020/07/01 20:38:28 email:"sean@opennetworking.org" username:"sean" user_id:"08a8684b-db88-4b73-90a9-3cd1661f5468" 
2020/07/01 20:38:28 Deleted password with email test@example.com
```

[Dex]: http://dexidp.io
[OpenID Connect]: https://openid.net/connect/
[OpenLDAP]: https://www.openldap.org
[phpLDAPadmin]: http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page

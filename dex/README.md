# DEX Helm chart

[Dex] is an OpenID provider proxy

## Helm install
Deploy with

```
helm -n micro-onos install dex stable/dex --values=dex/values.yaml
```

## Running example app
```bash
DEX_POD_NAME=$(kubectl get pods --namespace micro-onos -l "app.kubernetes.io/name=dex,app.kubernetes.io/instance=dex" -o jsonpath="{.items[0].metadata.name}") \
kubectl -n micro-onos port-forward $DEX_POD_NAME 32000:5556
```

Then in a separate terminal
```bash
./bin/example-app --issuer http://dex:32000
```
> this runs a web server on localhost:5555

In a browser window, go to http://localhost:5555

Click the login button and you will get redirected to the **dex** login form.

Enter one of the passwords in the static password list in `values.yaml` e.g. 
`aether@opennetworking.org` pw `rocks`

Once this is correct it will bring you back to the `example-app` window and display
the token generated. This can then be passed on in a gRPC call to ONOS.

```
ID Token:

eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwODdhYWQ5NTA3MzQ3YzJkOGQyNGQxYmE4YjEzY2E0NDAyNWFmMGEifQ.eyJpc3MiOiJodHRwOi8vZGV4OjMyMDAwIiwic3ViIjoiQ2lRd09HRTROamcwWWkxa1lqZzRMVFJpTnpNdE9UQmhPUzB6WTJReE5qWXhaalUwTmpnU0JXeHZZMkZzIiwiYXVkIjoiZXhhbXBsZS1hcHAiLCJleHAiOjE1OTM3NjIxODUsImlhdCI6MTU5MzY3NTc4NSwiYXRfaGFzaCI6InowUGZqbHBmeTNqaGw1M2NoTVppQ2ciLCJlbWFpbCI6InNlYW5Ab3Blbm5ldHdvcmtpbmcub3JnIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJzZWFuIn0.SdL6ShQ7tHE2skA-FhSD4Ep1NSvAzGJHUH0tbX3FJQN4w-MdWtumKr51blRVY_VDkD6V9-DibLJdt1Oxg2yBoWNIu600sDQDBXhbzCCCfdUNYCo4PsYmoFr-vvLmD0VxgGmg1vvoKTwBxzM1EfzuuMgKrYfVYZx2_5XWGI2P826w4lZa2i4NT6H9GR9IokKPvRxfIJqYvfw61Z3li9XYVz2cyFpgXoxHqY9yC44M21LO1DtUZ5fWCOi2UhYKrNHl2_KFZ2JlmsuuqTga0hyM-_8H6QKLL7j1ZNjSBXYDftZFLp__5K7C4COZenjdEfDg0ugCEwoZgnTZnKymavTEpg
Access Token:

eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwODdhYWQ5NTA3MzQ3YzJkOGQyNGQxYmE4YjEzY2E0NDAyNWFmMGEifQ.eyJpc3MiOiJodHRwOi8vZGV4OjMyMDAwIiwic3ViIjoiQ2lRd09HRTROamcwWWkxa1lqZzRMVFJpTnpNdE9UQmhPUzB6WTJReE5qWXhaalUwTmpnU0JXeHZZMkZzIiwiYXVkIjoiZXhhbXBsZS1hcHAiLCJleHAiOjE1OTM3NjIxODUsImlhdCI6MTU5MzY3NTc4NSwiYXRfaGFzaCI6ImlhQ2tjVUtvUjJSNTZqMTNqRDIzX1EiLCJlbWFpbCI6InNlYW5Ab3Blbm5ldHdvcmtpbmcub3JnIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJzZWFuIn0.V2buJs120iBx2xpworDRmddLeJ9_iTsMnFPhLG-EVB8pxmYNA0JEP1WzNxU5schRWLtktjGeyZZSJP1rP71L5uF2tu0f_OhE5lk7E3TR_Aumx46laX0_NzLf3-2T-yPhEuqiyuPqBepB7xGS84dHIV7m869OCg2Rdct_1ue9PaAH-dVltpbIHvdnrLut4Y_3cYwluIQB0y361Vni-vf7-T29ps204SG_lrol9bTO7QgvaczXW_CeZ0xZrRqQ61zSMZCWSbbmmYGufrQOpu2jAJo4aXgIc6g0Kzp-4v26134JZ5weHGNfXCL3go8ehw7E5EcNvqKXAg0g-yIKAma_xQ
Claims:

{
  "iss": "http://dex:32000",
  "sub": "CiQwOGE4Njg0Yi1kYjg4LTRiNzMtOTBhOS0zY2QxNjYxZjU0NjgSBWxvY2Fs",
  "aud": "example-app",
  "exp": 1593762185,
  "iat": 1593675785,
  "at_hash": "z0Pfjlpfy3jhl53chMZiCg",
  "email": "sean@opennetworking.org",
  "email_verified": true,
  "name": "sean"
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
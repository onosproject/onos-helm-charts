module github.com/onosproject/onos-helm-charts

go 1.14

require (
	github.com/docker/docker v1.13.1 // indirect
	github.com/golangplus/testing v0.0.0-20180327235837-af21d9c3145e
	github.com/googleapis/gnostic v0.3.0 // indirect
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/mattn/go-colorable v0.1.4 // indirect
	github.com/mattn/go-isatty v0.0.12 // indirect
	github.com/onosproject/helmit v0.6.0
	github.com/stretchr/testify v1.5.1
	gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15 // indirect
	k8s.io/client-go v0.17.3
)

replace github.com/docker/docker => github.com/docker/engine v1.4.2-0.20200229013735-71373c6105e3

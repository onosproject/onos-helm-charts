module github.com/onosproject/onos-helm-charts

go 1.14

require (
	github.com/golangplus/bytes v1.0.0 // indirect
	github.com/golangplus/testing v1.0.0
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/mattn/go-colorable v0.1.4 // indirect
	github.com/mattn/go-isatty v0.0.12 // indirect
	github.com/onosproject/helmit v0.6.13
	github.com/onosproject/onos-test v0.6.2
	github.com/stretchr/testify v1.7.0
	k8s.io/client-go v0.21.0
)

replace github.com/docker/docker => github.com/docker/engine v1.4.2-0.20200229013735-71373c6105e3

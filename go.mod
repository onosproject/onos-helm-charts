module github.com/onosproject/onos-helm-charts

go 1.13

require (
	github.com/golangplus/testing v0.0.0-20180327235837-af21d9c3145e
	github.com/onosproject/helmit v0.5.0
	github.com/onosproject/onos-ric v0.0.0-20200225182040-dcf370614b8e // indirect
	github.com/renstrom/dedent v1.0.0 // indirect
	github.com/stretchr/testify v1.5.1
	golang.org/x/tools v0.0.0-20200313205530-4303120df7d8 // indirect
	k8s.io/client-go v0.17.3
)

replace github.com/docker/docker => github.com/docker/engine v1.4.2-0.20200229013735-71373c6105e3

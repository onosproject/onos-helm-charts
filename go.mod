module github.com/onosproject/onos-helm-charts

go 1.13

require (
	github.com/golangplus/testing v0.0.0-20180327235837-af21d9c3145e
	github.com/onosproject/onos-test v0.0.0-20200317230736-b84f700a69ff
	github.com/stretchr/testify v1.5.1
	k8s.io/client-go v0.17.3
)

replace github.com/docker/docker => github.com/docker/engine v1.4.2-0.20200229013735-71373c6105e3

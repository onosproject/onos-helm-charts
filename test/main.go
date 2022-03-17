// SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
//
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"github.com/onosproject/helmit/pkg/registry"
	"github.com/onosproject/helmit/pkg/test"
	config "github.com/onosproject/onos-helm-charts/onos-config/tests"
	topo "github.com/onosproject/onos-helm-charts/onos-topo/tests"
	onosumbrella "github.com/onosproject/onos-helm-charts/onos-umbrella/tests"
	_ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
)

func main() {
	registry.RegisterTestSuite("onos-topo", &topo.ONOSTopoSuite{})
	registry.RegisterTestSuite("onos-config", &config.ONOSConfigSuite{})
	registry.RegisterTestSuite("onos-umbrella", &onosumbrella.OnosUmbrellaSuite{})
	test.Main()
}

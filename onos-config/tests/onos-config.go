# SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

package tests

import (
	"github.com/golangplus/testing/assert"
	"github.com/onosproject/helmit/pkg/helm"
	"github.com/onosproject/helmit/pkg/input"
	"github.com/onosproject/helmit/pkg/test"
	"github.com/onosproject/onos-test/pkg/onostest"
	"testing"
	"time"
)

// ONOSConfigSuite is the onos-config chart test suite
type ONOSConfigSuite struct {
	test.Suite
	c *input.Context
}

// SetupTestSuite sets up the onos-topo test suite
func (s *ONOSConfigSuite) SetupTestSuite(c *input.Context) error {
	s.c = c
	return nil
}

// TestInstall tests installing the onos-config chart
func (s *ONOSConfigSuite) TestInstall(t *testing.T) {
	registry := s.c.GetArg("registry").String("")

	topo := helm.Chart("onos-topo", onostest.OnosChartRepo).
		Release("onos-topo").
		Set("global.image.registry", registry)
	assert.NoError(t, topo.Install(false))

	config := helm.Chart("onos-config", onostest.OnosChartRepo).
		Release("onos-config").
		WithTimeout(15 * time.Minute).
		Set("global.image.registry", registry)
	assert.NoError(t, config.Install(true))
}

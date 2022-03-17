// SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
//
// SPDX-License-Identifier: Apache-2.0

package tests

import (
	"github.com/onosproject/helmit/pkg/helm"
	"github.com/onosproject/helmit/pkg/input"
	"github.com/onosproject/helmit/pkg/test"
	"github.com/onosproject/onos-test/pkg/onostest"
	"github.com/stretchr/testify/assert"
	"testing"
)

// ONOSTopoSuite is the onos-topo chart test suite
type ONOSTopoSuite struct {
	test.Suite
	c *input.Context
}

// SetupTestSuite sets up the onos-topo test suite
func (s *ONOSTopoSuite) SetupTestSuite(c *input.Context) error {
	s.c = c
	return nil
}

// TestInstall tests installing the onos-topo chart
func (s *ONOSTopoSuite) TestInstall(t *testing.T) {
	registry := s.c.GetArg("registry").String("")
	topo := helm.Chart("onos-topo", onostest.OnosChartRepo).
		Release("onos-topo").
		Set("global.image.registry", registry)
	assert.NoError(t, topo.Install(true))
}

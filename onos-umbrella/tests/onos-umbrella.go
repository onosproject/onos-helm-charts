# SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

package tests

import (
	"github.com/onosproject/helmit/pkg/helm"
	"github.com/onosproject/helmit/pkg/input"
	"github.com/onosproject/helmit/pkg/test"
	"github.com/onosproject/onos-test/pkg/onostest"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

// OnosUmbrellaSuite is the onos-umbrella chart test suite
type OnosUmbrellaSuite struct {
	test.Suite
	c *input.Context
}

// SetupTestSuite sets up the onos umbrella test suite
func (s *OnosUmbrellaSuite) SetupTestSuite(c *input.Context) error {
	s.c = c
	return nil
}

// TestInstall tests installing the onos-umbrella chart
func (s *OnosUmbrellaSuite) TestInstall(t *testing.T) {
	registry := s.c.GetArg("registry").String("")
	onos := helm.Chart("onos-umbrella", onostest.OnosChartRepo).
		Release("onos-umbrella").
		WithTimeout(15 * time.Minute).
		Set("import.onos-gui.enabled", false).
		Set("import.onos-cli.enabled", false).
	    Set("global.image.registry", registry)

		assert.NoError(t, onos.Install(true))
}

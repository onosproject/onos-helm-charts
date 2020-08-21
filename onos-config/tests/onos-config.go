// Copyright 2020-present Open Networking Foundation.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package tests

import (
	"github.com/golangplus/testing/assert"
	"github.com/onosproject/helmit/pkg/helm"
	"github.com/onosproject/helmit/pkg/test"
	"github.com/onosproject/onos-test/pkg/onostest"
	"testing"
)

// ONOSConfigSuite is the onos-config chart test suite
type ONOSConfigSuite struct {
	test.Suite
}

const onosComponentName = "onos-config"
const testName = "chart-test"

// TestInstall tests installing the onos-config chart
func (s *ONOSConfigSuite) TestInstall(t *testing.T) {
	atomix := helm.Chart(onostest.ControllerChartName, onostest.AtomixChartRepo).
		Release(onostest.AtomixName(testName, onosComponentName)).
		Set("scope", "Namespace")
	assert.NoError(t, atomix.Install(true))

	raft := helm.Chart(onostest.RaftStorageControllerChartName, onostest.AtomixChartRepo).
		Release(onostest.RaftReleaseName(onosComponentName)).
		Set("scope", "Namespace")
	assert.NoError(t, raft.Install(true))

	topo := helm.Chart("onos-topo", onostest.OnosChartRepo).
		Release("onos-topo").
		Set("storage.controller", onostest.AtomixController(testName, onosComponentName))
	assert.NoError(t, topo.Install(false))

	config := helm.Chart("onos-config", onostest.OnosChartRepo).
		Release("onos-config").
		Set("storage.controller", onostest.AtomixController(testName, onosComponentName))
	assert.NoError(t, config.Install(true))
}

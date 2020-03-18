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
	"github.com/onosproject/onos-test/pkg/helm"
	"github.com/onosproject/onos-test/pkg/test"
	"github.com/stretchr/testify/assert"
	"testing"
)

// AtomixControllerSuite is the atomix-controller chart test suite
type AtomixControllerSuite struct {
	test.Suite
}

// TestInstallClusterScoped tests installing the atomix-controller chart at the cluster scope
func (s *AtomixControllerSuite) TestInstallClusterScoped(t *testing.T) {
	atomix := helm.Helm().
		Chart("/etc/onos-helm-charts/atomix-controller").
		Release("atomix-controller-cluster").
		Set("scope", "Cluster")
	assert.NoError(t, atomix.Install(true))

	clusterRoles, err := atomix.RbacV1().ClusterRoles().List()
	assert.NoError(t, err)
	assert.Len(t, clusterRoles, 1)

	clusterRoleBindings, err := atomix.RbacV1().ClusterRoleBindings().List()
	assert.NoError(t, err)
	assert.Len(t, clusterRoleBindings, 1)

	err = atomix.Uninstall()
	assert.NoError(t, err)
}

// TestInstallNamespaceScoped tests installing the atomix-controller chart at the namespace scope
func (s *AtomixControllerSuite) TestInstallNamespaceScoped(t *testing.T) {
	atomix := helm.Helm().
		Chart("/etc/onos-helm-charts/atomix-controller").
		Release("atomix-controller-namespace").
		Set("scope", "Namespace")
	assert.NoError(t, atomix.Install(true))

	roles, err := atomix.RbacV1().Roles().List()
	assert.NoError(t, err)
	assert.Len(t, roles, 1)

	roleBindings, err := atomix.RbacV1().RoleBindings().List()
	assert.NoError(t, err)
	assert.Len(t, roleBindings, 1)

	err = atomix.Uninstall()
	assert.NoError(t, err)
}

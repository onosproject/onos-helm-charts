<!--
SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

# Deprecated
This directory contains the old structure of the Stratum configuration models.
It has been left here so that it can be retrofited to use the new sidecar config model
plugins sometime in the near future.

## NOTE

`onos-operator:0.5.0` dropped support for the CRDs defined in this chart.
The last version that supports it is: `0.4.14`

To install that:
```
ONOS_OPERATOR_VERSION=0.4.14
helm upgrade --install -n kube-system onos-operator onosproject/onos-operator --version $ONOS_OPERATOR_VERSION
```

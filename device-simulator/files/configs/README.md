<!--
SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>

SPDX-License-Identifier: Apache-2.0
-->

This folder contains test configurations that are loaded into the application
via a `ConfigMap` when deploying via this Helm chart. The root test configurations
are copied here because Helm does not allow files outside the chart to be accessed
via templates. Changes to the root test configurations should be reflected here.

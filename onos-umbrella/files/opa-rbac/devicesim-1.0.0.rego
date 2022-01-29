# SPDX-FileCopyrightText: 2022-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

package devicesim_1_0_x_1_0_0

echo[config] {
    config := input
}


allowed[config] {
    config := {
        "interfaces": {
            "interface": [
                interfaces_rule
            ]
        },
        "components": {
            "component": [
                components_rule
            ]
        },
        "system": object.get(input, "system", {})
    }
}

interfaces_rule[interface] {
    # for each interface in input
    interface := input.interfaces.interface[_]
    # Allow the interface through only if its name is in the groups list,
    # or "AetherROCAdmin is in the groups list
    ["AetherROCAdmin", interface.name][_] == input.groups[i]
}

components_rule[component] {
    component := input.components.component[_]
    ["AetherROCAdmin", component.name][_] == input.groups[i]
}
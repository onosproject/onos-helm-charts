# SPDX-FileCopyrightText: 2022-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: LicenseRef-ONF-Member-Only-1.0

package devicesim_1_0_0

echo[config] {
    config := input
}


allowed[config] {
    interface := interfaces_rule # defer to interfaces rule below
    system := system_rule
    config := {
        "interfaces": {
            "interface": [
                interface
            ]
        },
        "system": input.system,
    }
}

interfaces_rule[interface] {
    interface := input.interfaces.interface[_] # for each interface in input
    ["AetherROCAdmin", interface.name][_] == input.groups[i]
}

system_rule[system] {
    system := input.system[_]
}
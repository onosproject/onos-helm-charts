# SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

package testdevice_1_0_0

countlist2a[numelems] {
    numelems := count(input.cont1a.list2a)
}

countlist4[numelems] {
    numelems := count(input.cont1a.list4)
}

allowed[config] {
    list2a := list2as # refer to rule below
    list4 := list4s
    list5 := list5s
    config := {
        "cont1a": {
            "cont2a": cont2aLeafs,
            "leaf1a": input.cont1a.leaf1a,
            "list2a": list2a,
            "list4": list4,
            "list5": list5,
        },
        "leafAtTopLevel": input.leafAtTopLevel,
    }
}

cont2aLeafs[name] = val {
    val := input.cont1a.cont2a[i]
    name := i
}

leaf2aRef[leaf2a] = val{
    leaf2a := "leaf2a"
    val := input.cont1a.cont2a.leaf2a
    leaf2a != null
}

leaf2cRef[leaf2c] = val{
    leaf2c := "leaf2c"
    val := input.cont1a.cont2a.leaf2c
    leaf2c != null
}

list2as[list2a] {
    list2a := input.cont1a.list2a[_]
    list4 := input.cont1a.list4[_]
    # Only allow instances of list2a that have name == id of list4
    list2a.name == list4.id
}

list4s[list4] {
    list4 := input.cont1a.list4[_]
    list2a := input.cont1a.list2a[_]
    # Only allow instances of list4 that have id == name of list2a
    list2a.name == list4.id
}

list5s[list5] {
    list5 := input.cont1a.list5[_]
}

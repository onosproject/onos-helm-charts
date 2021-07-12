# Copyright 2021-present Open Networking Foundation.
#//
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
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

package main

import (
	"bytes"
	"gotest.tools/assert"
	htmltemplate "html/template"
	"strings"
	"testing"
	texttemplate "text/template"

	//texttemplate "text/template"
)

func Test_convertYaml(t *testing.T) {
	index, err := getIndexYaml("sample-index")
	assert.NilError(t, err, "Unexpected error loading YAML")
	assert.Equal(t, 8, len(index.Entries))

	tmplAppsListText, _ := texttemplate.New("yamlAppsTemplate").Parse(yamlAppsTemplate)
	markdownBuffer := new(bytes.Buffer)
	tmplAppsListText.Execute(markdownBuffer, index)
	assert.Equal(t, 10538, len(markdownBuffer.String()))
	assert.Assert(t, strings.HasPrefix(markdownBuffer.String(), "#ONOS Helm Chart Releases"))

	tmplAppsListHtml, _ := htmltemplate.New("yamlAppsTemplate").Parse(yamlAppsTemplateHtml)
	xhtmlBuffer := new(bytes.Buffer)
	tmplAppsListHtml.Execute(xhtmlBuffer, index)
	assert.Equal(t, 13374, len(xhtmlBuffer.String()))
	assert.Assert(t, strings.HasPrefix(xhtmlBuffer.String(), "<!DOCTYPE html"))


}

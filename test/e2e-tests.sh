#!/usr/bin/env bash

# Copyright 2019 The Tekton Authors
#
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

# Configure the number of parallel tests running at the same time, start from 0
MAX_NUMBERS_OF_PARALLEL_TASKS=7 # => 8

export RELEASE_YAML=https://github.com/tektoncd/pipeline/releases/download/v0.40.0/release.yaml



cd $(git rev-parse --show-toplevel)
echo $(dirname $0)

source $(dirname $0)/../vendor/e2e-tests.sh
source $(dirname $0)/e2e-common.sh

TMPF=$(mktemp /tmp/.mm.XXXXXX)
clean() { rm -f ${TMPF}; }
trap clean EXIT

set -ex
set -o pipefail

echo "this is quan's test"
pip3 install pyyaml

all_tests=$(echo task/*/tests)

test_yaml_can_install "${all_tests}"

function test_tasks {
    local cnt=0
    local task_to_tests=""

    for runtest in $@;do
        task_to_tests="${task_to_tests} ${runtest}"
        if [[ ${cnt} == "${MAX_NUMBERS_OF_PARALLEL_TASKS}" ]];then
            test_task_creation_git "${task_to_tests}"
            cnt=0
            task_to_tests=""
            continue
        fi
        cnt=$((cnt+1))
    done

    # in case if there are some remaining tasks
    if [[ -n ${task_to_tests} ]];then
        test_task_creation_git "${task_to_tests}"
    fi
}

test_tasks "${all_tests}"

success

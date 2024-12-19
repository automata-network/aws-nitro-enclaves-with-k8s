#!/bin/bash
# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

###################################################
# Main
####################################################

to_lower_case() {
  echo $1 | awk '{print tolower($0)}'
}

main() {
  local project_name=$1
  local image="$project_name-$(to_lower_case ${CONFIG_SETUP_UUID}):latest"
  local build_path=$WORKING_DIR/container
  local dockerfile_path=$build_path/$project_name/Dockerfile

  docker image rm $image || true
  docker build --target image \
    --build-arg config_region=$CONFIG_REGION \
    -t $image -f $dockerfile_path $build_path || {
    say_err "Error while building docker image! (Code: $?)"
    return $FAILURE
  }
}

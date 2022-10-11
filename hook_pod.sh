#!/bin/sh

framework_work_path=$(cd "$(dirname "$0")"; pwd)
framework_project_file=$(/usr/bin/find ${framework_work_path} -name "*.xcodeproj" -maxdepth 1)
framework_pbxproj_file="${framework_project_file}/project.pbxproj"
framework_pod_root_path="${framework_work_path}/Pods"

function get_framework_name() {
local t_app_suffix=${framework_project_file##*/}
local t_app_name=${t_app_suffix%%.*}
echo $t_app_name
}

function apply_framework_search_path() {
local framework_name=$(get_framework_name)
local xcconfig_file_list=$(/usr/bin/find ${framework_pod_root_path} -name "Pods-${framework_name}.*.xcconfig" -print | ${framework_work_path}/Shell/gsed -En "s/ /=/gp")
for xcconfig_file in ${xcconfig_file_list[@]}; do
xcconfig_file=$(echo ${xcconfig_file} | ${framework_work_path}/Shell/gsed -En "s/=/\ /gp")
if [[ -f ${xcconfig_file} ]]; then
local config_mode=$(echo ${xcconfig_file} | ${framework_work_path}/Shell/gsed -En "s/.[^.]*\.([a-z]*)\.xcconfig/\1/p")
local replace_file="${framework_work_path}/.git/framework_search_config"
if [[ -f ${replace_file} ]]; then
while read line
do
local config_source=${line%%=>*}
local config_dst=${line##*=>}
${framework_work_path}/Shell/gsed -E -i "s:\\$\{PODS_ROOT\}\/${config_source}/Framework:${config_dst}:g" "${xcconfig_file}"
done < ${replace_file}
fi
fi
done
}

function apply_header_search_path() {
local framework_name=$(get_framework_name)
local xcconfig_file_list=$(/usr/bin/find ${framework_pod_root_path} -name "Pods-${framework_name}.*.xcconfig" -print | ${framework_work_path}/Shell/gsed -En "s/ /=/gp")
for xcconfig_file in ${xcconfig_file_list[@]}; do
xcconfig_file=$(echo ${xcconfig_file} | ${framework_work_path}/Shell/gsed -En "s/=/\ /gp")
if [[ -f ${xcconfig_file} ]]; then
local config_mode=$(echo ${xcconfig_file} | ${framework_work_path}/Shell/gsed -En "s/.[^.]*\.([a-z]*)\.xcconfig/\1/p")
local replace_file="${framework_work_path}/.git/header_search_config"
if [[ -f ${replace_file} ]]; then
while read line
do
local config_source=${line%%=>*}
local config_dst=${line##*=>}
${framework_work_path}/Shell/gsed -E -i "s:\\$\{PODS_ROOT\}\/${config_source}:${config_dst}:g" "${xcconfig_file}"
done < ${replace_file}
fi
fi
done
}

apply_framework_search_path

apply_header_search_path



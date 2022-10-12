#!/bin/sh

shell_path=$(cd "$(dirname "$0")"; pwd)
app_work_path=$(cd "$(dirname "${shell_path}")"; pwd)
framework_parent_path=$(cd "$(dirname "${app_work_path}")"; pwd)/yd_framework_code
app_workspace_file="$(find ${app_work_path} -name "*.xcworkspace" -maxdepth 1)/contents.xcworkspacedata"
framework_work_path=$(cd "$(dirname "${shell_path}")"; pwd)
framework_project_file=$(/usr/bin/find ${framework_work_path} -name "*.xcodeproj" -maxdepth 1)

function display_error_msg() {
  local error_msg=$1
    echo "  ...... \033[31m ${error_msg}  ...... \033[0m"
}

function display_normal_mas() {
  local error_msg=$1
    echo "  ++++++ \033[32m ${error_msg}  ++++++ \033[0m"
}

function remove_lib_pod() {
  local pbxproj_file="${framework_project_file}/project.pbxproj"
  if [[ -f "${pbxproj_file}" ]]; then
    ${shell_path}/gsed -E -i "/libPods/d" ${pbxproj_file}
  fi
}

function get_installed_list() {
  local main_git_path="${app_work_path}/.git"
  if [[ ! -d ${main_git_path} ]]; then
  display_error_msg "主项目.git目录不存在，不能读取安装配置文件"
  exit 1
  fi

  local fw_search_config_file="${main_git_path}/framework_search_config"
    if [[ ! -f ${fw_search_config_file} ]]; then
      display_error_msg "主项目安装配置文件不存在"
      exit 1
  fi

  unset installed_list
  while read line
  do
  local framework_name=${line%%=>*}
  installed_list+=("${framework_name}")
  done < ${fw_search_config_file}

  echo ${installed_list[*]}
}

function clear_config_for_framework() {
  local framework_name=$1
  local framework_path="${framework_parent_path}/${framework_name}"
  local framework_git_path="${framework_path}/.git"

  if [[ ! -d ${framework_git_path} ]]; then
  return 1
  fi

  cd ${framework_git_path}

  local header_search_config_file="${framework_git_path}/header_search_config"
  if [[ -f ${header_search_config_file} ]]; then
  /bin/rm ${header_search_config_file}
  fi

  local framework_search_config_file="${framework_git_path}/framework_search_config"
  if [[ -f ${framework_search_config_file} ]]; then
  /bin/rm ${framework_search_config_file}
  fi

  local main_git_path="${app_work_path}/.git"
  if [[ ! -d ${main_git_path} ]]; then
  display_error_msg "主项目.git目录不存在，不能读取安装配置文件"
  exit 1
  fi

  cd ${main_git_path}

  local framework_search_config_file="${main_git_path}/framework_search_config"
  if [[ -f ${framework_search_config_file} ]]; then
  ${shell_path}/gsed -E -i "/${framework_name}/d" ${framework_search_config_file}
  fi

  local header_search_config_file="${main_git_path}/header_search_config"
  if [[ -f ${header_search_config_file} ]]; then
  ${shell_path}/gsed -E -i "/${framework_name}/d" ${header_search_config_file}
  fi

  cd ${app_work_path}

  if [[ -f "${app_workspace_file}" ]]; then
  ${shell_path}/gsed -E -i "/^\\s*<FileRef\\s+location\\s{1}=\\s{1}\".[^>]+${framework_name}.[^>]+\"\/>/d" ${app_workspace_file}
  local remain_nums=$(${shell_path}/ggrep -E "${framework_name}" ${app_workspace_file})
  if [[ -n "${remain_nums}" ]]; then
  ${shell_path}/gsed -E -i -e "/${framework_name}/{n;d;}" -e "$!N;/\n.*${framework_name}/!P;D" ${app_workspace_file}
  ${shell_path}/gsed -E -i "/${framework_name}/d" ${app_workspace_file}
  fi
  fi

# pod install --verbose --no-repo-update
}

function clear_main_config() {
local main_git_path="${app_work_path}/.git"
if [[ ! -d ${main_git_path} ]]; then
display_error_msg "主项目.git目录不存在，不能读取安装配置文件"
exit 1
fi

cd ${main_git_path}

local framework_search_config_file="${main_git_path}/framework_search_config"
if [[ -f ${framework_search_config_file} ]]; then
/bin/rm ${framework_search_config_file}
fi

local header_search_config_file="${main_git_path}/header_search_config"
if [[ -f ${header_search_config_file} ]]; then
/bin/rm ${header_search_config_file}
fi

cd ${app_work_path}

if [[ -f "${app_workspace_file}" ]]; then
${shell_path}/gsed -E -i "/^\\s*<FileRef\\s+location\\s{1}=\\s{1}\".[^>]+yd_framework_code.[^>]+\"\/>/d" ${app_workspace_file}
local remain_nums=$(${shell_path}/ggrep -E "yd_framework_code" ${app_workspace_file})
if [[ -n "${remain_nums}" ]]; then
${shell_path}/gsed -E -i -e "/yd_framework_code/{n;d;}" -e "$!N;/\n.*yd_framework_code/!P;D" ${app_workspace_file}
${shell_path}/gsed -E -i "/yd_framework_code/d" ${app_workspace_file}
fi
fi

cd ${app_work_path}

rm "${app_work_path}/Podfile.lock"

pod install --verbose --no-repo-update

remove_lib_pod
}

function clear_all() {
  local installed_list=$(get_installed_list)
  for framework_name in ${installed_list[@]}; do
  clear_config_for_framework ${framework_name}
  done
}

echo "**************** begin clear project  ****************"

if [ "$#" == "1" ] && [ "$1" == "all" ]; then
clear_all
clear_main_config
else
for arg in "$@"
do
echo "begin clear $arg ............."
clear_config_for_framework ${arg}
done
fi

echo "**************** complete clear project $lib_name ****************"

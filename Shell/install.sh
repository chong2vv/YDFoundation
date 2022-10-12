#!/bin/sh

shell_path=$(cd "$(dirname "$0")"; pwd)
app_work_path=$(cd "$(dirname "${shell_path}")"; pwd)
framework_parent_path=$(cd "$(dirname "${app_work_path}")"; pwd)/yd_framework_code
framework_work_path=$(cd "$(dirname "${shell_path}")"; pwd)
framework_project_file=$(/usr/bin/find ${framework_work_path} -name "*.xcodeproj" -maxdepth 1)


function display_error_msg() {
    local error_msg=$1
    echo "  ...... \033[31m ${error_msg} \033[0m ......"
}

function display_normal_mas() {
    local error_msg=$1
    echo "  ++++++ \033[32m ${error_msg} \033[0m ++++++"
}

function remove_lib_pod() {
local pbxproj_file="${framework_project_file}/project.pbxproj"
if [[ -f "${pbxproj_file}" ]]; then
${shell_path}/gsed -E -i "/libPods/d" ${pbxproj_file}
fi
}

function add_sub_proj_to_workspace() {
    local fw_name=$1
    local app_workspace_file="$(find ${app_work_path} -name "*.xcworkspace" -maxdepth 1)/contents.xcworkspacedata"
    if [[ -f "${app_workspace_file}" ]]; then
        # ${shell_path}/gsed -E -i -e "/yd_framework_code\/${fw_name}/{n;d;}" -e "$!N;/\n.*yd_framework_code\/${fw_name}/!P;D" ${app_workspace_file}
        ${shell_path}/gsed -E -i "/yd_framework_code\/${fw_name}/d" ${app_workspace_file}
        local sub_proj_path="$(cd "$(dirname "${app_work_path}")"; pwd)/yd_framework_code/${fw_name}/${fw_name}.xcodeproj"
        ${shell_path}/gsed -E -i "\$i\\   <FileRef location = \"group:${sub_proj_path}\"\/\>" ${app_workspace_file}
    fi
}

#检查版本
function check_yd_repo() {
    local yd_repo_name="ydpodrepo"

    local yd_repo_url="https://github.com/chong2vv/YDPodRepo.git"
    local repo_list=$(pod repo list | grep SPRepo)

    if [ "$repo_list" == "" ]; then
        display_normal_mas "begin setup ydPodRepo pod repo"
        pod repo add ${yd_repo_name} ${yd_repo_url}
    else
        display_normal_mas "begin update ydPodRepo pod repo"
        pod repo update ${yd_repo_name}
        display_normal_mas "update ydRepo pod repo complete"
    fi
}

function get_git_path() {
    local framework_name=$1
    local config_file=$shell_path/pod-config
    while read line
    do
        local tmp_name=${line%%=*}
        local tmp_path=${line##*=}
        if [ "$framework_name" == "$tmp_name" ]; then
            echo $tmp_path
            return
        fi
    done < $config_file
}

function get_repository_name() {
    local git_path=$1
    local rep_with_suffix=${git_path##*/}
    local rep_name=${rep_with_suffix%%.*}
    echo $rep_name
}

function ask_for_git_reset() {
    local project_name=$1
    display_normal_mas "当前操作会清空您${project_name}工程的工作区，是否继续 [y/n]"
    read answer
    answer=$(echo $answer | tr [a-z] [A-Z])
    while [[ "${answer}" != "N" ]] && [[ "${answer}" != "Y" ]]; do
        read answer
        answer=$(echo ${answer} | tr [a-z] [A-Z])
    done

    if [[ "${answer}" == "N" ]]; then
        exit 1
    fi
}

function download_source_if_need() {
    local framework_branch=$1
    local framework_name=${framework_branch%%:*}
    local branch_name=${framework_branch##*:}
    local fw_git_path=$(get_git_path ${framework_name})
    if [[ -z "${fw_git_path}" ]]; then
        display_error_msg "没有根据您输入的库名称：${framework_name}找到相应的远程GIT仓库, 请确认输入是否正确"
        exit 1
    fi
    local fw_repo_name=$(get_repository_name ${fw_git_path})
    local framework_work_path=${framework_parent_path}/${fw_repo_name}

    if [[ ! -d "${framework_work_path}" ]]; then
        cd ${framework_parent_path}
        display_normal_mas "开始克隆${framework_name}"
        git clone ${fw_git_path}
        if [[ "$?" != "0" ]]; then
            display_error_msg "克隆库：${framework_name}错误，请确认GIT的远程地址是否存在问题"
            exit 1
        fi
        display_normal_mas "${framework_name}克隆完毕"
    fi

    cd ${framework_work_path}


    if [[ "${use_mode}" == "local" ]]; then
        ask_for_git_reset ${fw_repo_name}
    fi

    git reset --hard HEAD
    git clean -fd

    local current_branch_name=$(git symbolic-ref --short -q HEAD)
    if [ "${current_branch_name}" != "${branch_name}" ]; then
        git fetch
        git checkout ${branch_name}
        if [[ "$?" != "0" ]]; then
            display_error_msg "${fw_repo_name}切换分支'${branch_name}'失败，请确认分支'${branch_name}'是否真实存在"
            exit 1
        fi
    fi

    if [ "${use_mode}" == "local" ]; then
        git pull
        if [[ "$?" != "0" ]]; then
            display_error_msg "${fw_repo_name}拉取代码失败，请确认工作区是否有未提交的内容"
            exit 1
        fi
    else
        git fetch --progress
        git reset --hard "origin/${branch_name}"
    fi
    cd ${app_work_path}
    echo "------- ${fw_repo_name} 进行 pod install 并且删除 libPods-${fw_repo_name}.a"
    pod install
    remove_lib_pod
}

use_mode="local"
if [ "$1" == "-i" ]; then
    use_mode="remote"
fi

if [ "${use_mode}" == "local" ] && [ $# -lt 1 ]; then
    display_error_msg "请输入需要配置的Framework库名称"
    exit 1
fi

if [ ! -d $framework_parent_path ]; then
  mkdir -p $framework_parent_path
fi

unset g_invalid_param_list

unset g_install_framework_list

function get_sub_list() {
    local current_fw_name=$1
    local sub_relation_file="${shell_path}/library_sub_relation"
    local sub_list_str=$(${shell_path}/gsed -En "s/^${current_fw_name}=(.+)/\1/p" ${sub_relation_file})
    local sub_list=(${sub_list_str//,/ })
    echo ${sub_list[@]}
}

function get_parent_list() {
    local current_fw_name=$1
    local parent_relation_file="${shell_path}/library_parent_relation"
    local parent_list_str=$(${shell_path}/gsed -En "s/^${current_fw_name}=(.+)/\1/p" ${parent_relation_file})
    local parent_list=(${parent_list_str//,/ })
    echo ${parent_list[@]}
}

function get_installed_list() {
    local app_workspace_file="$(find ${app_work_path} -name "*.xcworkspace" -maxdepth 1)/contents.xcworkspacedata"
    local installed_list=$(${shell_path}/ggrep -Eo "yd_framework_code\/[a-zA-Z]+\/" ${app_workspace_file} | ${shell_path}/ggrep -Eo "\/[a-zA-Z]+\/" | ${shell_path}/ggrep -Eo "[a-zA-Z]+")
    echo ${installed_list}
}

function clean_special_configuration() {
    local pbxproj_file=$1
    local fw_name=$2
    if [[ -f "${pbxproj_file}" ]]; then
        if [[ -n "${fw_name}" ]]; then
            ${shell_path}/gsed -E -i "/\.\.\/${fw_name}\/${fw_name}\/\*\*/d" ${pbxproj_file}
        fi
    fi
}

function build_framework_proj_config() {
    local framework_name=$1
    local framework_pbxproj_file="${framework_parent_path}/${framework_name}/${framework_name}.xcodeproj/project.pbxproj"

    local sub_list=$(get_sub_list ${framework_name})
    if echo "${sub_list}" | ${shell_path}/ggrep -w "None" &>/dev/null ; then
        return 1
    fi

    local fw_git_path="${framework_parent_path}/${framework_name}/.git"
    if [[ ! -d ${fw_git_path} ]]; then
        return 1
    fi
    local fw_search_config_file="${fw_git_path}/framework_search_config"
    if [[ ! -f ${fw_search_config_file} ]]; then
        /usr/bin/touch ${fw_search_config_file}
    fi

    : > ${fw_search_config_file}

    local hd_search_config_file="${fw_git_path}/header_search_config"
    if [[ ! -f ${hd_search_config_file} ]]; then
        /usr/bin/touch ${hd_search_config_file}
    fi

    : > ${hd_search_config_file}
    for sub_fw_name in ${g_install_framework_list[@]}; do
        if echo "${sub_list}" | ${shell_path}/ggrep -w "${sub_fw_name}" &>/dev/null ; then
            local dst_pod_fw_search_path_item="${framework_parent_path}/${sub_fw_name}/Product"
            local final_fw_config_item="${sub_fw_name}=>${dst_pod_fw_search_path_item}"
            echo ${final_fw_config_item} >> ${fw_search_config_file}
            local origin_pod_hd_search_path_item="Headers/Public/${sub_fw_name}/${sub_fw_name}"
            local dst_pod_hd_search_path_item="${framework_parent_path}/${sub_fw_name}/${sub_fw_name}/**"
            local final_hd_config_item="${origin_pod_hd_search_path_item}=>${dst_pod_hd_search_path_item}"
            echo ${final_hd_config_item} >> ${hd_search_config_file}
        fi
    done
}

function build_main_proj_config() {
    local main_git_path="${app_work_path}/.git"
    if [[ ! -d ${main_git_path} ]]; then
        return 1
    fi

    local fw_search_config_file="${main_git_path}/framework_search_config"
    if [[ ! -f ${fw_search_config_file} ]]; then
        /usr/bin/touch ${fw_search_config_file}
    fi
    : > ${fw_search_config_file}

    local hd_search_config_file="${main_git_path}/header_search_config"
    if [[ ! -f ${hd_search_config_file} ]]; then
        /usr/bin/touch ${hd_search_config_file}
    fi

    : > ${hd_search_config_file}

    for sub_fw_name in ${g_install_framework_list[@]}; do
        local dst_pod_fw_search_path_item="${framework_parent_path}/${sub_fw_name}/Product"
        local final_fw_config_item="${sub_fw_name}=>${dst_pod_fw_search_path_item}"
        echo ${final_fw_config_item} >> ${fw_search_config_file}
        local origin_pod_hd_search_path_item="Headers/Public/${sub_fw_name}/${sub_fw_name}"
        local dst_pod_hd_search_path_item="${framework_parent_path}/${sub_fw_name}/${sub_fw_name}/**"
        local final_hd_config_item="${origin_pod_hd_search_path_item}=>${dst_pod_hd_search_path_item}"
        echo ${final_hd_config_item} >> ${hd_search_config_file}
    done
}

function build_proj_configuration() {
    for framework_name in ${g_install_framework_list[@]}; do
        build_framework_proj_config ${framework_name}
    done

    build_main_proj_config
}

for param in "$@"; do
    if [[ "${param}" == "-i" ]]; then
        continue
    fi
    if [[ "${param}" =~ ":" ]]; then
         g_framework_name=${param%%:*}
         g_invalid_param_list+=("${param}")
         g_install_framework_list+=("${g_framework_name}")
    else
        display_error_msg "您输入的参数: ${arg}, 格式不符合规则, 请输入FrameworkName:BranchName格式的参数"
        exit 1
    fi
done

g_temp_installed_list=$(get_installed_list)

for g_fw_name in ${g_temp_installed_list}; do
    if echo "${sub_fw_list}" | ${shell_path}/ggrep -w "${g_fw_name}" &>/dev/null ; then
        continue
    else
        g_install_framework_list+=("${g_fw_name}")
    fi
done

build_proj_configuration

for fw_name_and_branch in ${g_invalid_param_list[@]}; do
    tmp_framework_name=${fw_name_and_branch%%:*}
    display_normal_mas "开始为您安装配置 ${tmp_framework_name} 库"
    download_source_if_need $fw_name_and_branch
    add_sub_proj_to_workspace ${tmp_framework_name}
    display_normal_mas "${tmp_framework_name} 库配置完成"
    echo ""
done

echo ""

g_config_file="${shell_path}/pod-config"

while read line
do
    g_tmp_fw_name=${line%%=*}
    temp_framework_pbxproj_file="${framework_parent_path}/${g_tmp_fw_name}/${g_tmp_fw_name}.xcodeproj/project.pbxproj"
    clean_special_configuration ${temp_framework_pbxproj_file} ${g_tmp_fw_name}
done < ${g_config_file}


display_normal_mas "开始进行主项目配置"

echo ""

echo ""

cd ${app_work_path}

rm "${app_work_path}/Podfile.lock"

pod install --verbose --no-repo-update

remove_lib_pod

display_normal_mas "主项目配置完成"

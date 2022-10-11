#!/bin/sh

shell_path=$(cd "$(dirname "$0")"; pwd)
PROJECT_PATH=$(cd `dirname $0`; pwd)
PROJECT_NAME="${PROJECT_PATH##*/}"
TARGET_NAME=$1
WORKSPACE_NAME=${PROJECT_NAME}.xcworkspace
CONFIGURATION=Release
framework_work_path=$(cd "$(dirname "$0")"; pwd)
framework_project_file=$(/usr/bin/find ${framework_work_path} -name "*.xcodeproj" -maxdepth 1)
cm_grep="${shell_path}/Shell/ggrep"
cm_sed="${shell_path}/Shell/gsed"

#build目录
UNIVERSAL_OUTPUT_FOLDER="${PROJECT_PATH}/Framework"
#build日志
LOG_FILE="${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}Build.log"

#创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
if [[ -d "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework" ]]; then
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"
fi
if [[ -f "${LOG_FILE}" ]]; then
rm ${LOG_FILE}
fi

function check_art_repo() {
local art_repo_name="SPRepo"
local art_repo_url="http://gitlab.meishubao.com/shenpeng/SPRepo.git"
local repo_list=$(pod repo list | grep SPRepo)

if [ "$repo_list" == "" ]; then
echo "begin setup ArtRepo pod repo ......."
pod repo add ${art_repo_name} ${art_repo_url}
else
echo "update ArtRepo pod repo ......."
pod repo update ${art_repo_name}
fi
}

#打包的时候 升级版本
function modify_profile() {
for temp_framework_name in ${require_list[@]}; do
${cm_sed} -E -i "s/pod[[:space:]]'${temp_framework_name}',[[:space:]]'[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}'/pod '${temp_framework_name}', '${framework_version}'/g" "${framework_work_path}/Podfile"
done

if [[ "$?" != "0" ]]; then
exit 1
fi
}

function remove_lib_pod() {
local pbxproj_file="${framework_project_file}/project.pbxproj"
if [[ -f "${pbxproj_file}" ]]; then
${cm_sed} -E -i "/libPods/d" ${pbxproj_file}
fi
}

function switch_build_to_origin_status() {
local pbxproj_file="${framework_project_file}/project.pbxproj"
local current_build_config="CONFIGURATION_BUILD_DIR[[:space:]]=[[:space:]]\"\\$\(PROJECT_DIR\)\/Product\";"
local origin_build_config="CONFIGURATION_BUILD_DIR = \"\\$\(BUILD_DIR\)\/\\$\(CONFIGURATION\)\\$\(EFFECTIVE_PLATFORM_NAME\)\";"
${cm_sed} -E -i "s/${current_build_config}/${origin_build_config}/g" ${pbxproj_file}
}

function switch_build_to_install_status() {
local pbxproj_file="${framework_project_file}/project.pbxproj"
local origin_build_config="CONFIGURATION_BUILD_DIR[[:space:]]=[[:space:]]\"\\$\(BUILD_DIR\)\/\\$\(CONFIGURATION\)\\$\(EFFECTIVE_PLATFORM_NAME\)\";"
local install_build_config="CONFIGURATION_BUILD_DIR = \"\\$\(PROJECT_DIR\)\/Product\";"
${cm_sed} -E -i "s/${origin_build_config}/${install_build_config}/g" ${pbxproj_file}
}

#执行pod
check_art_repo
rm -rf Podfile.lock
modify_profile
pod install --verbose --no-repo-update

remove_lib_pod

switch_build_to_origin_status

#x86_64 Release 模拟器
xcodebuild -workspace ${WORKSPACE_NAME}  -scheme ${TARGET_NAME} -sdk iphonesimulator -configuration ${CONFIGURATION} PBXBuildsContinueAfterErrors=NO ARCHS='x86_64' VALID_ARCHS='x86_64' BUILD_DIR=${UNIVERSAL_OUTPUT_FOLDER} clean build >>${LOG_FILE}
if [[ "$?" != "0" ]]; then
exit 1
fi
#armv7 arm64 Release
xcodebuild -workspace ${WORKSPACE_NAME}  -scheme ${TARGET_NAME} -sdk iphoneos -configuration ${CONFIGURATION} PBXBuildsContinueAfterErrors=NO ARCHS='armv7 arm64' VALID_ARCHS='armv7 arm64' BUILD_DIR=${UNIVERSAL_OUTPUT_FOLDER} clean build >>${LOG_FILE}
if [[ "$?" != "0" ]]; then
exit 1
fi

#将armv7 arm64 Framework拷贝到Merge目录
cp -r "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"

#合并framework，输出最终的framework到build目录
lipo -create "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}" -output "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}"

#删除之前的framework
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphonesimulator" "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos"

#sh deploy.sh ${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework

#rm -rf ${UNIVERSAL_OUTPUT_FOLDER}

switch_build_to_install_status

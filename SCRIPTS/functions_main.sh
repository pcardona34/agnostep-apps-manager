#!/bin/bash

####################################################
### AGNoStep  -  Apps Manager
### (c) 2026 Patrick Cardona
###
### Thanks for the GNUstep Developers Community
### This is Free and Open Source software.
### Read License in the root directory.
####################################################

################################
### Functions of Main script: agnostep.sh
################################

COUNT_CATEGORY=0
COUNT_APP=0
MENU=${MENU}
APPMENU=${APPMENU}

function main_menu_header
{
TARGET=$1
cat << DYNH > $MENU
function main_menu
{
dialog --backtitle "Agnostep Manager" --title "Categories" \\
 --radiolist "Choose a category" 12 60 6 \\
DYNH

}

function add_category
{
CATEGORY="$1"
if [ -n "${CATEGORY}" ];then
    if [ $COUNT_CATEGORY -gt 0 ];then
        CATEGORY_TAG="off"
    else
        CATEGORY_TAG="on"
    fi
    echo -e "\"${CATEGORY}\" \"${CATEGORY} Apps\" ${CATEGORY_TAG} \\" >>${MENU}
    let COUNT_CATEGORY++
fi
}

function main_menu_foot
{
cat << "DYNF" >>${MENU}
 2>$FICHTEMP
}
DYNF

}

function list_apps
{
CATEGORY="$1"
if [ -n "$1" ];then
    pushd . >/dev/null
    cd MODULES/${CATEGORY} || exit 1
    for APP in $(ls)
    do
        echo ${APP}
        get_app_info ${APP}
    done
    popd  >/dev/null
fi
}

function get_app_info
{
APP="$1"
    if [ -n "$APP" ] && [ -f ${APP}/APPINFO.ini ];then
        . ${APP}/APPINFO.ini
        echo -e "${APPNAME}: ${SHORT}\n"
        add_app_menu_item "${APPNAME}" "${SHORT}"
    fi
}

function app_menu_header
{
CATEGORY="$1"
cat << DYNH >${APPMENU}
function main_app_menu
{
dialog --backtitle "${CATEGORY}" --title "Applications" \\
 --radiolist "Choose an application" 12 60 10 \\
DYNH

}

function add_app_menu_item
{
APPNAME="$1"
SHORT="$2"

if [ $COUNT_APP -gt 0 ];then
    APP_TAG="off"
else
    APP_TAG="on"
fi

echo -e "\"${APPNAME}\" \"${SHORT}\" ${APP_TAG} \\" >>${APPMENU}
let COUNT_APP++
}

function app_menu_foot
{

cat << "DYNF" >>${APPMENU}
 2>$FICHTEMP
}
DYNF

}

function show_long_info_for_app
{
APPNAME="$1"
pwd
}

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

function main_menu_header
{

cat << DYNH > dynamic_menu.sh
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
        echo -e "\"${CATEGORY}\" \"${CATEGORY} Apps\" off \\" >> ../dynamic_menu.sh
fi
}

function main_menu_foot
{
cat << "DYNF" >> dynamic_menu.sh
"Other" "Other apps" on 2>$FICHTEMP
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
cat << DYNH > dynamic_app_menu.sh
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
echo -e "\"${APPNAME}\" \"${SHORT}\" off \\" >> ../../dynamic_app_menu.sh
}

function app_menu_foot
{
cat << "DYNF" >> dynamic_app_menu.sh
"Other" "An Other app" on 2>$FICHTEMP
}
DYNF

}

function show_long_info_for_app
{
APPNAME="$1"
pwd
}

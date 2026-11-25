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
### Main script: agnostep.sh
################################

### VARS
################################
FICHTEMP=$(mktemp /tmp/agno-XXXXX)
trap "rm -f $FICHTEMP" EXIT
MENU=$(mktemp /tmp/agno-XXXXX)
trap "rm -f $MENU" EXIT
APPMENU=$(mktemp /tmp/agno-XXXXX)
trap "rm -f $APPMENU" EXIT
. AGNOSTEP.conf

if [ "$DEBUG" == "YES" ];then
    STOP=1
else
    STOP=0
fi

### Include functions
################################

. SCRIPTS/log.sh
. SCRIPTS/colors.sh
. SCRIPTS/stop.sh
. SCRIPTS/spinner.sh
. MODULES.ini
. SCRIPTS/fetcher.sh
. SCRIPTS/functions_prep.sh
. SCRIPTS/functions_remove_app.sh
. SCRIPTS/std_build.sh
. SCRIPTS/check_app.sh
. SCRIPTS/patch_with_quilt.sh
. SCRIPTS/functions_main.sh

################################
### Splash screen
. SCRIPTS/splash.sh

STR="Agnostep Manager is starting..."
titulo

### Logging
################################
reset_log
stop
################################
### Check env and system
sanity_check || exit 1
stop

################################
### Building dynamic menu
main_menu_header

### Updating modules
STR="Updating Modules"
subtitulo

git submodule update --remote
ok "Done"
sleep 2
stop

### Listing enabled modules
pushd . >/dev/null
cd MODULES
for MOD in $(ls -1 .)
do
    STATUS=$(cat ../MODULES.ini | grep "${MOD}" | awk -F= '{print $2}')
    if [ "$STATUS" == "YES" ];then
        enabled "${MOD}"
        add_category "${MOD}"
    else
        echo -e "Module ${MOD} is disabled.\n"
    fi
done
sleep 2
popd >/dev/null
main_menu_foot

stop

. $MENU || exit 1
main_menu

if [ $? -eq 0 ];then
    REP=$(cat $FICHTEMP)
    echo "You chose $REP"
    app_menu_header "$REP"
    list_apps "$REP"
    app_menu_foot
    . $APPMENU || exit 1
    main_app_menu
    if [ $? -eq 0 ];then
        APP=$(cat $FICHTEMP)
        echo "You chose $APP"
        pushd . >/dev/null
        cd MODULES/${REP}/${APP} ||exit 1
        . APPINFO.ini
        dialog --sleep 5 --backtitle "${APPNAME}" --title "About" --infobox \
           "${LONG}" 12 60
        dialog --backtitle "${APPNAME}" --title "Installation" \
            --yesno "Do you confirm the installation of ${APPNAME}?" 12 60
        if [ $? -eq 0 ];then
            if [ "${APPNAME}" == "Template" ];then
                alert "This is not a true App. Abandon."
                exit 1
            fi
            echo "Installation will start soon..."
            pushd . >/dev/null
            if [ ! -d build ];then
                mkdir build && cd build
            else
                cd build || exit 1
            fi
            printf "Fetching...\n"
            case "$FETCHER" in
                "git") clone;;
                "svn") getSubversion;;
                "fetch") fetch "$URL";;
            esac
            ok "Done"
            popd >/dev/null

            if [ -f install.sh ];then
                . ./install.sh
            else
                alert "No builtin install Script."
            fi
            popd >/dev/null

        else
            info "Installation aborted by User."
        fi
    fi
fi

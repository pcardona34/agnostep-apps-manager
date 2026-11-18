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

### Include functions
################################

. SCRIPTS/log.sh
. SCRIPTS/colors.sh
. MODULES.ini
. SCRIPTS/fetcher.sh
. SCRIPTS/functions_prep.sh
. SCRIPTS/functions_remove_app.sh
. SCRIPTS/functions_main.sh

################################
### Splash screen
. SCRIPTS/splash.sh

STR="Agnostep Manager is starting..."
titulo

### Logging
################################
reset_log

################################
### Check env and system
sanity_check


################################
### Building dynamic menu
main_menu_header

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
                "svn") echo "To be implemented";;
                "fetch") fetch "$URL";;
            esac
            ok "Done"
            printf "Cleanup...\n"
            pushd . >/dev/null
            remove_ifx_app "${APPNAME}"
            popd >/dev/null

            if [ -f install.sh ];then
                . ./install.sh
            else
                alert "No builtin install Script."
            fi
            popd >/dev/null

        else
            warning "Installation aborted."
        fi
        popd >/dev/null
    fi
fi

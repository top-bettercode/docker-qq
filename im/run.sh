#!/bin/sh

#   Copyright (C) 2016 Deepin, Inc.
#
#   Author:     Li LongYu <lilongyu@linuxdeepin.com>
#               Peng Hao <penghao@linuxdeepin.com>

WINEPREFIX="$HOME/.deepinwine/Deepin-QQ"
APPDIR="/opt/deepinwine/apps/Deepin-QQ"
APPVER="8.9.19983deepin18"
APPTAR="files.7z"
PACKAGENAME="deepin.com.qq.im"

HelpApp()
{
        echo " Extra Commands:"
        echo " -r/--reset     Reset app to fix errors"
        echo " -e/--remove    Remove deployed app files"
        echo " -h/--help      Show program help info"
}
CallApp()
{
        BASE_DIR="$HOME/.deepinwine/Deepin-QQ"
        WINE_CMD="deepin-wine"

        _SetRegistryValue()
        {
            env WINEPREFIX="$BASE_DIR" $WINE_CMD reg ADD "$1" /v "$2" /t $3 /d "$4"
        }

        _SetOverride()
        {
            _SetRegistryValue 'HKCU\Software\Wine\DllOverrides' "$2" REG_SZ "$1"
        }

        if [ -f $BASE_DIR/drive_c/deepin/first ]; then
            /opt/deepinwine/tools/add_hotkeys
            rm $BASE_DIR/drive_c/deepin/first
        fi

        env WINEPREFIX="$BASE_DIR" $WINE_CMD "c:\\Program Files\\Tencent\\QQ\\Bin\\QQ.exe"

        _exist(){
                if test $( pgrep -f $1 | wc -l ) -eq 0
                then
                        echo "退出"
                else
                        sleep 60
                        _exist $1
                fi 
        }

        _exist "QQ.exe"
}
ExtractApp()
{
        mkdir -p "$1"
        7z x "$APPDIR/$APPTAR" -o"$1"
        mv "$1/drive_c/users/@current_user@" "$1/drive_c/users/$USER"
        sed -i "s#@current_user@#$USER#" $1/*.reg
}
DeployApp()
{
        ExtractApp "$WINEPREFIX"
        echo "$APPVER" > "$WINEPREFIX/PACKAGE_VERSION"
}
RemoveApp()
{
        rm -rf "$WINEPREFIX"
}
ResetApp()
{
        echo "Reset $PACKAGENAME....."
        read -p "*      Are you sure?(Y/N)" ANSWER
        if [ "$ANSWER" = "Y" -o "$ANSWER" = "y" -o -z "$ANSWER" ]; then
                EvacuateApp
                DeployApp
                CallApp
        fi
}
UpdateApp()
{
        if [ -f "$WINEPREFIX/PACKAGE_VERSION" ] && [ "$(cat "$WINEPREFIX/PACKAGE_VERSION")" = "$APPVER" ]; then
                return
        fi
        if [ -d "${WINEPREFIX}.tmpdir" ]; then
                rm -rf "${WINEPREFIX}.tmpdir"
        fi
        ExtractApp "${WINEPREFIX}.tmpdir"
        /opt/deepinwine/tools/updater -s "${WINEPREFIX}.tmpdir" -c "${WINEPREFIX}" -v
        rm -rf "${WINEPREFIX}.tmpdir"
        echo "$APPVER" > "$WINEPREFIX/PACKAGE_VERSION"
}
RunApp()
{
        if [ -d "$WINEPREFIX" ]; then
                UpdateApp
        else
                DeployApp
        fi
        CallApp
}

if [ -z $1 ]; then
        RunApp
        exit 0
fi
case $1 in
        "-r" | "--reset")
                ResetApp
                ;;
        "-e" | "--remove")
                RemoveApp
                ;;
        "-h" | "--help")
                HelpApp
                ;;
        *)
                echo "Invalid option: $1"
                echo "Use -h|--help to get help"
                exit 1
                ;;
esac
exit 0
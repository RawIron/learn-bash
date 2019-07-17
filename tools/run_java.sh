#!/bin/bash
#
# app_home
# |-- bin
#     |-- run_bench.sh
#     `-- run_java.sh
# |-- config
# `-- lib


JAVA_HOME=""
JAVA_CMD=""

function set_java_home() {
    if [[ -z "$JAVA_HOME" ]] ; then
      if [[ -r /etc/gentoo-release ]] ; then
        JAVA_HOME=$(java-config --jre-home)
      fi
    fi

    if [[ -z "$JAVA_HOME" ]] ; then
      echo "JAVA_HOME is not set."
    fi
}

function set_java_cmd() {
    if [[ -z "$JAVA_CMD" ]] ; then
      if [[ -n "$JAVA_HOME"  ]] ; then
        JAVA_CMD="$JAVA_HOME/bin/java"
      else
        JAVA_CMD="$(which java)"
      fi
    fi

    if [[ ! -x "$JAVA_CMD" ]] ; then
      echo "JAVA_HOME might be incorrect."
      echo "Cannot execute $JAVA_CMD"
      exit 1
    fi
}

if (( $# == 0 )); then 
    echo "Specify the fully qualified Main Class with command-line parameters"
    exit 127
fi


APP_HOME="$(dirname "$0")/.."

if [[ ! -d "$APP_HOME/lib" ]] ; then
    echo "The lib directory is missing."
    exit 127
fi

if [[ ! -d "$APP_HOME/config" ]] ; then
   mkdir "$APP_HOME/config"
fi

set_java_home
set_java_cmd

"$JAVA_CMD" -cp $APP_HOME/config:$APP_HOME/lib/* "$@"

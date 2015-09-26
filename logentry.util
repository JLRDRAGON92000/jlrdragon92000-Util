#!/bin/bash

# logentry : Create an entry in util-logins.log. Usually run from prompt.sh at login.
echo "${USER}|${HOSTNAME}|$(date '+%Y|%m|%d|%H|%M')|${SSH_CLIENT:-nil}|$(tty)" >>"$UTIL_LOGPATH";


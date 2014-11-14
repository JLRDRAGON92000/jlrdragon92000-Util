#!/bin/bash

# View a Util script in chosen viewer
VUTIL_VIEWER="vim";

# Lock write permission temporarily
chmod -w "$UTIL_DIR/$1.sh";
# Invoke viewing application on target
"$VUTIL_VIEWER" "$UTIL_DIR/$1.sh";
# Unlock file write permission
chmod u+w "$UTIL_DIR/$1.sh";


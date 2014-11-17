#!/bin/bash

# View a Util script in chosen viewer
VUTIL_VIEWER="view";

# Lock write permission temporarily (no longer needed)
# chmod -w "$UTIL_DIR/$1.sh";
# Invoke viewing application on target
"$VUTIL_VIEWER" "$UTIL_DIR/$1.sh";
# Unlock file write permission (no longer needed)
# chmod u+w "$UTIL_DIR/$1.sh";


#!/bin/bash

# Copy Util/template.html to the current directory, and optionally copy the stylesheet (template.css) to a specified directory relative to the current one

# Constants for the locations
TEMPLATE_FPATH="$UTIL_DIR/template.html";
TEMPLATE_CSS_FPATH="$UTIL_DIR/template.css";

# Copy the HTML
cp "$TEMPLATE_FPATH" "./$1";

# If the user specifies, copy the stylesheet
if [ -n "$2" ];
then
	cp "$TEMPLATE_CSS_FPATH" "./$2";
fi

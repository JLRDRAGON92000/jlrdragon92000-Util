#!/bin/bash

# Copy Util/template.html to the current directory, and optionally copy the stylesheet (template.css) to a specified directory relative to the current one

# Constants for the locations
TEMPLATE_FPATH="$UTIL_DIR/template.html";
TEMPLATE_CSS_FPATH="$UTIL_DIR/template.css";

# Get ultimate destination paths
TEMPLATE_DPATH="./$1";
if [ -n "$2" ];
then
	TEMPLATE_CSS_DPATH="./$2";
else
	TEMPLATE_CSS_DPATH="./template.css";
fi
# Clean up the paths for insertion into the files
TEMPLATE_DPATHC=${TEMPLATE_DPATH/\.\//};
TEMPLATE_CSS_DPATHC=${TEMPLATE_CSS_DPATH/\.\//};

# Copy the HTML to a temporary file
cp "$TEMPLATE_FPATH" "./TEMPLATE.html.tmp";
# Substitute variables
sed -e "s/\#TEMPLATE_STYLES\#/${TEMPLATE_CSS_DPATHC//\//\\/}/" -e "s/\#C_DATE\#/$(date '+%A, %d %B %Y, at %H:%M')/" "./TEMPLATE.html.tmp" >./TEMPLATE.html.new;

# Copy the stylesheet to a temp file
cp "$TEMPLATE_CSS_FPATH" "./TEMPLATE.css.tmp";
# Substitute variables
sed -e "s/\#TEMPLATE_HTML\#/${TEMPLATE_DPATHC//\//\\/}/" -e "s/\#C_DATE\#/$(date '+%A, %d %B %Y, at %H:%M')/" "./TEMPLATE.css.tmp" >./TEMPLATE.css.new;

# Copy the HTML and stylesheet
cp "./TEMPLATE.html.new" "$TEMPLATE_DPATH";
cp "./TEMPLATE.css.new" "$TEMPLATE_CSS_DPATH";

# Clean up
rm "./TEMPLATE.html.tmp";
rm "./TEMPLATE.html.new";
rm "./TEMPLATE.css.tmp";
rm "./TEMPLATE.css.new";


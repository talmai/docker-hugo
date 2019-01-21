#!/bin/sh

BUILD_ONLY="${HUGO_BUILD_ONLY:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
HUGO_DESTINATION="${HUGO_DESTINATION:=/output}"
echo "HUGO_BUILD_ONLY:" $BUILD_ONLY
echo "HUGO_REFRESH_TIME:" $HUGO_REFRESH_TIME
echo "HUGO_THEME:" $HUGO_THEME
echo "HUGO_BASEURL" $HUGO_BASEURL
echo "ARGS" $@

HUGO=/usr/local/sbin/hugo
#echo "Hugo path: $HUGO"

while [ true ]
do
    if [[ $BUILD_ONLY == 'false' ]]; then
	    echo "Serving..."
        $HUGO server --disableFastRender --watch=true --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --debug --baseURL="$HUGO_BASEURL" --bind="0.0.0.0" "$@" || exit 1
    else
	    echo "Building one time..."
        $HUGO --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --baseURL="$HUGO_BASEURL" "$@" || exit 1
    fi

    if [[ $HUGO_REFRESH_TIME == -1 ]]; then
        exit 0
    fi
    echo "Sleeping for $HUGO_REFRESH_TIME seconds..."
    sleep $SLEEP
done

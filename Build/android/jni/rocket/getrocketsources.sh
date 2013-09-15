#!/usr/bin/env bash

if [ $# != 3 ]; then
    echo "Error: getrocketsources.sh Requires three arguments: 
The variable to extract from FileList.cmake, 
the path to FileList.cmake, 
and what to set for PROJECT_SOURCE_DIR"
fi

# $1 = something like Debugger_SRC_FILES
# $2 = something like ../cmake/FileList.cmake
# $3 = the output from the ndk's (call my-dir)/..[navigate to project source directory]

cat "$2" | awk '
BEGIN { \
    is_printing=0 
}
{
    if(is_printing == 0)
    {
        if($1 ~ /^set\('"$1"'/)
        {
            is_printing=1
        }
    }
    else
    {
        if($1 ~ /\)/)
        {
            is_printing=0
        }
        else
        {
            if(gsub(/\$\{PROJECT_SOURCE_DIR\}\//,"'"$3"'"))  
                print $0;
        }
    }
}
END { }
'

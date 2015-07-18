##!/bin/awk -f


function stripsplash(name) {
    if(substr(name, length(name), 1) == "/")
        return substr(name, 0, length(name)-1)
}

function mydiff(sourcedir, destdir, ignore, debug) {
    sourcedir = stripsplash(sourcedir)
    command = ""
    commandfront = "diff --no-ignore-file-name-case --speed-large-files -q "
    commanddiff = ""
    commandend = "awk -F' ' '/^Only in/{if($3 == ""\""sourcedir":\""") printf(\"%s/%s\\n\", substr($3, 0, length($3)-1), $4)}'"
    commandexec = ""
    if(ignore)
        commanddiff = "-X "ignore
    else
        commanddiff = ""
    command = commandfront" "commanddiff" "sourcedir" "destdir" | "commandend
    if(debug != "true") {
        commandexec = "xargs -i cp -pr {} "destdir
        command = command" | "commandexec
    }
    #print command
    system(command)
}

BEGIN{
    FS="[:\t=]"
    OFS="\n"
    sourcedir=s
    destdir=d
    ignore=x
    debug=debug
    mydiff(sourcedir, destdir, ignore, debug)
}

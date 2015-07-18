#!/bin/awk -f


function strip_start_splash(name) {
    if(substr(name, 1, 1) == "/")
        return substr(name, 2, length(name))
    else
        return name
}

function strip_end_splash(name) {
    if(substr(name, length(name), 1) == "/")
        return substr(name, 1, length(name)-1)
    else
        return name
}

#function strip_end_field(fs, string) {
#   strip_command = "awk 'BEGIN{FS=\"["fs"]\";}END{t=length($0)-length($NF); print substr($0, 0, t-1)}'"
#   "echo -n "string" | "strip_command | getline new_string
#   return new_string
#}

function refactor_destdir(name, src, dst) {
    match(name, src)
    subname = substr(name, RSTART+RLENGTH, length(name))
    subname = strip_start_splash(subname)
    return dst"/"subname
}

function mydiff(sourcedir, destdir, ignore, debug) {
    sourcedir = strip_end_splash(sourcedir)
    destdir = strip_end_splash(destdir)
    command = ""
    commandfront = "diff --no-ignore-file-name-case --speed-large-files -q -r "
    commanddiff = ""
    commandend = "awk -F' ' '/^Only in/{if($3 ~ ""\"""^"sourcedir"\""") printf(\"%s/%s\\n\", substr($3, 0, length($3)-1), $4)}'"
    commandexec = ""
    if(ignore)
        commanddiff = "-X "ignore
    else
        commanddiff = ""
    command = commandfront" "commanddiff" "sourcedir" "destdir" | "commandend
    command = command" | awk 'BEGIN{strip_end_splash="strip_end_splash"}'"
    print command
    #system(command)
    #print origindiff
    #system(command)
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

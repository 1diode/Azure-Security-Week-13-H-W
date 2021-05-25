#!/bin/bash
#( Sort by memory | show these columns of info | only the top 11 lines of it)
ps aux --sort -%mem | awk {'print $1, $2, $3, $11'} | head -n 11

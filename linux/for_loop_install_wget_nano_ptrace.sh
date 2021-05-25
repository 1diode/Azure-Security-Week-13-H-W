#!/bin/bash
packages=( 'nano' 'wget' 'ptrace' )
#
# Ensure all packages are installed
  for package in ${packages[@]}
  do
    if [ ! $(which $package) ]
    then
      apt install -y $package        
# -y means no answers to prompts req'd
    fi
  done

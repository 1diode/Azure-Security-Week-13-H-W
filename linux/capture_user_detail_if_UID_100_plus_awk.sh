#!/bin/bash
cat /etc/passwd | awk -f ":" '{if ($3 >=100) print $0}' > ~/research/users.txt

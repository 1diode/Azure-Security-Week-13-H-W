#!/bin/bash
free -mh > ~/backups/freemem/free_mem.txt
sudo du -h / > ~/backups/diskuse/disk_usage.txt 2>&1
sudo lsof > ~/backups/openlist/open_list.txt
df -h > ~/backups/freedisk/free_disk.txt

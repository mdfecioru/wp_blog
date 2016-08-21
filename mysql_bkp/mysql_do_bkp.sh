#!/bin/bash

mysqldump --add-drop-table -u root -p${MYSQL_ROOT_PASSWORD} wordpress > /mysql_bkp/blog`date +%d%b%Y`.bak.sql


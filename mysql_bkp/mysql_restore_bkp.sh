#!/bin/bash

mysql -u root -p${MYSQL_ROOT_PASSWORD} wordpress < /mysql_bkp/blog1.bak.sql


#!/bin/bash

. env.sh

## Variables
db=""
tbl=""
input=${TMP_DIR}

VERSION=0.1

##Usage
usage()
{
        echo "\n************************ Usage ********************************** \n";
        echo "bash import.sh -d dbname -t tablename -i inputdir"
        echo "OPTIONS:"
	echo "-d database to import"
	echo "-t table to import"
	echo "-i input dir"
	echo "-h help"
        exit 0;
}

while getopts "d:t:hi:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             d)
                db=$OPTARG 
                ;;
             t)
                tbl=$OPTARG 
                ;;
             i)
                input=$OPTARG 
                ;;
             h)
		usage
                ;;
             ?) 
            echo "unkonw argument"
        exit 1
        ;;
        esac
done

import()
{
	if [ "${tbl}"=="" ]; then
		FILES=`ls ${input}/${db}-* | sort -V`
	else
		FILES="${input}/${db}-${tbl}-*"
	fi
	# groupby FILES by db and table
	echo "set @autocommit=1;" | mysql -u$DST_USER -h$DST_HOST --port $DST_PORT $db |grep -v '^Tables_in_'
	for f in $FILES
	do
		mysql -u$DST_USER -h$DST_HOST -P$DST_PORT $db < $f 
	done
	#Get total record count
	echo "Done!"
}

import
exit 0;

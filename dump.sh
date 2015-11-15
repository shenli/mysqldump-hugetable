#!/bin/bash

source env.sh

## Variables
db=""
tbl=""
output="out"

VERSION=0.1

##Usage
usage()
{
        echo "\n************************ Usage ********************************** \n";
        echo "sh dump.sh -d dbname tablename -o outputdir"
        echo "OPTIONS:"
	echo "-d database to dump"
	echo "-t table to dump"
	echo "-o output dir"
	echo "-h help"
        exit 0;
}

while getopts "d:t:ho:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             d)
                db=$OPTARG 
                ;;
             t)
                tbl=$OPTARG 
                ;;
             o)
                output=$OPTARG 
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

dump()
{
	#get total record count
	row_cnt=$(mysql -u$USER -h$HOST -P$PORT --raw --batch -e "select count(*) from ${db}.${tbl}" -s)
	echo $row_cnt
	i=0
	cnt=0
	first_dump=0
	file_prefix="${output}/${db}-${tbl}"
	## while $cnt<$row_cnt {
	## 	where="1 ${cnt}, ${cnt}+${MAX_RECORDS}"
	##      file="${file_prefix}.${cnt}"
	##	mysqldump --where "${where}"  > file
	##} 
}

dump
exit 0;

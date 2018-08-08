#!/bin/bash

. env.sh

## Variables
db=""
tbl=""
output=${TMP_DIR}

mkdir $output

VERSION=0.1

##Usage
usage()
{
        echo "\n************************ Usage ********************************** \n";
        echo "bash dump.sh -d dbname -t tablename -o outputdir"
        echo "OPTIONS:"
	echo "-d database to dump"
	echo "-t table to dump"
	echo "-o output dir"
	echo "-h help"
        exit 0;
}

while getopts "d:t:ho:" arg
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

dump_table()
{
	#Get total record count
	row_cnt=$(mysql -u$SRC_USER -h$SRC_HOST -P$SRC_PORT -p$SRC_PWD --raw --batch -e "select count(*) from ${db}.${tbl}" -s)
	echo "Total $row_cnt rows in ${db}.${tbl}"
	i=0
	cnt=0
	first_dump=0
	file_prefix="${output}/${db}-${tbl}"
	while [ $cnt -le $row_cnt ]
	do
		next_step=`expr ${cnt} + ${MAX_RECORDS}`
		echo "Dumping from $cnt to $next_step"
		where="1 limit ${cnt}, ${MAX_RECORDS}"
		file="${file_prefix}-${i}"
		i=`expr $i + 1`
		if [ $cnt == 0 ]; then
			mysqldump -u$SRC_USER -h$SRC_HOST --port $SRC_PORT -p$SRC_PWD --skip-disable-keys --add-drop-table --add-locks --create-options --extended-insert --lock-tables --set-charset --where "$where" $db $tbl > $file
		else
			mysqldump -u$SRC_USER -h$SRC_HOST --port $SRC_PORT -p$SRC_PWD --skip-disable-keys --skip-add-drop-table --no-create-db --no-create-info --where "$where" $db $tbl > $file
		fi
		cnt=$next_step
	done
	echo "Done!"
}

dump_db()
{
	tbls=`echo "show tables;" | mysql -u$SRC_USER -h$SRC_HOST --port $SRC_PORT -p$SRC_PWD $db |grep -v '^Tables_in_'`
	for t in $tbls
	do
		echo "Dumping table ${t}.........."
		tbl="$t"
		dump_table
		echo "Dump table ${t} succ"
	done
	echo "Dump database $db succ!"
}

dump()
{
	if [ "${tbl}"="" ]; then
		dump_db
	else
		dump_table
	fi
}

dump
exit 0;

# Tool for dump/import huge table from/to mysql 

## Introduction
Count the record number in table and use mysqldump --where option to split data into multiple dump file. 

## Usage
Config:
Set both source and destination mysql connnection in env.sh
Set max record count in env.sh
Set tmp directory to store mysqldump file

Dump data: 
Dump whole database: ./dump.sh -d db
Dump single table: ./dump.sh -d db -t tbl

Import data:
Import whole database: ./import.sh -d db
Import single table: ./import.sh -d db -t tbl


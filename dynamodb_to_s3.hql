--Copies data from DynamoDB to S3 without column Mappings LD2819

DELETE JAR /usr/lib/hive/lib/hive-contrib.jar;
DELETE JAR /mnt/taskRunner/emr-hadoop-goodies.jar;
DELETE JAR /mnt/taskRunner/emr-hive-goodies.jar;
DELETE JAR /mnt/taskRunner/open-csv.jar;
DELETE JAR /mnt/taskRunner/oncluster-emr-hadoop-goodies.jar;
DELETE JAR /mnt/taskRunner/oncluster-emr-hive-goodies.jar;
DELETE JAR /mnt/taskRunner/pipeline-serde.jar;

SET hive.execution.engine=tez;
SET dynamodb.throughput.read.percent=1;

DROP TABLE IF EXISTS ddb_query_history;

CREATE EXTERNAL TABLE ddb_query_history (item MAP<STRING, STRING>)
STORED BY 'org.apache.hadoop.hive.dynamodb.DynamoDBStorageHandler'
TBLPROPERTIES('dynamodb.table.name' = '#{input.tableName}');

DROP TABLE IF EXISTS s3_query_history;

CREATE EXTERNAL TABLE IF NOT EXISTS s3_query_history (item MAP<STRING, STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION '#{output.directoryPath}';

INSERT OVERWRITE TABLE s3_query_history SELECT * FROM ddb_query_history;

--Creating external stage (create your own bucket)
CREATE OR REPLACE STAGE SCD_DEMO.SCD2.customer_ext_stage
    url='s3://pd-nifi-snowflake-realtime-streaming-pipeline/stream_data'
    credentials=(aws_key_id='your_aws_access_key' aws_secret_key='your_aws_secret_key');
   


-- Defining file format for csv files
CREATE OR REPLACE FILE FORMAT SCD_DEMO.SCD2.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;



SHOW STAGES;
LIST @customer_ext_stage;



--Creating a pipe to load data from Amazon S3 to snowflake table - customer_raw

CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @customer_ext_stage
  FILE_FORMAT = CSV
  ;

show pipes;
select SYSTEM$PIPE_STATUS('customer_s3_pipe');
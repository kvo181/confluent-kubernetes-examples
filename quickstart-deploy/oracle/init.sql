create TYPE SDMS_INTEGRATION_TYPE IS OBJECT
(
    SUBJECT      VARCHAR2(100),
    TYPE_NAME    VARCHAR2(100),
    TYPE_VERSION VARCHAR2(10),
    JSON_MESSAGE CLOB
);

SELECT * FROM USER_OBJECTS 
WHERE OBJECT_TYPE='PACKAGE';

/* Creating a object type queue table and queue: */
CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SIS2SDMS_REPAR_NAMES',
        'SYS.SDMS_INTEGRATION_TYPE');

CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.REPAR_NAME_QUEUE',
        'SYS.SIS2SDMS_REPAR_NAMES');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.REPAR_NAME_QUEUE');

/* We need to create a queue supported by JMS */
CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SIS2SDMS_REPAR_NAMES_JMS', 
        'SYS.AQ$_JMS_TEXT_MESSAGE');

CALL DBMS_AQADM.STOP_QUEUE(
        'SYS.REPAR_NAME_QUEUE_JMS');
CALL DBMS_AQADM.DROP_QUEUE(QUEUE_NAME  => 'SYS.REPAR_NAME_QUEUE_JMS');

CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.REPAR_NAME_QUEUE_JMS',
        'SYS.SIS2SDMS_REPAR_NAMES_JMS');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.REPAR_NAME_QUEUE_JMS');

SELECT qtb.USER_DATA.text_lob from SYS.SIS2SDMS_REPAR_NAMES_JMS qtb;

CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SINK_QT_JMS', 
        'SYS.AQ$_JMS_TEXT_MESSAGE');
CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.SINK_JMS',
        'SYS.SINK_QT_JMS');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.SINK_JMS');

-- Check existence
SELECT coalesce(dbms_lob.substr(qtb.USER_DATA.text_lob,4000,1), qtb.USER_DATA.text_vc) as text_value  from SYS.SINK_QT_JMS qtb;
SELECT qtb.USER_DATA.text_lob from SYS.SIS2SDMS_REPAR_NAMES_JMS qtb;

/*
select username as schema_name
from sys.dba_users
order by username;

select owner, tablespace_name, table_name 
from all_tables
where owner = 'SYS';

select tablespace_name, table_name from user_tables; 

select distinct owner
from all_tables;
*/

/*
SELECT *
FROM SYS.SIS2SDMS_REPAR_NAMES_JMS;
*/

-- get a list of sessions assigned to the jms adapter
select Sid, Serial#, machine, program
from V$SESSION
where machine like '%jms%'
-- let us kill the sessions to see how the adapter behaves
ALTER SYSTEM KILL SESSION '49,225' IMMEDIATE;


CALL DBMS_AQADM.STOP_QUEUE('SYS.SAMPLE_AQ');
CALL DBMS_AQADM.DROP_QUEUE(QUEUE_NAME  => 'SYS.SAMPLE_AQ');
CALL DBMS_AQADM.DROP_QUEUE_TABLE('SYS.SAMPLE_AQTBL');

CALL DBMS_AQADM.STOP_QUEUE('SYS.SOURCE_JMS');
CALL DBMS_AQADM.DROP_QUEUE(QUEUE_NAME  => 'SYS.SOURCE_JMS');
CALL DBMS_AQADM.DROP_QUEUE_TABLE('SYS.SOURCE_QT_JMS');

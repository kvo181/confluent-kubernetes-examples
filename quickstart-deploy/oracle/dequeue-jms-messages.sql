SELECT * FROM DBA_QUEUE_TABLES;
SELECT * FROM AQ$SIS2SDMS_REPAR_NAMES_JMS;
SELECT * FROM V$AQ;

SELECT count(*) from AQ$SIS2SDMS_REPAR_NAMES_JMS;
SELECT count(*) from AQ$SINK_QT_JMS;

SELECT qtb.queue
, qtb.msg_id
, qtb.msg_state
,qtb.enq_timestamp
--,qtb.user_data.header.replyto
,qtb.user_data.header.type type
,qtb.user_data.header.userid userid
,qtb.user_data.header.appid appid
,qtb.user_data.header.groupid groupid
,qtb.user_data.header.groupseq groupseq
--, qtb.user_data.header.properties properties
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_compositeInstanceId') tracking_compositeInstanceId
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'JMS_OracleDeliveryMode') JMS_OracleDeliveryMode
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_ecid') tracking_ecid
, (select num_value from table (qtb.user_data.header.properties) prp where prp.name = 'JMS_OracleTimestamp') JMS_OracleTimestamp
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_parentComponentInstanceId') tracking_prtCptInstanceId
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_conversationId') tracking_conversationId
--,qtb.user_data.header
,qtb.user_data.text_lob text 
from AQ$SIS2SDMS_REPAR_NAMES_JMS qtb;

SELECT qtb.USER_DATA.text_lob from SYS.SIS2SDMS_REPAR_NAMES_JMS qtb;

CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SINK_QT_JMS', 
        'SYS.AQ$_JMS_TEXT_MESSAGE');
CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.SINK_JMS',
        'SYS.SINK_QT_JMS');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.SINK_JMS');

SELECT qtb.queue
, qtb.msg_id
, qtb.msg_state
,qtb.enq_timestamp
--,qtb.user_data.header.replyto
,qtb.user_data.header.type type
,qtb.user_data.header.userid userid
,qtb.user_data.header.appid appid
,qtb.user_data.header.groupid groupid
,qtb.user_data.header.groupseq groupseq
--, qtb.user_data.header.properties properties
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_compositeInstanceId') tracking_compositeInstanceId
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'JMS_OracleDeliveryMode') JMS_OracleDeliveryMode
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_ecid') tracking_ecid
, (select num_value from table (qtb.user_data.header.properties) prp where prp.name = 'JMS_OracleTimestamp') JMS_OracleTimestamp
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_parentComponentInstanceId') tracking_prtCptInstanceId
, (select str_value from table (qtb.user_data.header.properties) prp where prp.name = 'tracking_conversationId') tracking_conversationId
--,qtb.user_data.header
,qtb.user_data.text_lob struc 
,qtb.user_data.text_vc text 
from AQ$SINK_QT_JMS qtb;

SELECT qtb.USER_DATA.header.type as type_value, qtb.USER_DATA.text_vc as text_value  from SYS.SINK_QT_JMS qtb;


SET SERVEROUTPUT ON
DECLARE
dequeue_options     DBMS_AQ.dequeue_options_t;
message_properties  DBMS_AQ.message_properties_t;
message_handle      RAW(16);
message             SYS.AQ$_JMS_TEXT_MESSAGE;
BEGIN
   dequeue_options.navigation := DBMS_AQ.FIRST_MESSAGE;
   DBMS_AQ.DEQUEUE(
--      queue_name          =>     'SYS.REPAR_NAME_QUEUE_JMS',
      queue_name          =>     'SYS.SINK_JMS',
      dequeue_options     =>     dequeue_options,
      message_properties  =>     message_properties,
      payload             =>     message,
      msgid               =>     message_handle);
    DBMS_OUTPUT.PUT_LINE('Handle: '||message_handle);
    DBMS_OUTPUT.PUT_LINE('Text: '||message.text_vc);
    DBMS_OUTPUT.PUT_LINE('Lob: '||message.text_lob);
--    DBMS_OUTPUT.PUT_LINE('From Sender No.'|| message.sender_id);
--    DBMS_OUTPUT.PUT_LINE('Subject: '||message.subject);
--    DBMS_OUTPUT.PUT_LINE('Text: '||message.text);
   COMMIT;
END;



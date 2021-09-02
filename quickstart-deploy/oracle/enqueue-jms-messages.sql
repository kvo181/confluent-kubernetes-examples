DECLARE
    enqueue_options    dbms_aq.enqueue_options_t;
    message_properties dbms_aq.message_properties_t;
    message_handle     RAW(16);
    message1           SYS.AQ$_JMS_TEXT_MESSAGE;
    message2           SYS.AQ$_JMS_TEXT_MESSAGE;
    message3           SYS.AQ$_JMS_TEXT_MESSAGE;
    msg_hdr            SYS.AQ$_JMS_HEADER;
    msg_agent          SYS.AQ$_AGENT;
    msg_proparray      SYS.AQ$_JMS_USERPROPARRAY;
    msg_property       SYS.AQ$_JMS_USERPROPERTY;
BEGIN
    msg_agent := SYS.AQ$_AGENT(' ', null, 0);
    msg_proparray := SYS.AQ$_JMS_USERPROPARRAY();
    msg_proparray.EXTEND(1);
    msg_property := SYS.AQ$_JMS_USERPROPERTY('JMS_OracleDeliveryMode', 100, '2', NULL, 27);
    msg_proparray(1) := msg_property;

    msg_hdr := SYS.AQ$_JMS_HEADER(msg_agent,null,'<USERNAME>',null,null,null,msg_proparray);

    message1 := SYS.AQ$_JMS_TEXT_MESSAGE(msg_hdr,null,null,null);
    message1.text_vc := '{"id": "id0", "amount": 1000.0}';
    message1.text_len := length(message1.text_vc);

    -- message2 := SYS.AQ$_JMS_TEXT_MESSAGE(msg_hdr,null,null,null);
    -- message2.text_vc := '{"id":"4712","repartitionId":88076183518,"lanCode":"NL","repartitionName":"Een 2e test"}';
    -- message2.text_len := length(message2.text_vc);

    -- message3 := SYS.AQ$_JMS_TEXT_MESSAGE(msg_hdr,null,null,null);
    -- message3.text_vc := '{"id":"4713","repartitionId":88076183518,"lanCode":"NL","repartitionName":"Een 3e test"}';
    -- message3.text_len := length(message3.text_vc);

    dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE_JMS',
                    enqueue_options,
                    message_properties,
                    message1,
                    message_handle);

    -- dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE_JMS',
    --                 enqueue_options,
    --                 message_properties,
    --                 message2,
    --                 message_handle);

    -- dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE_JMS',
    --                 enqueue_options,
    --                 message_properties,
    --                 message3,
    --                 message_handle);
    COMMIT;
END;


/* We need to create a queue supported by JMS */
CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SOURCE_QT_JMS', 
        'SYS.AQ$_JMS_TEXT_MESSAGE');

CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.SOURCE_JMS',
        'SYS.SOURCE_QT_JMS');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.SOURCE_JMS');

/* We need to create a queue supported by JMS */
CALL DBMS_AQADM.CREATE_QUEUE_TABLE(
        'SYS.SOURCE_EXAMPLE_QT_JMS', 
        'SYS.AQ$_JMS_TEXT_MESSAGE');

CALL DBMS_AQADM.CREATE_QUEUE(
        'SYS.SOURCE_EXAMPLE_JMS',
        'SYS.SOURCE_EXAMPLE_QT_JMS');

CALL DBMS_AQADM.START_QUEUE(
        'SYS.SOURCE_EXAMPLE_JMS');


DECLARE 
    text        varchar2(4000); 
    agent       sys.aq$_agent   := sys.aq$_agent(' ', null, 0); 
    message     sys.aq$_jms_text_message; 
    enqueue_options    dbms_aq.enqueue_options_t; 
    message_properties dbms_aq.message_properties_t; 
    msgid               raw(16); 
    msg_hdr            SYS.AQ$_JMS_HEADER;
    msg_agent          SYS.AQ$_AGENT;
    msg_proparray      SYS.AQ$_JMS_USERPROPARRAY;
    msg_property       SYS.AQ$_JMS_USERPROPERTY;
BEGIN 

    msg_agent := SYS.AQ$_AGENT(' ', null, 0);
    msg_proparray := SYS.AQ$_JMS_USERPROPARRAY();
    msg_proparray.EXTEND(1);
    msg_property := SYS.AQ$_JMS_USERPROPERTY('JMS_OracleDeliveryMode', 100, '2', NULL, 27);
    msg_proparray(1) := msg_property;

    msg_hdr := SYS.AQ$_JMS_HEADER(msg_agent,'test-1','<USERNAME>',null,null,null,msg_proparray);

    message := sys.aq$_jms_text_message(msg_hdr,null,null,null); 

    -- FOR i IN 1..400 LOOP 
    --     text := CONCAT (text, '1234567890'); 
    -- END LOOP; 

    message.text_vc := '{ "id": "id-2", "amount": 1234.5, "reason": "test" }';
    message.text_len := length(message.text_vc);

    dbms_aq.enqueue(queue_name => 'SYS.SOURCE_JMS', 
                       enqueue_options => enqueue_options, 
                       message_properties => message_properties, 
                       payload => message, 
                       msgid => msgid); 

END; 

DECLARE 
    text        varchar2(4000); 
    agent       sys.aq$_agent   := sys.aq$_agent(' ', null, 0); 
    message     sys.aq$_jms_text_message; 
    enqueue_options    dbms_aq.enqueue_options_t; 
    message_properties dbms_aq.message_properties_t; 
    msgid               raw(16); 
    msg_hdr            SYS.AQ$_JMS_HEADER;
    msg_agent          SYS.AQ$_AGENT;
    msg_proparray      SYS.AQ$_JMS_USERPROPARRAY;
    msg_property       SYS.AQ$_JMS_USERPROPERTY;
BEGIN 

    msg_agent := SYS.AQ$_AGENT(' ', null, 0);
    msg_proparray := SYS.AQ$_JMS_USERPROPARRAY();
    msg_proparray.EXTEND(1);
    msg_property := SYS.AQ$_JMS_USERPROPERTY('JMS_OracleDeliveryMode', 100, '2', NULL, 27);
    msg_proparray(1) := msg_property;

    msg_hdr := SYS.AQ$_JMS_HEADER(msg_agent,'example-type','example-user',null,null,null,msg_proparray);

    message := sys.aq$_jms_text_message(msg_hdr,null,null,null); 

    message.text_vc := '{ "id": "id-1", "amount": 1234.5, "reason": "test" }';
    message.text_len := length(message.text_vc);

    dbms_aq.enqueue(queue_name => 'SYS.SOURCE_EXAMPLE_JMS', 
                       enqueue_options => enqueue_options, 
                       message_properties => message_properties, 
                       payload => message, 
                       msgid => msgid); 

END; 


SET SERVEROUTPUT ON
DECLARE
dequeue_options     DBMS_AQ.dequeue_options_t;
message_properties  DBMS_AQ.message_properties_t;
message_handle      RAW(16);
message             SYS.AQ$_JMS_TEXT_MESSAGE;
BEGIN
   dequeue_options.navigation := DBMS_AQ.FIRST_MESSAGE;
   DBMS_AQ.DEQUEUE(
      queue_name          =>     'SYS.SOURCE_JMS',
      dequeue_options     =>     dequeue_options,
      message_properties  =>     message_properties,
      payload             =>     message,
      msgid               =>     message_handle);
    DBMS_OUTPUT.PUT_LINE('Handle: '||message_handle);
    DBMS_OUTPUT.PUT_LINE('Text: '||message.text_vc);
    DBMS_OUTPUT.PUT_LINE('Lob: '||message.text_lob);
   COMMIT;
END;


SELECT qtb.USER_DATA.header.type as type_value, qtb.USER_DATA.text_vc as text_value  from SYS.SOURCE_QT_JMS qtb;
SELECT qtb.USER_DATA.text_vc as text_value  from SYS.SAMPLE_AQTBL qtb;
SELECT qtb.USER_DATA.header.type as type_value, qtb.USER_DATA.text_vc as text_value  from SYS.SINK_QT_JMS qtb;

DECLARE
    enqueue_options    dbms_aq.enqueue_options_t;
    message_properties dbms_aq.message_properties_t;
    message_handle     RAW(16);
    message1           SYS.SDMS_INTEGRATION_TYPE;
    message2           SYS.SDMS_INTEGRATION_TYPE;
    message3           SYS.SDMS_INTEGRATION_TYPE;

BEGIN
    message1 := SYS.SDMS_INTEGRATION_TYPE(
            'repName',
            'CreateEvent',
            '1',
            '{
			"id":"1169142819FR"
			,"repartitionId":1169142819
			,"lanCode":"FR"
			,"repartitionName":"Th\\u00E9\\u00E2tre 04\\/2007"
			}'
        );
    message2 := SYS.SDMS_INTEGRATION_TYPE(
            'repName',
            'UpdateEvent',
            '1',
            '{
			  "id":"88076183518NL"
			  ,"repartitionId":88076183518
			  ,"lanCode":"NL"
			  ,"repartitionName":"Podiumkunsten 01\\/2021"
			}'
        );
    message3 := SYS.SDMS_INTEGRATION_TYPE(
            'repName',
            'DeleteEvent',
            '1',
            '{
			   "id":"88076183518NL"
			  ,"repartitionId":88076183518
			  ,"lanCode":"NL"
			  ,"repartitionName":"Podiumkunsten 01\\/2021"
			}'
        );
    dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE',
                    enqueue_options,
                    message_properties,
                    message1,
                    message_handle);

    dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE',
                    enqueue_options,
                    message_properties,
                    message2,
                    message_handle);

    dbms_aq.enqueue('SYS.REPAR_NAME_QUEUE',
                    enqueue_options,
                    message_properties,
                    message3,
                    message_handle);
    COMMIT;
END;

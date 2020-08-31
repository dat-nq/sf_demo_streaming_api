public with sharing class DemoEvent {
    private static String PUSHTOPICEVENT_ACCNAME = 'PushTopicEvent test';
    private static String GENERICEVENT_ACCNAME = 'GenericEvent test';
    private static String PLATFORMEVENT_ACCNAME = 'PlatformEvent test';
    @AuraEnabled
    public static void createChannel(String evtType, String channelName){
        switch on evtType {
            when 'PushTopicEvent' {
                // Define the object, fields, and criteria you're interested in receiving event notifications for
                // After this PushTopic is created, you can subscribe to this PushTopic channel to track changes on accounts whose billing city is San Francisco
                // This PushTopic specifies that the Id, Name, Phone fields are returned in each event notification
                // By default, notifications are sent for create, update, delete, and undelete operations that match the query's criteria.
                // If you create an account, an event notification is generated
                // When you create a PushTopic, the channel is created automatically.
                // channel name format is /topic/PushTopicName
                List<PushTopic> tps = [SELECT Id, Name, Query FROM PushTopic WHERE Name = :channelName];
                if (tps.size() > 0) return;
                PushTopic pushTopic = new PushTopic();
                pushTopic.Name = channelName;
                pushTopic.Query = 'SELECT Id, Name, Phone FROM Account WHERE BillingCity=\'San Francisco\'';
                pushTopic.ApiVersion = 48.0;
                insert pushTopic;
            }
            when 'GenericStreamingEvent' {
                // Unlike PushTopic and Change Data Capture events, Generic Streaming Event use a generic payload that aren't tied to Salesforce data changes.
                // Use generic streaming to send and receive custom notifications with arbitrary payloads and no predefined schema
                // Generic streaming lets you publish notifications to a targeted set of users
                // You can create Generic Streamming channel through UI, Apex (programmatically), REST API, or SOAP API.
                List<StreamingChannel> tps = [SELECT Id, Name FROM StreamingChannel WHERE Name = :channelName];
                if (tps.size() > 0) return;
                insert new StreamingChannel(Name = channelName);
            }
            when 'PlatformEvent' {
                // Unlike PushTopic and Change Data Capture events, platform events aren't tied to Salesforce records and aren't autopublished by Salesforce.
                // Instead, you define the schema of a platform event message by creating a platform event and adding fields
                // To define a platform event in the UI, in Setup, enter Platform Events in the Quick Find box, then select Platform Events
                // API name format is /event/Event_Name . For example, /event/Test_Event__e
            }
            when else {

            }
        }
    }

    @AuraEnabled
    public static void publishEvent(String evtType){
        Integer randomInt = Integer.valueof((Math.random() * 10000));
        switch on evtType {
            when 'PushTopicEvent' {
                Account acc = new Account(Name=PUSHTOPICEVENT_ACCNAME + ' ' + randomInt, BillingCity='San Francisco');
                insert acc;
            }
            when 'GenericStreamingEvent' {
                // https://developer.salesforce.com/docs/atlas.en-us.api_streaming.meta/api_streaming/generate_event_using_rest.htm
            }
            when 'PlatformEvent' {
                Account acc = new Account(Name=PLATFORMEVENT_ACCNAME + ' ' + randomInt);
                insert acc;
                Test_Event__e te = new Test_Event__e ();
                te.Test_Field__c  = acc.Name;
                EventBus.publish(te);
            }
            when else {

            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        List<PushTopic> tps = [SELECT Id, Name, Query FROM PushTopic WHERE Name = 'AccountUpdates'];
        if (tps.size() == 0) return new List<Account>();
        PushTopic tp = tps[0];
        return (List<Account>)Database.query(tp.Query);
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts(){
        System.debug('getAllAccounts');
        return [SELECT Id, Name, Phone FROM Account WHERE Name LIKE :(PUSHTOPICEVENT_ACCNAME+'%') OR Name LIKE :(GENERICEVENT_ACCNAME+'%') OR Name LIKE :(PLATFORMEVENT_ACCNAME+'%')];
    }

    @AuraEnabled
    public static void deleteAccounts(){
        List<Account> accts = [SELECT Id, Name, Phone FROM Account WHERE Name LIKE :(PUSHTOPICEVENT_ACCNAME+'%') OR Name LIKE :(GENERICEVENT_ACCNAME+'%') OR Name LIKE :(PLATFORMEVENT_ACCNAME+'%')];
        if (accts.size() > 0){
            delete accts;
            Database.emptyRecycleBin(accts);
        }
    }
}
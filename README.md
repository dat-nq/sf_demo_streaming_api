# Salesforce Streaming API
## How to run Demo?
- create new project with manifest
- set default org
- download demo
- copy demo/force-app/main/default -> newproject/force-app/main/default
- copy manifest/package.xml -> manifest/package.xml
- right click on package.xml -> select "Deploy source in manifest to Org"
- Open default org
- Open "Demo Streaming API" app

<img src="Salesforce Streaming API Demo.gif"/>

## What is Streaming API?
- Streaming API enables streaming of events using push technology and provides a subscription mechanism for receiving events in near real time.
- We can think of Streaming API as a radar which keeps tracks of events.

## What kind of events does the Streaming API support?
Streaming API subscription mechanism supports multiple types of events including PushTopic events, generic events, platform events, and Change Data Capture events.

* Push Topic Event
* Generic Streaming Event
* Platform Event

## How to use Streaming API?
* First, Define an event channel (see How To Define Event Channel)
* Second, publish event (see How To Publish Event)
* Third, subscribe event (see How To Subscribe Event (LWC))

## How To Define Event Channel
- Push Topic Event

API name format is /u/EventName . For example, /topic/AccountUpdates
```
PushTopic pushTopic = new PushTopic();
pushTopic.Name = 'AccountUpdates';
pushTopic.Query = 'SELECT Id, Name, Phone FROM Account WHERE BillingCity=\'San Francisco\'';
pushTopic.ApiVersion = 48.0;
insert pushTopic;
```

- Generic Streaming Event

API name format is /u/EventName . For example, /u/Broadcast
```
insert new StreamingChannel(Name = '/u/EventName');
```

- Platform Event

To define a platform event in the UI, in Setup, enter Platform Events in the Quick Find box, then select Platform Events
API name format is /event/Event_Name . For example, /event/Test_Event__e

## How To Publish Event
- Push Topic Event

Just insert/update/delete an account that has BillingCity match with pushTopic query criteria
```
insert new Account(Name=PUSHTOPICEVENT_ACCNAME + ' ' + randomInt, BillingCity='San Francisco');
```

- Generic Streaming Event: https://developer.salesforce.com/docs/atlas.en-us.api_streaming.meta/api_streaming/generate_event_using_rest.htm
- Platform Event

```
Account acc = new Account(Name=PLATFORMEVENT_ACCNAME + ' ' + randomInt);
insert acc;
Test_Event__e te = new Test_Event__e ();
te.Test_Field__c  = acc.Name;
EventBus.publish(te);
```

## How To Subscribe Event (LWC)
https://developer.salesforce.com/docs/component-library/bundle/lightning-emp-api/documentation

- The lightning/empApi module provides access to methods for subscribing to a streaming channel and listening to event messages.
- All streaming channels are supported, including channels for platform events, PushTopic events, generic events, and Change Data Capture events.
- This component requires API version 44.0 or later.

```
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi'
export class DemoEvent extends LightningElement {
    channelName = 'Test_Event__e'
    channelApiName = '/event/Test_Event__e'
    @track message
    connectedCallback() {
        const _self = this
        const messageCallback = function (response) {
            _self.message = JSON.stringify(response)
            console.log('Received event: ' + _self.message)
        }
        subscribe(this.channelApiName, -1, messageCallback).then(response => { })
    }
}
```

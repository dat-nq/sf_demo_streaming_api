import { track, wire } from 'lwc'
import { DemoEvent } from 'c/demoEvent'

export default class PushtopicEvent extends DemoEvent {
    channelName = 'AccountUpdates'
    channelApiName = '/topic/AccountUpdates'
    evtType = 'PushTopicEvent'
}
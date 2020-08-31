import { DemoEvent } from 'c/demoEvent'

export default class GenericEvent extends DemoEvent {
    channelName = '/u/Broadcast'
    channelApiName = '/u/Broadcast'
    evtType = 'GenericStreamingEvent'
}
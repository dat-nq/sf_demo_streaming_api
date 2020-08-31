import { DemoEvent } from 'c/demoEvent'

export default class PlatformEvent extends DemoEvent {
    channelName = 'Test_Event__e'
    channelApiName = '/event/Test_Event__e'
    evtType = 'PlatformEvent'
}
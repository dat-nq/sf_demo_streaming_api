import { LightningElement, track, wire } from 'lwc'
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi'
import createChannel from '@salesforce/apex/DemoEvent.createChannel'
import publishEvent from '@salesforce/apex/DemoEvent.publishEvent'

export class DemoEvent extends LightningElement {
    channelName = ''
    channelApiName = ''
    evtType = ''
    @track message

    connectedCallback() {
        createChannel({ evtType: this.evtType, channelName: this.channelName }).then((error, data) => {
            if (error) {
                console.log(error)
            } else {
                const _self = this
                const messageCallback = function (response) {
                    _self.message = JSON.stringify(response)
                    _self.dispatchEvent(new CustomEvent('refreshaccounts'));
                    console.log('Received event: ' + _self.message)
                }
                subscribe(this.channelApiName, -1, messageCallback).then(response => { })
            }
        })
    }

    refreshAccount() { }

    handlePublishEvent(event) {
        publishEvent({ evtType: this.evtType }).then(() => {
            console.log('publish ' + this.evtType + '!')
        }).catch((error) => {
            console.log(error)
        })
    }
}
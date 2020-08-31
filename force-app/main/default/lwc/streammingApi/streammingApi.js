import { LightningElement, track, wire } from 'lwc'
import getAllAccounts from '@salesforce/apex/DemoEvent.getAllAccounts'
import { refreshApex } from '@salesforce/apex'

export default class StreammingApi extends LightningElement {
    @track accounts
    _forRefresh

    @wire(getAllAccounts)
    wiredAccounts(result){
        this._forRefresh = result
        const {error, data} = result
        if (data) this.accounts = data
    }

    refreshAccounts(){
        return refreshApex(this._forRefresh)
    }
}
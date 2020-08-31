import { DemoEvent } from 'c/demoEvent'
import { api } from 'lwc'
import deleteAccounts from '@salesforce/apex/DemoEvent.deleteAccounts'

export default class AccountList extends DemoEvent {
    @api accounts

    deleteData(event){
        deleteAccounts().then(() => {
            this.dispatchEvent(new CustomEvent('refreshaccounts'))
        })
    }
}
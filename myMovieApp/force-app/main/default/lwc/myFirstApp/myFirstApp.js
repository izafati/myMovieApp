import { LightningElement, track } from 'lwc';

export default class MyFirstApp extends LightningElement {
    @track searchTerm;
    @track searchInput;
    @track searchComplete = false;

    handleNewSearch(event) {
        this.searchTerm = event.target.value;
    }

    handleSearchComplete(event) {
        this.searchInput = event.detail;
        this.searchComplete = true;
    }
}
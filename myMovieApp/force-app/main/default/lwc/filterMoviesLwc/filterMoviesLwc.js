import { LightningElement, track } from 'lwc';

const DELAY = 350;

export default class FilterMoviesLwc extends LightningElement {

    @track searchTerm;
    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        const selectedEvent = new CustomEvent('newsearch', {detail: this.searchTerm});
        window.clearTimeout(this.delayTimeout);

        this.delayTimeout = setTimeout(() => {
            this.dispatchEvent(selectedEvent);
        }, DELAY);
    }
    
    handleNewMovieModal(){
        const selectedEvent = new CustomEvent('newmovie');
        this.dispatchEvent(selectedEvent);
    }
}
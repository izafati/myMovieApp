import { api, LightningElement, track, wire} from 'lwc';
import searchMovies from '@salesforce/apex/MovieController.searchMovies';
import { refreshApex } from '@salesforce/apex';

export default class MainContainer extends LightningElement {
    @track error;
    @track movies = [];
    @track wiredMovieList = [];
    @api searchTerm = '';
    @api selectedMovie;
    @track openNewMovieModal = false;
    
    showNewMovieModal() {
        this.openNewMovieModal = true;
    }

    closeNewMovieModal(){
        this.openNewMovieModal = false;
    }

    showMovie(event) {
        this.selectedMovie = event.target.movie;
        this.selectedMovie.MaleActorsPercentage__c =  this.selectedMovie.MaleActorsPercentage__c  ? 
                                    Math.floor(this.selectedMovie.MaleActorsPercentage__c) :
                                    0;
        this.selectedMovie.FemaleActorsPercentage__c =  this.selectedMovie.FemaleActorsPercentage__c  ? 
                                    Math.floor(this.selectedMovie.FemaleActorsPercentage__c) :
                                    0;
                                                               
    }

    handleNewSearch(event) {
        this.searchTerm = event.detail;
    }

    @wire(searchMovies, {
        searchTerm: '$searchTerm'
    })
    loadMovies(result) {
        this.wiredMovieList = result;
        if(result.data) {
            this.movies = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.movies = undefined;
        }
    }

    refreshMovieList(event){
        refreshApex(this.wiredMovieList)
        .then(() => {
            let movieId = event.detail;
            if(movieId){
                this.selectedMovie = this.movies.filter(mov => {
                    return mov.Id === movieId;
                  })[0];
            } else {
                this.selectedMovie = undefined;
            }
        })                
    }

    
}
import { LightningElement, api, track, wire } from 'lwc';
import updateMovie from '@salesforce/apex/MovieController.updateMovie';
import deleteMovie from '@salesforce/apex/MovieController.deleteMovie';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';


import MOVIE_OBJECT from '@salesforce/schema/Movie__c';
import NAME_FIELD from '@salesforce/schema/Movie__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/Movie__c.Category__c';
import RELEASE_FIELD_FIELD from '@salesforce/schema/Movie__c.Release_date__c';
import StayInTouchSubject from '@salesforce/schema/User.StayInTouchSubject';

export default class MoviePreviewLwc extends LightningElement {

    @track movieObject = {};
    @track showEditComponent = false;
    @track categoryPicklistOptions;

    @api recordId;
    @api objectApiName;    

    @api movie;

    fields = [NAME_FIELD, CATEGORY_FIELD, RELEASE_FIELD_FIELD];
    @wire( getObjectInfo ,{
        objectApiName:MOVIE_OBJECT,
    })
    movieInfo;
    @wire(getPicklistValues,{
        recordTypeId: '$movieInfo.data.defaultRecordTypeId',
        fieldApiName: CATEGORY_FIELD
    })
    categoryPicklist({data,error}){
        if(data){
            this.categoryPicklistOptions=data.values;
        }else if(error){
            this.error = error;
        }
    }

    handleName(event){
        this.movieObject.Name = event.target.value;
    }

    handleCategory(event){
        this.movieObject.Category__c = event.target.value;
    }

    handleReleaseDate(event){
        this.movieObject.Release_date__c = event.target.value;
    }

    handleDeleteMovie() {
        deleteMovie({ movie : this.movie})
        .then(result =>{
            this.toastEventFire('Success','Movie Record was deleted','success');
            const selectedEvent = new CustomEvent('refreshmovie', {detail: this.movieObject.Id});
            this.dispatchEvent(selectedEvent);
        })
        .catch(error =>{
            this.error = error.message;
        })
    }

    handleEditMovie() {
        this.showEditComponent = true;
        this.movieObject.Id = this.movie.Id;
        this.movieObject.Name = this.movie.Name;
        this.movieObject.Category__c = this.movie.Category__c;
        this.movieObject.Release_date__c = this.movie.Release_date__c; 
      }

    handleSaveMovie(event) {
        updateMovie({ movie : this.movieObject})
        .then(result =>{
            this.toastEventFire('Success','Movie Record is Saved','success');
            const selectedEvent = new CustomEvent('refreshmovie', {detail: this.movieObject.Id});
            this.dispatchEvent(selectedEvent);
        })
        .catch(error =>{
            this.error = error.message;
        })
        this.showEditComponent = false;
    }

    toastEventFire(title,msg,variant,mode){
        const e = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(e);
    } 
}
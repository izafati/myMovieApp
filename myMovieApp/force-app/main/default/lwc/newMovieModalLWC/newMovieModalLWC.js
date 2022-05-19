import { LightningElement, wire, track} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import MOVIE_OBJECT from '@salesforce/schema/Movie__c';
import CATEGORY_FIELD from '@salesforce/schema/Movie__c.Category__c';
import getActors from '@salesforce/apex/ActorController.getActors';
import createMovie from '@salesforce/apex/MovieController.createMovie';

export default class NewMovieModalLwc extends LightningElement {

    @track actorOptions= [];
    @track actorIds = []
    @track movie = {};
    @track categoryPicklistOptions;
    @track disableSave = true;


    closeModal(){
        const selectedEvent = new CustomEvent('closemodal');
        this.dispatchEvent(selectedEvent);
    }

    enableSaveBtn() {
        this.disableSave = !(this.movie.Name 
            &&  this.movie.Category__c
            &&  this.movie.Release_date__c);
            }

    handleName(event){
        this.movie.Name = event.target.value;
        this.enableSaveBtn();
    }

    handleCategory(event){
        this.movie.Category__c = event.target.value;
        this.enableSaveBtn();
    }

    handleReleaseDate(event){
        this.movie.Release_date__c = event.target.value;
        this.enableSaveBtn();
    }

    handleDescription(event){
        this.movie.Description_c = event.target.value;
        this.enableSaveBtn();
    }

    handleActorOptions(event){
        this.actorIds = event.target.value;
    }

    handleSaveMovie() {
        createMovie({   movie : this.movie,
                        actorIds : this.actorIds})
        .then(result =>{
            this.closeModal();
            this.toastEventFire('Success','Movie Record is Saved','success');
            const selectedEvent = new CustomEvent('refreshmovie');
            this.dispatchEvent(selectedEvent);
        })
        .catch(error =>{
            this.error = error.message;
        })
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

    @wire(getActors)
    fetchActors(result){
        if(result.data) {
            result.data.forEach( actor => {
                this.actorOptions.push({
                    label: actor.Name,
                    value: actor.Id
                });
            });
        }  else if (result.error) {
            this.error = error;
        }
    };
}
import { LightningElement, track, wire} from 'lwc';
import searchLeads from '@salesforce/apex/LeadSearchController.searchLeads';
import { NavigationMixin } from 'lightning/navigation';

const DELAY = 350;

const COLS = [
    {
        label : 'Name',
        fieldName : 'Name',
        type : 'text'
    },
    {
        label : 'Title',
        fieldName : 'Title',
        type : 'text'
    },
    {
        label : 'Company',
        fieldName : 'Company',
        type : 'text'
    },
    {
        label : 'View',
        type : 'button-icon',
        initialWidth : 75,
        typeAttributes : {
            title : 'View Details',
            alternativeText : 'View Details',
            iconName : 'action:info'
        }
    }
];

export default class LeadList extends NavigationMixin(LightningElement) {
    @track leads =[];
    @track searchTerm;
    @track cols = COLS;
    @track error;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        const selectedEvent = new CustomEvent('newsearch', {detail: this.searchTerm});
        window.clearTimeout(this.delayTimeout);

        this.delayTimeout = setTimeout(() => {
            this.dispatchEvent(selectedEvent);
        }, DELAY);
    }

    @wire(searchLeads, {
        searchTerm: '$searchTerm'
    })
    loadLeads({ error, data }) {
        if(data) {
            this.leads = data;
            const selectedEvent = new CustomEvent('searchcomplete', {detail: this.searchTerm});
            this.dispatchEvent(selectedEvent);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.leads = undefined;
        }
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        console.log(row.Id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.record.Id,
                objectApiName: 'Lead',
                actionName: 'view'
            },
        });
    }

   /*  leads = [
        {
            "Id" : "LeadRef1",
            "Name" : "Bertha Boxer",
            "Title" : "Director of vendor relations",
            "Company" : "Farmers Coop. of Florida",
            "Street" : "321 Westcost building",
            "City" : "Talhassee",
            "State" : "FL",
            "PostalCode" : "32306"
        },
        {
            "Id" : "LeadRef2",
            "Name" : "Phyllis Coton",
            "Title" : "Coton",
            "Company" : "Chamber of commerce",
            "Street" : "300 park avenue",
            "City" : "Talhassee",
            "State" : "FL",
            "PostalCode" : "32301"
        },
        {
            "Id" : "LeadRef3",
            "Name" : "Jeff Glimpse",
            "Title" : "SVP, procurement",
            "Company" : "Talhassee ground",
            "Street" : "125 eden street",
            "City" : "Talhassee",
            "State" : "FL",
            "PostalCode" : "32200"
        }
    ] */



}
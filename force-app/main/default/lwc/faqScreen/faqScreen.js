import { LightningElement, wire } from 'lwc';
import getFAQs from '@salesforce/apex/FAQService.getFAQs';

export default class FAQScreen extends LightningElement {
    searchKey = '';
    delayTimeout;

    actualPage = 1;
    pageSize = 10;
    completedData = [];

    @wire(getFAQs, { searchKey: '$searchKey' })
    wiredResult({ error, data }) {
        if (data) {
            this.completedData = data;
            this.actualPage = 1;
        } else if (error) {
            console.error('Erro ao buscar FAQs: ', error);
            this.completedData = [];
        }
    }

    get paginatedData() {
        if (!this.completedData || this.completedData.length === 0) {
            return [];
        }
        const startIndex = (this.actualPage - 1) * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        
        console.log('--- Renderizando a Página', this.actualPage, '---');
        console.log('Exibindo itens do índice', startIndex, 'até', endIndex);
        
        return this.completedData.slice(startIndex, endIndex);
    }

    handlePrevious() {
        console.log('Previous Button Clicked!');
        if (this.actualPage > 1) {
            this.actualPage--;
        }
    }

    handleNext() {
        console.log('Next Button Clicked!');
        if (this.actualPage < this.totalOfPages) {
            this.actualPage++;
        }
    }

    get totalOfPages() {
        return Math.ceil(this.completedData.length / this.pageSize) || 1;
    }

    get disablePrevious() {
        return this.actualPage <= 1;
    }

    get disableNext() {
        return this.actualPage >= this.totalOfPages;
    }

    get isEmptyList() {
        return this.completedData.length === 0;
    }

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const typedText = event.target.value;

        this.delayTimeout = setTimeout(() => {
            this.searchKey = typedText; 
        }, 1000);
    }
}
import { LightningElement, wire } from 'lwc';
import getFAQs from '@salesforce/apex/FAQService.getFAQs';

export default class FAQScreen extends LightningElement {
    searchKey = '';
    delayTimeout;

    // 1. Estados da página
    actualPage = 1;
    pageSize = 10;
    completedData = [];

    // 2. O @wire agora guarda os dados de forma pura e estática
    @wire(getFAQs, { searchKey: '$searchKey' })
    wiredResult({ error, data }) {
        if (data) {
            this.completedData = data;
            this.actualPage = 1; // Só reseta se o utilizador fizer uma nova pesquisa no input
        } else if (error) {
            console.error('Erro ao buscar FAQs: ', error);
            this.completedData = [];
        }
    }

    // 3. O SEGREDO DA REATIVIDADE LIMPA: Transformamos a paginação num GETTER.
    // O HTML vai chamar este getter automaticamente sempre que a página mudar.
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

    // 4. Métodos dos botões (agora apenas alteram o número da página)
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

    // 5. Getters de controlo calculados dinamicamente
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
        }, 1000); // 1 segundo conforme especificação de performance
    }
}
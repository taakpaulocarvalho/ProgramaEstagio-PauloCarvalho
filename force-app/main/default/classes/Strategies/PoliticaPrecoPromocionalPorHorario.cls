public with sharing class PoliticaPrecoPromocionalPorHorario implements PoliticaDePreco{
    
    private Time horaInicioDesconto;
    private Time horaFimDesconto;
    private Time HorarioAtual;
    private Decimal percentual;

    public PoliticaPrecoPromocionalPorHorario(Time horaInicioDesconto, Time horaFimDesconto, Time HorarioAtual, Decimal percentual){
        if (percentual < 0) 
            throw new IllegalArgumentException('O percentual deve ser maior que zero!');

        if (horaInicioDesconto > horaFimDesconto) 
            throw new IllegalArgumentException('Horário de Fim deve ser após o Horario de Inicio!');

        if (horaInicioDesconto == null || horaFimDesconto == null|| HorarioAtual == null || percentual == null)
            throw new IllegalArgumentException('Todos os campos devem ser preenchidos!');
        
        this.horaInicioDesconto = horaInicioDesconto;
        this.horaFimDesconto = horaFimDesconto;
        this.HorarioAtual = HorarioAtual;
        this.percentual = percentual;
    }

    public Dinheiro calcularPreco(Produto produto){
        
        if(HorarioAtual >= horaInicioDesconto && HorarioAtual <= horaFimDesconto){
            Decimal valorDescontar = produto.precoBase.valorMonetario * (percentual / 100);

            return produto.precoBase.Subtrair(new Dinheiro(valorDescontar));
        }
        return produto.precoBase;
    }
}
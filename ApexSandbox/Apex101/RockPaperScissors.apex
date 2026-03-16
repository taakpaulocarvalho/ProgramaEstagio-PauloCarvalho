public Integer rockPaperScissors(String player1, String player2) {

    if ((player1 == 'paper' && player2 == 'rock') 
        || (player1 == 'rock' && player2 == 'scissors')
        || (player1 == 'scissors' && player2 == 'paper')){
        
        return 1;
    }
    
    if ((player1 == 'rock' && player2 == 'paper') 
        || (player1 == 'scissors' && player2 == 'rock')
        || (player1 == 'paper' && player2 == 'scissors')){
        
        return 2;
    }

    return 0;
}
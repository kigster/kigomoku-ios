class Grid {
    
    int ** matrix;
    int count;
    
    class Move {
        int y;
        int x;
    }

    class Best {
        Move m;
        double score;
    }
        

    public Move chooseMove(boolean side, Double alpha, Double beta, int depth) {
        Move myBest = new Best(); // my best move
        Move reply;               // opponents best reply
    
        if (the current grid is full ||
            has a win ||
            depth >= MAX_DEPTH) {
            newBest.score = evaluate current state
                // COMPUTER win: +INF
                // HUMAN win: -INF
                // DRAW: 0
            return newBest;
        }
    
        if (side == COMPUTER) {
            myBest.score = alpha;
        } else {
            myBest.score = beta;
        }
    
        for (each legal move m) {
            perform move m;  // modifies grid
            reply = chooseMove(!side, alpha, beta);
            undo move m;     // restores grid
        
            if (side == COMPUTER && reply.score > myBest.score) {
                myBest.move = m;
                myBest.score = reply.score;
                alpha = reply.score;
            } else if (side == HUMAN    && reply.score < myBest.score) {
                myBest.move = m;
                myBest.score = reply.score;
                beta = reply.score;
            }
            if (alpha >= beta) { return myBest; } // pruning
        }
    
        return myBest;
    }
    
    public Move next() {
        return chooseMove(COMPUTER, -Infinity, +Infinity, int depth)
    }

}
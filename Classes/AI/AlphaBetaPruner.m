//
//  AlphaBetaPruner.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "AlphaBetaPruner.h"
#import "basic_ai.h"

@implementation AlphaBetaPruner
@synthesize board;
@synthesize maxDepth;
@synthesize player;

-(AlphaBetaPruner *)initWithBoard: (Board *) thisBoard {
    return [self initWithBoard:thisBoard andSearchDepth:0];
}

-(AlphaBetaPruner *)initWithBoard: (Board *) thisBoard
                   andSearchDepth: (int) depth {
    if (self = [super init]) {
        self.board = thisBoard;
        self.player = [board nextPlayerValue];
        self.maxDepth = depth;
    }
	return self; 
}


/*
 * Starting call that begins with alpha/beta at infinity.
 */
-(MyBest *)chooseMove {
    return [self chooseMoveFor: player 
                     withDepth: 0
                      andAlpha: -(INFINITY - 1) 
                       andBeta:  (INFINITY - 1)];
}

-(MyBest *)chooseMoveFor:(int) currentPlayer 
               withDepth:(int) depth 
                andAlpha:(double) alpha 
                 andBeta:(double) beta {
    
    if ([board isGameOver] ||
        [board isFilled] ||
        depth >= self.maxDepth) {
        NSLog(@"reached end of search tree at depth %d, running evaluation function", depth);
        MyBest *best = [[MyBest alloc] init];  // our best move
        int x = 0, y = 0;
        double evalScore = 0.0;
        int **b = [self.board matrix];
        int result = pick_next_move_with_score(
                                   b, 
                                   self.board.size,
                                   currentPlayer,
                                   &x,
                                   &y,
                                   &evalScore);
        // COMPUTER win: +INF
        // HUMAN win: -INF
        // DRAW: 0

        if (result == 0) {
            best.move = [[Move alloc] initWithX:x andY:y];
            best.score = evalScore;
            return best;
        }
    } 

    // MyBest *reply;                           // opponents best reply

    
    return nil;
    
    
    
}
//  public Move chooseMove(boolean side, Double alpha, Double beta, int depth) {
//        Move myBest = new Best(); // my best move
//        Move reply;               // opponents best reply
//        
//        
//        if (side == COMPUTER) {
//            myBest.score = alpha;
//        } else {
//            myBest.score = beta;
//        }
//        
//        for (each legal move m) {
//            perform move m;  // modifies grid
//            reply = chooseMove(!side, alpha, beta);
//            undo move m;     // restores grid
//            
//            if (side == COMPUTER && reply.score > myBest.score) {
//                myBest.move = m;
//                myBest.score = reply.score;
//                alpha = reply.score;
//            } else if (side == HUMAN    && reply.score < myBest.score) {
//                myBest.move = m;
//                myBest.score = reply.score;
//                beta = reply.score;
//            }
//            if (alpha >= beta) { return myBest; } // pruning
//        }
//        
//        return myBest;
//    }
//    
//    public Move next() {
//        return chooseMove(COMPUTER, -Infinity, +Infinity, int depth)
//    }
//    
//}
@end

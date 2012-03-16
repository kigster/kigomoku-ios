//
//  AlphaBetaPruner.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "AlphaBetaPruner.h"


@implementation AlphaBetaPruner
@synthesize board;
@synthesize count;

-(AlphaBetaPruner *)initWithBoard:(Board *) thisBoard {
    if (self = [super init]) {
        self.board = thisBoard;
    }
	return self; 
}


-(MyBest *)chooseMoveFor:(int) player 
               withDepth:(int) depth {
    
    return [self chooseMoveFor:player 
                     withDepth:depth 
                      andAlpha: -(INFINITY - 1) 
                       andBeta:  (INFINITY - 1)];
}

-(MyBest *)chooseMoveFor:(int) player 
               withDepth:(int) depth 
                andAlpha:(double) alpha 
                 andBeta:(double) beta {
    
    //        if (the current grid is full ||
    //            has a win ||
    //            depth >= MAX_DEPTH) {
    //            newBest.score = evaluate current state
    //            // COMPUTER win: +INF
    //            // HUMAN win: -INF
    //            // DRAW: 0
    //            return newBest;
    //        }
    
    
    MyBest *best = [[MyBest alloc] init];  // our best move
    Move *reply;                           // opponents best reply
    
    return best;
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

//
//  AlphaBetaPruner.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "MyBest.h"



@interface AlphaBetaPruner : NSObject {
    Board *board;
    int maxDepth;
    int computerPlayer;
}

@property(strong, nonatomic) Board *board;
@property(nonatomic) int maxDepth;
@property(nonatomic) int computerPlayer;

-(AlphaBetaPruner *)initWithBoard: (Board *) board;
-(AlphaBetaPruner *)initWithBoard: (Board *) board 
                   andSearchDepth: (int) depth
                andComputerPlayer: (int) computer;

-(double) evaluateBoard:(int) playerValue;

-(MyBest *)chooseMove;

-(MyBest *)chooseMoveFor:(int) player 
             withDepth:(int) depth 
              andAlpha:(double) alpha 
               andBeta:(double) beta;

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

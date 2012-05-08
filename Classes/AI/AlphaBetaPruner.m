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
@synthesize computerPlayer;


-(AlphaBetaPruner *)initWithBoard: (Board *) thisBoard {
    populate_threat_matrix();
    return [self initWithBoard:thisBoard 
                andSearchDepth:3
             andComputerPlayer:CELL_WHITE_OR_O];
}

-(AlphaBetaPruner *)initWithBoard: (Board *) thisBoard
                   andSearchDepth: (int) depth
                andComputerPlayer: (int) computer {
    if (self = [super init]) {
        self.board = thisBoard;
        self.computerPlayer = computer;
        self.maxDepth = depth;
    }
	return self; 
}


/*
 * Starting call that begins with alpha/beta at infinity.
 */
-(MyBest *)chooseMove {
    if (board.moveCount < 4) {
        int x, y;
        pick_next_move(board.matrix, 
                board.size,
                computerPlayer,  // next move is by X
                &x, 
                &y);
        MyBest *best = [MyBest alloc];
        best.move = [[Move alloc] initWithX:x andY:y];
        return best;
    }

    double alpha = -(INFINITY - 1);
    double beta  =  (INFINITY - 1);
    return [self chooseMoveFor: computerPlayer 
                     withDepth: 0
                      andAlpha: alpha 
                       andBeta: beta];
}

-(double) evaluateBoard:(int) playerValue {
    int i, j, size = board.size;
    double total_score = 0;
    int **b = board.matrix;
    int coefficient = (self.computerPlayer == playerValue ? 1 : -1);
    for (i = 0; i < size; i++) {
        for (j = 0; j < size; j++) {
            if (b[i][j] == playerValue) {
                total_score += coefficient * calc_score_at(b, size, playerValue, i, j);
            } 
        }
    }

    return total_score;
}

-(MyBest *)chooseMoveFor:(int) player 
               withDepth:(int) depth 
                andAlpha:(double) alpha 
                 andBeta:(double) beta {
    
    MyBest *best = [[MyBest alloc] init];  // our best move
    int x = 0, y = 0;
    if ([board isGameOver] ||
        [board isFilled] ||
        depth >= self.maxDepth) {
        
        best.score = [self evaluateBoard:player];
        return best;
    }
    
    if (player == computerPlayer) {
        best.score = alpha;
    } else {
        best.score = beta;
    }

    MyBest *reply;  // opponents best reply

    for (x = 0; x < board.size; x++) {
        for (y = 0; y < board.size; y++) {
            int i,j;
            i = (x + board.size / 2) % board.size;
            j = (y + board.size / 2) % board.size;

            
            if ((board.matrix[i][j] == CELL_EMPTY) &&
                ((calc_score_at(board.matrix, board.size, -player, i, j) > 0 ||
                  calc_score_at(board.matrix, board.size,  player, i, j) > 0 ))) {
                    
                Move *move = [[Move alloc] initWithX:i andY:j];
                [board makeMove:move]; // modifies this grid
                reply = [self chooseMoveFor:-player
                                  withDepth: depth + 1 
                                   andAlpha: alpha 
                                    andBeta: beta];
                
               
                [board undoMove:move]; // restores the grid
            
                if (player == computerPlayer) {
                    if (reply.score > best.score) {
                        best.move = move;
                        best.score = reply.score;
                        alpha = reply.score;
                        if (depth == 0) {
                            NSLog(@"found our best: player %d depth %d score %.3f, alpha %.3f, beta %.3f move %@", 
                                  player, depth, reply.score, alpha, beta, move);
                        }
                    }
                } else if (player != computerPlayer) {
                    if (reply.score < best.score) {
                        best.move = move;
                        best.score = reply.score;
                        beta = reply.score;
                        if (depth == 0) {
                            NSLog(@"found oppenent's best: player %d depth %d score %.3f, alpha %.3f, beta %.3f move %@", 
                                  player, depth, reply.score, alpha, beta, move);
                        }
                    }
                }
                if (alpha >= beta) { return best; } // pruning
            }
        }   
    }
        
    return best;
}
@end

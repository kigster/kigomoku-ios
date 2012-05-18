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

#define DEPTH 3

-(AlphaBetaPruner *)initWithBoard: (Board *) thisBoard {
    populate_threat_matrix();
    return [self initWithBoard:thisBoard 
                andSearchDepth:DEPTH
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
        MyBest *best = [MyBest alloc];
        if (board.moveCount == 0) {
            best.move = [[Move alloc] initWithX:(board.size / 2) andY:(board.size / 2)];
            return best;
        }

        int x, y;
        pick_next_move(board.matrix, 
                board.size,
                computerPlayer,  // next move is by X
                &x, 
                &y);
        best.move = [[Move alloc] initWithX:x andY:y];
        return best;
    }

    double alpha = MIN_WIN_SCORE;
    double beta  = MAX_WIN_SCORE;
    
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
    for (i = MAX(0, board.range.minX - LOOKUP_RANGE); 
         i < MIN(size, board.range.maxX + LOOKUP_RANGE); 
         i++) {

        for (j = MAX(0, board.range.minY); 
             j < MIN(size, board.range.maxY + LOOKUP_RANGE); 
             j++) {

            if (b[i][j] == CELL_EMPTY) {
                // give more value to current player score in this move
                total_score += 1.5 * coefficient * calc_score_at(b, size, playerValue, i, j);
                total_score -= coefficient * calc_score_at(b, size, -playerValue, i, j);
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
    BOOL gameOver = [board isGameOver];
    if (gameOver) {
        int winner = [board winnerPlayer];
        if (winner == self.computerPlayer) {
            best.score = MAX_WIN_SCORE;
        } else {
            best.score = MIN_WIN_SCORE;
        }
        return best;
    } else if ([board isFilled]) {
        best.score = 0;
        return best;
    } else if (depth >= self.maxDepth) {
        best.score = [self evaluateBoard:player];
        return best;
    }
    
    if (player == computerPlayer) {
        best.score = alpha;
    } else {
        best.score = beta;
    }

    MyBest *reply;  // opponents best reply

    int i, j;
    for (i = MAX(0, board.range.minX - LOOKUP_RANGE); 
         i < MIN(board.size, board.range.maxX + LOOKUP_RANGE); 
         i++) {
        
        for (j = MAX(0, board.range.minY); 
             j < MIN(board.size, board.range.maxY + LOOKUP_RANGE); 
             j++) {
            
            if (board.matrix[i][j] == CELL_EMPTY &&
                (calc_score_at(board.matrix, board.size, player, i, j) > 0 ||
                 calc_score_at(board.matrix, board.size, -player, i, j) > 0)) {
                    
                Move *move = [[Move alloc] initWithX:i andY:j];
                [board makeMove:move]; // modifies this grid
            
                if (player == computerPlayer) {
                    // max node
                    reply = [self chooseMoveFor:-player
                                      withDepth: depth + 1 
                                       andAlpha: best.score
                                        andBeta: beta];
                    if (reply.score > best.score) {
                        best.move = move;
                        best.score = reply.score;
                        alpha = reply.score;
//                        if (depth == 0) {
//                            NSLog(@"found our best: player %d depth %d score %.3f, alpha %.3f, beta %.3f move %@", 
//                                  player, depth, reply.score, alpha, beta, move);
//                        }
                    }
                } else {
                    // min node
                    reply = [self chooseMoveFor:-player
                                      withDepth: depth + 1 
                                       andAlpha: alpha
                                        andBeta: best.score];
                    if (reply.score < best.score) {
                        best.move = move;
                        best.score = reply.score;
                        beta = reply.score;
//                        if (depth == 0) {
//                            NSLog(@"found oppenent's best: player %d depth %d score %.3f, alpha %.3f, beta %.3f move %@", 
//                                  player, depth, reply.score, alpha, beta, move);
//                        }
                    }
                }
                [board undoMove:move]; // restores the grid

                if (alpha >= beta) { return best; } // pruning
            }
        }   
    }
        
    return best;
}
@end

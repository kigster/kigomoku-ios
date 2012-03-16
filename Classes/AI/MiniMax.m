//
//  MiniMax.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/14/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "MiniMax.h"

@implementation MiniMax
@synthesize depth;
@synthesize startBoard;

/*
 * depth of 0 means no tree search; > 0 means do tree search.
 */
-(MiniMax *)initWithDepth:(int) searchDepth andBoard:(Board *)board {
	if (self = [super init]) {
        self.depth = searchDepth;
        self.startBoard = board;
    }
    
	return self; 
}	

-(Move*) bestMove {
    double alpha = -END_GAME_VALUE; //game lost constant value, negative
    double beta  = -alpha;          //game won const value, positive
    
    NSArray* validMoves = [self getValidMovesForBoard:self.startBoard];
    Move* bestMove = nil;
    double bestRank = 0;
    
    for(Move* m in validMoves) {
        
        Board* newBoard = [self makeMoveOnBoard:self.startBoard withMove:m];
        double rank = - [self alphabeta:newBoard withDept:self.depth prevAlpha:alpha prevBeta:beta];
        
        if(bestMove == nil) {
            bestMove = m;
            bestRank = rank;
            continue;
        }
        
        if(rank > bestRank) {
            bestMove = m;
            bestRank = rank;
        }
    }
    
    return bestMove;
}


-(double)alphabeta:(Board *) board withDept:(int)searchDepth prevAlpha:(double)alpha prevBeta:(double)beta {
    
    NSArray* validMoves = [self getValidMovesForBoard:board];
    
    if (searchDepth == 0 || validMoves.count == 0 || board.isGameOver)
        return [self evaluateBoard:board];
    
    for(Move* m in validMoves) {
        Board* newBoard = [self makeMoveOnBoard:board withMove:m];
        double val = - (double) ([self alphabeta:newBoard withDept:searchDepth-1 prevAlpha:-beta prevBeta:-alpha]);
        
        if (val > alpha)
            alpha = val;
        
        if (alpha >= beta) {
            break;  // prune branch.
        }
    }
    
    return alpha;
}

-(NSArray *) getValidMovesForBoard:(Board *) board {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:10];
    int score = 0;
    int size = board.size;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (board.matrix[i][j] == CELL_EMPTY) {
                score = calc_score_at(board.matrix, size, [board nextPlayer], i, j);
                if (score > 0) {
//                    NSLog(@"got score %d at x=%d,y=%d", score, i, j);
                    Move *move = [[Move alloc] initWithX:i AndY:j];
                    move.score = (double)score;
                    [moves addObject:move];
                } else {
//                    NSLog(@"got score %d at x=%d,y=%d, value = %d", score, i, j, board.matrix[i][j]);
                }
            }
        }
    }
    return moves;
}

-(Board *) makeMoveOnBoard:(Board *)board withMove:(Move *) move {
    Board* newBoard = [[Board alloc] initWithSize:board.size AndBoard:board.matrix];
    [newBoard makeMove:[board otherPlayer:board.lastPlayer] At:move];
    return newBoard;
}


-(double) evaluateBoard: (Board *) board {    
    //if the game is finished, check who won
    if(board.isGameOver) {
        if (board.lastPlayer == [self.startBoard nextPlayer]) {
            return END_GAME_VALUE;
        } else {
            return -END_GAME_VALUE;
        }
    }
    
    Move *last = [board lastMove];
    return calc_score_at(board.matrix, board.size, [board lastPlayer], last.x, last.y);
}

@end

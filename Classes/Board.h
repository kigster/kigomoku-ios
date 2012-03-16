//
//  Board.h
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"

#define CELL_EMPTY 0 // nothing in the cell
#define CELL_BLACK 1 // first player 
#define CELL_WHITE 2 // second player

#define GOMOKU_PLAYERS 2
#define GOMOKU_REQUIRED_TO_WIN 5

@interface Board : NSObject {
	int size;
	// two dimensional int array filled with values above.
	int **matrix;
    int moveCount;
    int lastPlayer;
    Move *lastMove;
}

@property(nonatomic) int size;
@property(nonatomic) int lastPlayer;
@property(nonatomic) int moveCount;
@property(nonatomic) int** matrix;
@property(strong, nonatomic) Move* lastMove;

typedef int (^MatrixDirection)(int,int, BOOL*);

- (Board *)initWithSize: (int)size;
- (Board *)initWithSize: (int)size AndBoard:(int **)matrix;
- (void) makeMove:(int) color At:(Move *) move;
- (void) undoMove:(int) color At:(Move *) move;
- (BOOL) isMoveValid:(Move *) move;
- (BOOL) isGameOver;
- (BOOL) walkTheBoard: (MatrixDirection) block;
- (void) deallocMatrix;
- (int) otherPlayer: (int)player;
- (int) nextPlayer;
- (void) updateLastPlayer;
@end

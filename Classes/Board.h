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

#define GOMOKU_BOARD_SIZE 10
#define GOMOKU_PLAYERS 2
#define GOMOKU_REQUIRED_TO_WIN 5

@interface Board : NSObject {
	int size;
	// two dimensional int array filled with values above.
	int **matrix;
}

@property(nonatomic) int size;
@property(nonatomic) int** matrix;

typedef int (^MatrixDirection)(int,int, BOOL*);

- (Board *)initWithSize: (int)size;
- (void) makeMove:(int) color At:(Move *) move;
- (BOOL) isMoveValid:(Move *) move;
- (BOOL) isGameOver;
- (BOOL) walkTheBoard: (MatrixDirection) block;

@end

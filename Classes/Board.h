//
//  Board.h
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoveByPlayer.h"

#define CELL_EMPTY       0 // nothing in the cell
#define CELL_BLACK_OR_X  1 // first player 
#define CELL_WHITE_OR_O -1 // second player

#define GOMOKU_PLAYERS 2
#define GOMOKU_REQUIRED_TO_WIN 5

typedef struct {
    int minX;
    int maxX;
    int minY;
    int maxY;
} Range;


@interface Board : NSObject {
	int size;
	// two dimensional int array filled with values above.
	int **matrix;
    int moveCount;
    int lastPlayerValue;
    
    Move *lastMove;
    Range range;
    NSMutableArray *winningMoves;
}

@property(nonatomic) int size;
@property(nonatomic) Range range;

@property(nonatomic) int lastPlayerValue;
@property(nonatomic) int moveCount;
@property(nonatomic) int** matrix;
@property(strong, nonatomic) Move* lastMove;
@property(strong, nonatomic) NSMutableArray* winningMoves;

typedef int (^MatrixDirection)(int,int, BOOL*, MoveByPlayer *);
- (Board *)initWithSize: (int)size;
- (Board *)initWithSize: (int)size AndMatrix:(int **)matrix;
- (void) reinitialize;
- (void) makeMove:(Move *) move;
- (void) undoMove:(Move *) move;
- (BOOL) isMoveValid:(Move *) move;
- (BOOL) isGameOver;
- (int) winnerPlayer; 
- (BOOL) isFilled;
- (int) playerValueByIndex:(int) playerIndex;
- (int) nextPlayerValue;
- (void) doAdvanceToNextPlayer;
- (void) updateRange;

@end

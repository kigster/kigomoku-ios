//
//  Board.m
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "Board.h"

@interface Board(hidden)
- (BOOL) walkTheBoard: (MatrixDirection) block;
- (void) logMatrix;
- (int) playerIndexByValue:(int) playerValue;
- (void) deallocMatrix;
-(void) resetRange;
-(void) updateRangeForMove: (Move *) move;
@end

@implementation Board

@synthesize size;
@synthesize lastPlayerValue;
@synthesize matrix;
@synthesize moveCount;
@synthesize winningMoves;
@synthesize lastMove;
@synthesize range;

-(Board *)initWithSize: (int)thisSize {
	if (self = [super init]) { 
        self.size = thisSize;
        [self reinitialize];
	} 
	NSLog(@"initialized %@", self);
	return self; 
}	

// reinit
-(void) reinitialize {
    self.lastPlayerValue = CELL_EMPTY;
    self.lastMove = nil;
    self.winningMoves = nil;
    [self resetRange];
    [self deallocMatrix];
    [self allocMatrix];
    self.moveCount = 0;
}

-(void) resetRange {
    range.maxX = range.maxY = 0;
    range.minX = range.minY = self.size - 1;
}

-(void) updateRangeForMove: (Move *) move {
    range.minX = MIN(range.minX, move.x);
    range.maxX = MAX(range.maxX, move.x);
    range.minY = MIN(range.minY, move.y);
    range.maxY = MAX(range.maxY, move.y);
}

-(void) updateRange {
    [self resetRange];
    int i,j;
    Move *move = [[Move alloc] initWithX:0 andY:0];
    for (i = 0; i < self.size; i++) {
        for (j = 0; j < self.size; j++) {
            move.x = i; move.y = j;
            [self updateRangeForMove:move];
        }
    }
}

- (NSString *)description {
	return [NSString stringWithFormat:@"size[%d] moveCount[%d] lastPlayer[%d] lastMove[%@]", 
            self.size,
            self.moveCount,
            self.lastPlayerValue,
            self.lastMove];
}

// 
// Initialize the Board from a pre-existing integer matrix
//
// Sets up the internal state (such as next player) based on move counts
// by each opponent.
//
- (Board *)initWithSize: (int)thisSize AndMatrix:(int **) thatMatrix {
    if (self = [self initWithSize:thisSize]) {
        for (int i = 0; i < self.size; i++) {
            for (int j = 0; j < self.size; j++) {
                self.matrix[i][j] = thatMatrix[i][j];
                if (self.matrix[i][j] != CELL_EMPTY) {
                    moveCount++;
                    [self doAdvanceToNextPlayer];
                }
            }
        }
    }
    return self;
}

- (int) playerValueByIndex:(int) playerIndex {
    if (playerIndex == 0) return CELL_BLACK_OR_X;
    if (playerIndex == 1) return CELL_WHITE_OR_O;
    return CELL_EMPTY;
}

- (int) playerIndexByValue:(int) playerValue {
    if (playerValue == CELL_BLACK_OR_X) return 0;
    if (playerValue == CELL_WHITE_OR_O) return 1;
    else return -1; // this should blow up 
}

- (int) nextPlayerValue {
    return (self.moveCount % 2 == 0) ? CELL_BLACK_OR_X : CELL_WHITE_OR_O;
}

- (void) doAdvanceToNextPlayer {
    self.lastPlayerValue = [self nextPlayerValue];
}


-(void) undoMove:(Move *) move {
    self.matrix[move.x][move.y] = CELL_EMPTY;
    self.moveCount --;
    self.winningMoves = nil;
    [self updateRange];
    [self doAdvanceToNextPlayer];
}


-(void) makeMove:(Move *) move {
	self.matrix[move.x][move.y] = [self nextPlayerValue];
    [self updateRangeForMove:move];
    self.moveCount ++;
    self.lastMove = move;
    self.winningMoves = nil;
   [self doAdvanceToNextPlayer];
}


- (BOOL) isMoveValid:(Move *) move {
    if (move.x < 0 || move.x >= size || move.y < 0 || move.y >= size) {
        return NO;
    }
    return (self.matrix[move.x][move.y] == CELL_EMPTY);
}



- (BOOL) walkTheBoard: (MatrixDirection) block {
    
    int i,j;
    BOOL continuous;
    for (i = 0; i < self.size; i++) {
        int lastValue = CELL_EMPTY;
        int lastValueCount = 0;
        
        for (j = 0; j < self.size; j++) {
            continuous = TRUE;
            int currentValue = block(i,j, &continuous, nil);
            if (lastValue != CELL_EMPTY && continuous == TRUE && lastValue == currentValue) {
                lastValueCount ++;
                if (lastValueCount == GOMOKU_REQUIRED_TO_WIN) {
                    self.winningMoves = [NSMutableArray arrayWithCapacity:GOMOKU_PLAYERS];
                    for (int x = j; x >= 0 && j - x < GOMOKU_REQUIRED_TO_WIN ; x--) {
                        MoveByPlayer *move = [[MoveByPlayer alloc] init];
                        block(i,x, &continuous, move);
                        [self.winningMoves addObject:move];
                    }
                    //NSLog(@"found five in a row!");                    
                    return YES;
                }
            } else {
                lastValue = currentValue;
                lastValueCount = 1;
            }
        }
    }
    self.winningMoves = nil;
    return NO;
}

- (BOOL) isFilled {
    return (moveCount == size * size);
}

- (int) winnerPlayer {
    if (self.winningMoves != nil) 
        return [self playerValueByIndex:[[self.winningMoves objectAtIndex:0] playerIndex]];
    return CELL_EMPTY;
}

- (BOOL) isGameOver {

    MatrixDirection horizontalWalk = ^(int i, int j, BOOL *continuous, MoveByPlayer *move) {
        *continuous = TRUE;
        int value = self.matrix[i][j];
        if (move != nil) {
            move.x = i; move.y = j; move.playerIndex = [self playerIndexByValue:value];
        }
        return value;
    };
    MatrixDirection verticalWalk =  ^(int i, int j, BOOL *continuous, MoveByPlayer *move) {
        *continuous = TRUE;
        int value = self.matrix[j][i];
        if (move != nil) {
            move.x = j; move.y = i; move.playerIndex = [self playerIndexByValue:value];
        }
        return value;
    };
    MatrixDirection diagonalWalkLeftRight =  ^(int i, int j, BOOL *continuous, MoveByPlayer *move) {
        int index = (i + j) % self.size;
        if (index == 0) {
            *continuous = FALSE;
        }
        int value = self.matrix[index][j];
        if (move != nil) {
            move.x = index; move.y = j; move.playerIndex = [self playerIndexByValue:value];
        }
        return value;
    };
    MatrixDirection diagonalWalkRightLeft =  ^(int i, int j, BOOL *continuous, MoveByPlayer *move) {
        int index = ((i - j) < 0) ? self.size + i - j : (i - j);
        if ((index + 1) == self.size) {
            *continuous = FALSE;
        }
        int value = self.matrix[index][j];
        if (move != nil) {
            move.x = index; move.y = j; move.playerIndex = [self playerIndexByValue:value];
        }
        return value;
    };
    
    return ([self walkTheBoard: horizontalWalk]         || 
            [self walkTheBoard: verticalWalk]           ||
            [self walkTheBoard: diagonalWalkLeftRight]  ||
            [self walkTheBoard: diagonalWalkRightLeft] );
}


-(void) allocMatrix {
    if (matrix != NULL) [self deallocMatrix];
    matrix = malloc(self.size * sizeof(int *));
    for (int i = 0; i < self.size; i++) {
        matrix[i] = calloc(self.size, sizeof(int)); // Assumes CELL_EMPTY == 0
    }
}

-(void) deallocMatrix {
    if (matrix != NULL) {
        for(int i = 0; i < self.size; i++)
            free(self.matrix[i]);
        free(self.matrix);
    }

	self.matrix = NULL;
}

- (void)dealloc {
    [self deallocMatrix];
}



@end

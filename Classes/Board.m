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
@end

@implementation Board
@synthesize size;
@synthesize lastPlayerValue;
@synthesize matrix;
@synthesize moveCount;
@synthesize winningMoves;
@synthesize lastMove;

-(Board *)initWithSize: (int)thisSize {
	if (self = [super init]) { 
		self.size = thisSize;
        self.lastPlayerValue = CELL_EMPTY;
        self.lastMove = nil;
        self.winningMoves = nil;
		self.matrix = malloc(self.size * sizeof(int *));
		// TODO: check for NULL?
		for(int i = 0; i < self.size; i++) {
			self.matrix[i] = malloc(self.size * sizeof(int));
			// TODO: check for NULL
			for (int j = 0; j < self.size; j++) {
				self.matrix[i][j] = CELL_EMPTY;
			}
		}
        self.moveCount = 0;
	} 
	NSLog(@"initialized %@", self);
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

- (void) advanceNextPlayer {
    self.lastPlayerValue = [self nextPlayerValue];
}


-(void) undoMove:(Move *) move {
    self.matrix[move.x][move.y] = CELL_EMPTY;
    self.moveCount --;
    self.winningMoves = nil;

    [self advanceNextPlayer];
}

-(void) makeMove:(Move *) move {
	// update the board at move.x, move.y
	if (move.x < 0 || move.x >= self.size || move.y < 0 || move.y >= self.size) {
		NSLog(@"invalid move parameters %@ by player index %d", move, [self nextPlayerValue]);
		return;
	}
	// else all is good.
	self.matrix[move.x][move.y] = [self nextPlayerValue];
    self.moveCount ++;
    self.lastMove = move;

    [self advanceNextPlayer];
#ifdef PRINT_DEBUG    
    [self logMatrix];
#endif
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
                    NSLog(@"found five in a row!");                    
                    return YES;
                }
            } else {
                lastValue = currentValue;
                lastValueCount = 1;
            }
        }
    }
    return NO;
}

- (BOOL) isFilled {
    return (moveCount == size * size);
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


- (NSString *)description {
	// TODO: provide toString that dumps the full board using space, O and X characters
	return [NSString stringWithFormat:@"Board of Size %d", self.size];
}


-(void) deallocMatrix {
	for(int i = 0; i < self.size; i++)
		free(self.matrix[i]);
	free(self.matrix);
	self.matrix = NULL;
}

- (void)dealloc {
    [self deallocMatrix];
}

// used in tests
-(void) logMatrix {
    for (int y = 0; y < size; y++) {
        NSString *row = @"";
        for (int x = 0; x < size; x++ ) {
            NSString *cell;
            if (self.matrix[x][y] == CELL_EMPTY) {
                cell = @".";
            } else if (self.matrix[x][y] == CELL_BLACK_OR_X) {
                cell = @"x";
            } else if (self.matrix[x][y] == CELL_WHITE_OR_O) {
                cell = @"o";
            } else {
                cell = @"#";
            }
            row = [row stringByAppendingString:cell];
        }
        NSLog(@"%@", row);
    }
}


- (Board *)initWithSize: (int)thisSize AndBoard:(int **) thatMatrix {
    if (self = [self initWithSize:thisSize]) {
        for (int i = 0; i < self.size; i++) {
            for (int j = 0; j < self.size; j++) {
                self.matrix[i][j] = thatMatrix[i][j];
                if (self.matrix[i][j] != CELL_EMPTY) {
                    moveCount++;
                    [self advanceNextPlayer];
                }
            }
        }
    }
    return self;
}


@end

//
//  Board.m
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "Board.h"

@implementation Board
@synthesize size;
@synthesize matrix;

-(Board *)initWithSize: (int)thisSize {
	if (self = [super init]) { 
		self.size = thisSize;
		self.matrix = malloc(self.size * sizeof(int *));
		// TODO: check for NULL?
		for(int i = 0; i < self.size; i++) {
			self.matrix[i] = malloc(self.size * sizeof(int));
			// TODO: check for NULL
			for (int j = 0; j < self.size; j++) {
				self.matrix[i][j] = CELL_EMPTY;
			}
		}
	} 
	NSLog(@"initialized %@", self);
	return self; 
}	
	
-(void) makeMove:(int) color At:(Move *) move {
	//NSLog(@"received move to %d %@", color, move);
	// update the board at move.x, move.y
	if (move.x < 0 || move.x >= self.size || move.y < 0 || move.y >= self.size) {
		NSLog(@"invalid move parameters %@ with color %d", move, color);
		return;
	}
	// else all is good.
	self.matrix[move.x][move.y] = color;
}

- (BOOL) isMoveValid:(Move *) move {
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
            int currentValue = block(i,j, &continuous);
            if (lastValue != CELL_EMPTY && continuous == TRUE && lastValue == currentValue) {
                lastValueCount ++;
                if (lastValueCount == GOMOKU_REQUIRED_TO_WIN) {
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


- (BOOL) isGameOver {

    MatrixDirection horizontalWalk = ^(int i, int j, BOOL *continuous) {
        *continuous = TRUE;
        return self.matrix[i][j];
    };
    MatrixDirection verticalWalk =  ^(int i, int j, BOOL *continuous) {
        *continuous = TRUE;
        return self.matrix[j][i];
    };
    MatrixDirection diagonalWalkLeftRight =  ^(int i, int j, BOOL *continuous) {
        int index = (i + j + 1) % self.size;
        if (index == 1 && (i + j + 1) > self.size) {
            *continuous = FALSE;
        }
        return self.matrix[index][j];
    };
    MatrixDirection diagonalWalkRightLeft =  ^(int i, int j, BOOL *continuous) {
        int index = ((i - j) < 0) ? self.size + i - j : (i - j);
        if ((index + 1) == self.size) {
            *continuous = FALSE;
        }
        return self.matrix[index][j];
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


- (void)dealloc {
	for(int i = 0; i < self.size; i++)
		free(self.matrix[i]);
	free(self.matrix);
	self.matrix = NULL;
    [super dealloc];
}


@end

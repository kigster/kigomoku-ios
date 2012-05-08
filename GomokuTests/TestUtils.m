//
//  TestUtils.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/7/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "TestUtils.h"


@interface TestUtils(hidden)
-(void) allocMatrix;
-(void) deallocMatrix;
@end


@implementation TestUtils


@synthesize size;
@synthesize matrix;


- (TestUtils *) initWithSize:(int) boardSize {
	if (self = [super init]) {
        self.size = boardSize;
        [self allocMatrix];
	}
	return self;
}


- (void) verifyExpectation:(char *) array 
               description:(NSString *) description {
    
    NSMutableArray *goodMoves = [[NSMutableArray alloc ]initWithCapacity:10];
    NSMutableArray *badMoves = [[NSMutableArray alloc ]initWithCapacity:10];

    [self fillBoard:matrix 
             ofSize:size 
      fromCharArray:array 
          goodMoves:goodMoves 
           badMoves:badMoves];
    
    int moveX = -1, moveY = -1;
    int result = pick_next_move(matrix, 
                                size,
                                CELL_BLACK_OR_X,  // next move is by X
                                &moveX, 
                                &moveY);

    STAssertTrue((result == RT_SUCCESS), @"expecting successful pick of the next move");
    
    Move *theirMove = [[Move alloc] initWithX:moveX andY:moveY];
    BOOL containsGoodMove = [goodMoves containsObject:theirMove] ;
    BOOL containsBadMove = [badMoves containsObject:theirMove] ;
     
    if (goodMoves.count > 0) {
        STAssertTrue(containsGoodMove, @"move %@ is not correct, not one of expected moves [%@]", theirMove, description);
    } 
    if (badMoves.count > 0) {
        for (Move *move in badMoves) {
            STFail(@"test expected not to make a move: %@", move);
        }
        STAssertFalse(containsBadMove, @"move %@ is not correct for %@, this is a bad move", theirMove, description);
    }
}


- (void)compareBoards:(int **)boardLeft
            withBoard:(int **)boardRight {
    for (int i = 0; i < size; i++ ) {
        for (int j = 0; j < size; j++ ) {
            STAssertTrue(boardLeft[i][j] == boardRight[i][j], 
                         @"boards mismatch at column [%d] row [%d], expected [%d] got [%d]", 
                         i, j, boardLeft[i][j], 
                         boardRight[i][j]);
        }
    }
}

-(void) fillBoard:(int **)board 
           ofSize:(int) bSize 
    fromCharArray:(char *) array
        goodMoves:(NSMutableArray *)goodMoves
         badMoves:(NSMutableArray *)badMoves  {
    
    for (int y = 0; y < bSize; y++) {
        for(int x = 0; x < bSize; x++) {
            char value = array[y * bSize + x];
            switch(value) {
                case 'X': {
                    board[x][y] = CELL_BLACK_OR_X;
                    break;
                }
                case 'O': {
                    board[x][y] = CELL_WHITE_OR_O;
                    break;
                }
                case '*': {
                    Move *move = [[Move alloc] initWithX:x andY:y];
                    [goodMoves addObject:move];
                    board[x][y] = CELL_EMPTY;
                    break;
                }
                case '#': {
                    Move *move = [[Move alloc] initWithX:x andY:y];
                    [badMoves addObject:move];
                    board[x][y] = CELL_EMPTY;
                    break;
                }
                default: {
                    board[x][y] = CELL_EMPTY;
                    break;
                }
            }
        }
    }    
}

-(void) allocMatrix {
    if (matrix != NULL) [self deallocMatrix];
    
    matrix = malloc(size * sizeof(int *));
    for(int i = 0; i < size; i++) {
        matrix[i] = calloc(size, sizeof(int));
    }
}

-(void) deallocMatrix {
    if (matrix == NULL) return;
    for(int i = 0; i < size; i++) free(matrix[i]); 
    free(matrix);
    matrix = NULL;
}

-(void)dealloc {
    [self deallocMatrix];
}

@end

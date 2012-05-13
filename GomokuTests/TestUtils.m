//
//  TestUtils.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/7/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "TestUtils.h"

@implementation TestUtils

@synthesize board;

- (TestUtils *) initWithSize:(int) size {
	if (self = [super init]) {
        self.board = [[Board alloc] initWithSize:size];
	}
	return self;
}


- (TestUtils *) initWithBoard: (Board *) thatBoard {
	if (self = [super init]) {
        self.board = thatBoard;
	}
	return self;
}


- (void) verifyExpectation:(char *) array 
               description:(NSString *) description {
    
    NSMutableArray *goodMoves = [[NSMutableArray alloc ]initWithCapacity:10];
    NSMutableArray *badMoves = [[NSMutableArray alloc ]initWithCapacity:10];

    [self fillBoard:board
      fromCharArray:array 
          goodMoves:goodMoves 
           badMoves:badMoves];
    
    int moveX = -1, moveY = -1;
    int result = pick_next_move(board.matrix, 
                                board.size,
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
            withBoard:(int **)boardRight
               ofSize:(int) size {
    for (int i = 0; i < size; i++ ) {
        for (int j = 0; j < size; j++ ) {
            STAssertTrue(boardLeft[i][j] == boardRight[i][j], 
                         @"boards mismatch at column [%d] row [%d], expected [%d] got [%d]", 
                         i, j, boardLeft[i][j], 
                         boardRight[i][j]);
        }
    }
}

- (void) fillBoard:(Board *) thatBoard
     fromCharArray:(char *) array {

    [self fillBoard:thatBoard
      fromCharArray:array
          goodMoves:nil
           badMoves:nil];
}


- (void) fillBoard:(Board *) thatBoard
    fromCharArray:(char *) array
        goodMoves:(NSMutableArray *)goodMoves
         badMoves:(NSMutableArray *)badMoves  {

    for (int y = 0; y < thatBoard.size; y++) {
        for(int x = 0; x < thatBoard.size; x++) {
            char value = array[y * thatBoard.size + x];
            Move *move = [[Move alloc] initWithX:x andY:y];
            thatBoard.matrix[x][y] = CELL_EMPTY;
            switch(value) {
                case 'X': {
                    thatBoard.matrix[x][y] = CELL_BLACK_OR_X;
                    [thatBoard doAdvanceToNextPlayer];
                    break;
                }
                case 'O': {
                    thatBoard.matrix[x][y] = CELL_WHITE_OR_O;
                    [thatBoard doAdvanceToNextPlayer];
                    break;
                }
                case '*': {
                    [goodMoves addObject:move];
                    break;
                }
                case '#': {
                    [badMoves addObject:move];
                }
            }
        }
    }    
    
    [thatBoard updateRange];
    // NSLog(@"board filled %@", thatBoard);
}

- (void) logCurrentBoard {
    [self logBoard:board];
}

-(void) logBoard:(Board *) thatBoard {
    for (int y = 0; y < thatBoard.size; y++) {
        NSString *row = @"";
        for (int x = 0; x < thatBoard.size; x++ ) {
            NSString *cell;
            if (thatBoard.matrix[x][y] == CELL_EMPTY) {
                cell = @".";
            } else if (thatBoard.matrix[x][y] == CELL_BLACK_OR_X) {
                cell = @"x";
            } else if (thatBoard.matrix[x][y] == CELL_WHITE_OR_O) {
                cell = @"o";
            } else {
                cell = @"#";
            } 
            row = [row stringByAppendingString:cell];
        }
        NSLog(@"%@", row);
    }
}


@end

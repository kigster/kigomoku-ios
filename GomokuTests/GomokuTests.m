//
//  GomokuTests.m
//  GomokuTests
//
//  Created by Konstantin Gredeskoul on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GomokuTests.h"
#import "Move.h"

void free_board(int **board, int size);
int **make_board(int size);


void free_board(int **board, int size) {
    for(int i = 0; i < size; i++) free(board[i]); 
    free(board);
}

int **make_board(int size) {
    int **board = malloc(size * sizeof(int *));
    for(int i = 0; i < size; i++) {
        board[i] = malloc(size * sizeof(int));
        for (int j = 0; j < size; j++) {
            board[i][j] = EMPTY; 
        }
    }
    return board;
}


int ** board;
int size = 7;


@implementation GomokuTests

-(void) fillBoard:(int **)board 
           ofSize:(int) size 
    fromCharArray:(char *) array
        findMoves:(NSMutableArray *)moves {
    
    for (int y = 0; y < size; y++) {
        for(int x = 0; x < size; x++) {
            char value = array[y * size + x];
            switch(value) {
                case 'X': {
                    board[x][y] = 1;
                    break;
                }
                case 'O': {
                    board[x][y] = 2;
                    break;
                }
                case '*': {
                    Move *move = [[Move alloc] initWithX:x AndY:y];
                    [moves addObject:move];
                    break;
                }
                default: {
                    board[x][y] = EMPTY;
                    break;
                }
            }
        }
    }    
}

- (void) verifyCorrectMove:(int **)board
                    ofSize:(int) size
             fromCharArray:(char *) array 
               description:(NSString *) description {
    
    NSMutableArray *expectedMoves = [[NSMutableArray alloc ]initWithCapacity:10];
    [self fillBoard:board ofSize:size fromCharArray:array findMoves:expectedMoves];
    int moveX = -1, moveY = -1;

    int result = pick_next_move(board, 
                                size,
                                1, 
                                &moveX, 
                                &moveY);
    
    STAssertTrue((result == RT_SUCCESS), 
                 @"expecting successful pick of the next move");
    Move *theirMove = [[Move alloc] initWithX:moveX AndY:moveY];

    BOOL contains = [expectedMoves containsObject:theirMove];

    NSLog(@"==============> %@", description);
    NSLog(@"AI move was %@", theirMove);
    for (Move *move in expectedMoves) {
        NSLog(@"test expected move: %@", move);
    }
    STAssertTrue(contains, 
                 @"move %@ is not correct for %@", theirMove, description);
}
                

- (void)setUp {
    [super setUp];
    board = make_board(size);
}

- (void)tearDown {
    [super tearDown];
    free_board(board, size);
}

- (void)testStraightFour{
    // expected 
    char *boardWithOpenFour = 
    "......."
    ".*....."
    ".X....."
    ".X....."
    ".X....."
    ".X....."
    ".*....."
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithOpenFour
                description:@"open four on two sides"];

}

- (void)testRegularFour{
    char *boardWithFour = 
    ".O....."
    ".X....."
    ".X....."
    ".X....."
    ".X....."
    ".*....."
    "......."
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
                description:@"closed four on one side"];
}

- (void)testThree{
    char *boardWithFour = 
    "......."
    ".*XXX*."
    "......."
    "......."
    "......."
    "......."
    "......."
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
                description:@"open three on one side"];
}

@end






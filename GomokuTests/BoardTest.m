//
//  BoardTest.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/6/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "BoardTest.h"
#import "GomokuTests.h"
#import "Board.h"

@implementation BoardTest

@synthesize board;

#define BOARD_SIZE 10

- (void)setUp {
    [super setUp];
    self.board = [[Board alloc] initWithSize:BOARD_SIZE];
}

- (void)tearDown {
    [super tearDown];
    self.board = nil;
}

- (void)testMakeMove{
    STAssertFalse([board isFilled], @"board should not be filled");
    STAssertFalse([board isGameOver], @"game should not be over");
    STAssertTrue([board nextPlayerValue] == CELL_BLACK_OR_X,  @"first player is X");
    Move *move = [[Move alloc] initWithX:0 andY:0];
    STAssertTrue([board isMoveValid:move], @"move should be valid");
    [board makeMove:move];
    STAssertTrue([board nextPlayerValue] == CELL_WHITE_OR_O,  @"second player should be O, %d", [board nextPlayerValue]);
}



@end

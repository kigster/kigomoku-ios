//
//  AlphaBetaTest.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/6/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "AlphaBetaTest.h"

@implementation AlphaBetaTest

@synthesize board;
@synthesize pruner;

#define BOARD_SIZE 10

- (void)setUp {
    [super setUp];
    self.board = [[Board alloc] initWithSize:BOARD_SIZE];
    self.pruner = [[AlphaBetaPruner alloc] initWithBoard:board];
}

- (void)tearDown {
    [super tearDown];
    self.board = nil;
}

- (void)testEvaluateBoard{
    Move *first = [[Move alloc] initWithX:3 andY:3];
    [board makeMove:first];
    double score = [pruner evaluateBoard:[board nextPlayerValue]];
    STAssertTrue(score < 0, @"score should be > 0, score = %.5f", score);
}

@end

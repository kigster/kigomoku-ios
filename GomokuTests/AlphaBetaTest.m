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
@synthesize testUtils;

#define BOARD_SIZE 7

- (void)setUp {
    [super setUp];
    self.board = [[Board alloc] initWithSize:BOARD_SIZE];
    self.pruner = [[AlphaBetaPruner alloc] initWithBoard:board];
    self.testUtils = [[TestUtils alloc] initWithBoard:board];
}

- (void)tearDown {
    [super tearDown];
    self.board = nil;
}

- (void)testEvaluateBoard {
    [board makeMove:[[Move alloc] initWithX:3 andY:3]];
    [board makeMove:[[Move alloc] initWithX:2 andY:3]];
    
    double score = [pruner evaluateBoard:[board nextPlayerValue]];
    STAssertTrue(score < 0, @"score should be > 0, score = %.5f", score);
}

- (void)testEvaluate {
    
    char *gameSetup1 = 
        "......."
        "......."
        "......."
        "...XX.."
        "....O.."
        "......."
        ".......";

    [testUtils fillBoard:board 
           fromCharArray:gameSetup1];
    
    [testUtils logCurrentBoard];
    double score = [pruner evaluateBoard:[board nextPlayerValue]];
    NSLog(@"board %@ score=[%.3f] for player %d", board, score, [board nextPlayerValue]);
    STAssertTrue(score < 0, @"score should be > 0, score = %.5f", score);

}



@end

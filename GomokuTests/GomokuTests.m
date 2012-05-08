//
//  GomokuTests.m
//  GomokuTests
//
//  Created by Konstantin Gredeskoul on 2/4/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "GomokuTests.h"
#import "Move.h"
#import "Board.h"

#import "basic_ai.h"

#define LOCAL_BOARD_SIZE 7

@implementation GomokuTests
@synthesize testUtils;

- (void)setUp {
    [super setUp];
    testUtils = [[TestUtils alloc] initWithSize:LOCAL_BOARD_SIZE];
}

- (void)tearDown {
    [super tearDown];
    testUtils = nil;
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
    ".*.....";
    
    [testUtils verifyExpectation:boardWithOpenFour
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
    ".......";
    
    [testUtils verifyExpectation:boardWithFour
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
    "......."    ;
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"open three on one side"];
}

- (void)testStraightFourDiagonalTopBottom{
    char *boardWithFour = 
    "......."
    ".*....."
    "..X...."
    "...X..."
    "....X.."
    ".....X."
    "......*"    ;
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"open four on both sides diagonal top to bottom"];
}

- (void)testStraightFourDiagonalBottomTop{
    char *boardWithFour = 
    ".....*."
    "....X.."
    "...X..."
    "..X...."
    ".X....."
    "*......"
    ".......";
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"open four on both sides diagonal bottom to top"];
}

- (void)testStraightFourDiagonalWithHole{
    char *boardWithFour = 
    "......."
    "......."
    "......."
    "XX*XX.."
    "......."
    "......."
    ".......";
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"open four on both sides diagonal bottom to top"];
}

- (void)testClosedFour{
    char *boardWithFour = 
    "......."
    "......."
    "......."
    "#OOOX.."
    "......."
    "......."
    "......."
    ;
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"closed four not useful"];
}

- (void)testThreeAndThreeVsOpenThree{
    // make sure AI chooses to close the enemy's open three
    // instead of advancing it's own 3x3
    char *boardWithFour = 
    //   0123456
        "......." // 0
        "......." // 1
        ".....*." // 2
        "...*.O." // 3
        "..XX.O." // 4
        ".X.X.O." // 5
        ".....*." // 6
    ;
    
    [testUtils verifyExpectation:boardWithFour
                     description:@"three vs three against four"];
}


- (void)testBoardDetectsWin{
    char *boardWithWin = 
    "......."
    "X......"
    ".X....."
    "XOXOX.."
    "...X..."
    "....X.."
    "..XXX.."
    ;
    
    Board *b = [[Board alloc] initWithSize:LOCAL_BOARD_SIZE];

    [testUtils fillBoard:b
           fromCharArray:boardWithWin
               goodMoves:nil 
                badMoves:nil];
    
    STAssertTrue([b isGameOver], @"game should be over");
}

- (void)testStraightFourDiagonalWithHoleOneDimension {
    // this is equivalent to ..XX.XX...
    int row[11] = { -1, -1, -1, 1, 1, 0, 1, 1, -1, -1, -1 };
    int cost = calc_threat_in_one_dimension(row, 1);
    STAssertTrue( (cost == THREAT_FIVE),  @"hole not detected, expected cost %d, got %d", THREAT_THREE, cost);
}
- (void)testStraightFourDiagonalWithHoleOneDimensionFromRight {
    // this is equivalent to XX.XX...
    int row[11] = { 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0 };
    int cost = calc_threat_in_one_dimension(row, 1);
    STAssertTrue( (cost == THREAT_THREE), @"hole not detected, expected cost %d, got %d", THREAT_THREE, cost);
}

- (void)testStraightFourClosed {
    // this is equivalent to 0.XXX0...
    int row[11] = { -1, -1, -1, -1, -1, 0, 1, 1, 1, -1, 0 };
    int cost = calc_threat_in_one_dimension(row, 1);
    STAssertTrue( (cost == THREAT_NEAR_ENEMY), @"worthless combo got cost %d", cost);
}

@end






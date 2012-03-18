//
//  GomokuTests.m
//  GomokuTests
//
//  Created by Konstantin Gredeskoul on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GomokuTests.h"
#import "Move.h"
#import "Board.h"
#import "basic_ai.h"

void free_board(int **board, int size);
int **make_board(int size);


void free_board(int **board, int size) {
    for(int i = 0; i < size; i++) free(board[i]); 
    free(board);
    board = NULL;
}

int **make_board(int size) {
    int **board = malloc(size * sizeof(int *));
    for(int i = 0; i < size; i++) {
        board[i] = malloc(size * sizeof(int));
        for (int j = 0; j < size; j++) {
            board[i][j] = CELL_EMPTY; 
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
        goodMoves:(NSMutableArray *)goodMoves
         badMoves:(NSMutableArray *)badMoves  {
    
    for (int y = 0; y < size; y++) {
        for(int x = 0; x < size; x++) {
            char value = array[y * size + x];
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

- (void) verifyCorrectMove:(int **)board
                    ofSize:(int) size
             fromCharArray:(char *) array 
               description:(NSString *) description {
    
    NSMutableArray *goodMoves = [[NSMutableArray alloc ]initWithCapacity:10];
    NSMutableArray *badMoves = [[NSMutableArray alloc ]initWithCapacity:10];
    [self fillBoard:board 
             ofSize:size 
      fromCharArray:array 
          goodMoves:goodMoves 
           badMoves:badMoves];
    
    int moveX = -1, moveY = -1;

    int result = pick_next_move(board, 
                                size,
                                CELL_BLACK_OR_X,  // next move is by X
                                &moveX, 
                                &moveY);
    STAssertTrue((result == RT_SUCCESS), 
                 @"expecting successful pick of the next move");
    
    Move *theirMove = [[Move alloc] initWithX:moveX andY:moveY];

    BOOL containsGoodMove = [goodMoves containsObject:theirMove] ;
    BOOL containsBadMove = [badMoves containsObject:theirMove] ;

    NSLog(@"AI move was %@, for %@", theirMove, description);
    for (Move *move in goodMoves) {
        NSLog(@"test expected move: %@", move);
    }
    if (goodMoves.count > 0) {
        STAssertTrue(containsGoodMove, @"move %@ is not correct, not one of expected moves [%@]", theirMove, description);
    } 
    if (badMoves.count > 0) {
        for (Move *move in badMoves) {
            NSLog(@"test expected not to make a move: %@", move);
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

- (void)testStraightFourDiagonalTopBottom{
    char *boardWithFour = 
    "......."
    ".*....."
    "..X...."
    "...X..."
    "....X.."
    ".....X."
    "......*"
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
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
    "......."
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
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
    "......."
    ;
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
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
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
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
    
    [self verifyCorrectMove:board ofSize:size fromCharArray:boardWithFour
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
    
    [self fillBoard:board 
             ofSize:size 
      fromCharArray:boardWithWin
          goodMoves:nil 
           badMoves:nil];
    
    Board *b = [[Board alloc] initWithSize:7];
    [b deallocMatrix];
    b.matrix = board;
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

//- (void)testBoardInitWithBoard {
//    char *thisBoard = 
//    "......."
//    ".X....."
//    ".OOO..."
//    " OXXXX."
//    ".O....."
//    "......."
//    "......."
//    ;
//    
//    [self fillBoard:board 
//             ofSize:size 
//      fromCharArray:thisBoard
//          goodMoves:nil 
//           badMoves:nil];
//    
//    Board *b = [[Board alloc] initWithSize:7 AndBoard:board];
//    b.lastPlayer = CELL_WHITE;
//    [self compareBoards:board withBoard:b.matrix];
//    STAssertTrue([b lastPlayer] == CELL_WHITE, 
//                 @"last player is not black, [%d]", [b lastPlayer]);
//
//    populate_threat_matrix();
//    
//    MiniMax *minimax = [[MiniMax alloc] initWithDepth:3 andBoard:b];
//    NSArray *moves = [minimax getValidMovesForBoard:b];
//    NSLog(@"moves: %@", moves);
//    STAssertTrue([moves count] > 0, @"valid moves is empty");
//}

@end






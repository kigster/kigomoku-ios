//
//  TestUtils.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/7/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "Board.h"
#import "Config.h"

#import "basic_ai.h"
#import <stdlib.h>
#import <SenTestingKit/SenTestingKit.h>

@interface TestUtils : SenTestCase {
@private    
    Board *board;
}

@property (strong, nonatomic) Board *board;

-(TestUtils *) initWithSize:(int) size;
-(TestUtils *) initWithBoard:(Board *)board;

- (void)verifyExpectation:(char *) array
              description:(NSString *)desc;

- (void)compareBoards:(int **)boardLeft
            withBoard:(int **)boardRight
               ofSize:(int) size;

- (void) fillBoard:(Board *) thatBoard
     fromCharArray:(char *) array;

- (void)fillBoard:(Board *) thatBoard
    fromCharArray:(char *) array
        goodMoves:(NSMutableArray *)goodMoves 
         badMoves:(NSMutableArray *)badMoves ;

- (void) logBoard:(Board *) thatBoard;

- (void) logCurrentBoard;

@end

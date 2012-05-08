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
    int size;   
    int **matrix;
}

@property(nonatomic) int size;
@property(nonatomic) int ** matrix;

-(TestUtils *) initWithSize:(int) boardSize;

-(void) verifyExpectation:(char *) array
              description:(NSString *)desc;

- (void)compareBoards:(int **)boardLeft
            withBoard:(int **)boardRight;

-(void) fillBoard:(int **) board 
           ofSize:(int) bSize 
    fromCharArray:(char *) array
        goodMoves:(NSMutableArray *)goodMoves 
         badMoves:(NSMutableArray *)badMoves ;


@end

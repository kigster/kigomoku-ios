//
//  GomokuTests.h
//  GomokuTests
//
//  Created by Konstantin Gredeskoul on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface GomokuTests : SenTestCase

-(void) fillBoard:(int **)board 
           ofSize:(int) size 
    fromCharArray:(char *) array
        goodMoves:(NSMutableArray *)goodMoves 
         badMoves:(NSMutableArray *)badMoves  ;

- (void) verifyCorrectMove:(int **) board
                    ofSize:(int) size
             fromCharArray:(char *) array
               description:(NSString *)desc;
@end

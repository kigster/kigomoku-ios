//
//  AlphaBetaTest.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/6/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Board.h"
#import "AlphaBetaPruner.h"

@interface AlphaBetaTest : SenTestCase {
    Board *board;
    AlphaBetaPruner *pruner;
}

@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) AlphaBetaPruner *pruner;

@end

//
//  BoardTest.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/6/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Board.h"

@interface BoardTest : SenTestCase {
	Board *board;
@private
}

@property (strong, nonatomic) Board *board;

@end

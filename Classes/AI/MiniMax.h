//
//  MiniMax.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/14/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"
#import "Board.h"
#import "basic_ai.h"

#define END_GAME_VALUE 1000000

@interface MiniMax : NSObject {
    int depth;
    Board *startBoard;
}

@property(nonatomic) int depth;
@property(strong, nonatomic) Board *startBoard;

-(MiniMax *)initWithDepth:(int) depth andBoard:(Board *) board;
-(double)alphabeta:(Board *)board withDept:(int)depth prevAlpha:(double)alpha prevBeta:(double)beta;
-(Move*) bestMove;
-(NSArray *) getValidMovesForBoard:(Board *) board;
-(double) evaluateBoard: (Board *) board;
-(Board *) makeMoveOnBoard:(Board *) board withMove:(Move *) move;
@end

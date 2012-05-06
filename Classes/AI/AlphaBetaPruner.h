//
//  AlphaBetaPruner.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "MyBest.h"

@interface AlphaBetaPruner : NSObject {
    Board *board;
    int maxDepth;
    int player;
}

@property(strong, nonatomic) Board *board;
@property(nonatomic) int maxDepth;
@property(nonatomic) int player;

-(AlphaBetaPruner *)initWithBoard: (Board *) board;
-(AlphaBetaPruner *)initWithBoard: (Board *) board 
                   andSearchDepth: (int) depth;

-(MyBest *)chooseMove;

-(MyBest *)chooseMoveFor:(int) player 
             withDepth:(int) depth 
              andAlpha:(double) alpha 
               andBeta:(double) beta;


@end

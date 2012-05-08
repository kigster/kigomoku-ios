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
    int computerPlayer;
}

@property(strong, nonatomic) Board *board;
@property(nonatomic) int maxDepth;
@property(nonatomic) int computerPlayer;

-(AlphaBetaPruner *)initWithBoard: (Board *) board;
-(AlphaBetaPruner *)initWithBoard: (Board *) board 
                   andSearchDepth: (int) depth
                andComputerPlayer: (int) computer;

-(double) evaluateBoard:(int) playerValue;

-(MyBest *)chooseMove;

-(MyBest *)chooseMoveFor:(int) player 
             withDepth:(int) depth 
              andAlpha:(double) alpha 
               andBeta:(double) beta;

@end

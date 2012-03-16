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
    long count;
}

@property(strong, nonatomic) Board *board;
@property(nonatomic) long count;

-(AlphaBetaPruner *)initWithBoard:(Board *) board;

-(MyBest *)chooseMoveFor:(int) player 
             withDepth:(int) depth;

-(MyBest *)chooseMoveFor:(int) player 
             withDepth:(int) depth 
              andAlpha:(double) alpha 
               andBeta:(double) beta;


@end

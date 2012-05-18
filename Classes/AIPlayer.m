//
//  UIPlayer.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "AIPlayer.h"
#import "AlphaBetaPruner.h"
#import "MyBest.h"

@implementation AIPlayer

@synthesize game;

-(AIPlayer *)initWithGame:(Game *) thisGame { 
	if (self = [super init]) { 
		self.game = thisGame;
	} 
	return self; 
} 

- (void) beginTurn {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AlphaBetaPruner *ai = [[AlphaBetaPruner alloc] initWithBoard:self.game.board];
        MyBest *myBest = [ai chooseMove]; 
        if (myBest != nil) {
            NSLog(@"AI made move [%@]", myBest);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self game] makeMove: myBest.move];
            });
        } else {
            NSLog(@"AI failed and returned a nil move");
        }
    });

}




@end

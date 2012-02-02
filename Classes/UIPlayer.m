//
//  UIPlayer.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "UIPlayer.h"

@implementation UIPlayer

@synthesize game;

-(UIPlayer *)initWithGame:(Game *) thisGame { 
	if (self = [super init]) { 
		self.game = thisGame;
	} 
	return self; 
} 

- (void) startThinking {
	// notifies the view that it should switch into user entry mode
	// view must be able to 
}

- (void) stopThinking {
}

- (void) makeMove: (Move *) move {	
	// pass through
	// [game makeMove:move];
}


- (void) dealloc { 
	[game release]; 
	[super dealloc]; 
} 


@end

//
//  UIPlayer.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Game.h"
#import "Move.h"

@interface AIPlayer : NSObject <Player> {
	Game *game;
}

-(AIPlayer *)initWithGame:(Game *)thisGame; 

@property(nonatomic, strong) Game *game;

@end

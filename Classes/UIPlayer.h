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

@interface UIPlayer : NSObject <Player> {
	Game *game;
}

-(UIPlayer *)initWithGame:(Game *)thisGame; 

@property(nonatomic, retain) Game *game;

@end

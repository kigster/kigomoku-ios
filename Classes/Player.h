//
//  Player.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Move.h"


@protocol Player

- (void) startThinking;
- (void) stopThinking;
- (void) makeMove: (Move *) move;
- (void) game;

@end

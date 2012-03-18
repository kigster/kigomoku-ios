//
//  MoveByPlayer.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/18/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "Move.h"

@interface MoveByPlayer : Move {
	int playerIndex; // 0 = first, 1 = second
}

@property (nonatomic) int playerIndex;

- (Move *) initWithX: (int) xCoordinate 
                andY: (int) yCoordinate  
      andPlayerIndex:(int) thisPlayerIndex;

- (MoveByPlayer *) initWithMove:(Move *) move
                 andPlayerIndex:(int) thisPlayerIndex;
@end

//
//  MoveByPlayer.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/18/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "MoveByPlayer.h"

@implementation MoveByPlayer
@synthesize playerIndex;

- (MoveByPlayer *) initWithX: (int) xCoordinate 
                        andY: (int) yCoordinate  
              andPlayerIndex: (int) thisPlayerIndex {
	self = [super initWithX:xCoordinate andY:yCoordinate];
	if (self) {
		[self setPlayerIndex:thisPlayerIndex];
	}
	return self;
}

- (MoveByPlayer *) initWithMove:(Move *) move
                 andPlayerIndex:(int) thisPlayerIndex {
    return [self initWithX:move.x andY:move.y andPlayerIndex:thisPlayerIndex];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Move(x:%d y:%d playerIndex:%d)", self.x, self.y, self.playerIndex];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToMoveByPlayer:((MoveByPlayer *)other)];
}

- (BOOL)isEqualToMoveByPlayer:(MoveByPlayer *)aMove {
    if (self == aMove)
        return YES;
    if (self.x != aMove.x || self.y != aMove.y || self.playerIndex != aMove.playerIndex)
        return NO;
    return YES;
}

@end

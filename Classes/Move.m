//
//  Move.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "Move.h"


@implementation Move

@synthesize x;
@synthesize y;
@synthesize score;

- (Move *) initWithX: (int) xCoordinate AndY: (int) yCoordinate {
	self = [super init];
	if (self) {
		[self setX:xCoordinate];
		[self setY:yCoordinate];
        self.score = 0;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Move(x:%d y:%d, score:%.2f)", self.x, self.y, self.score];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToMove:((Move *)other)];
}

- (BOOL)isEqualToMove:(Move *)aMove {
    if (self == aMove)
        return YES;
    if (self.x != aMove.x || self.y != aMove.y)
        return NO;
    return YES;
}

@end

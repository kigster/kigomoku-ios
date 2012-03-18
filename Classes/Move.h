//
//  Move.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Move : NSObject {
	int x;
	int y;
}

@property (nonatomic) int x;
@property (nonatomic) int y;

- (Move *) initWithX: (int) xCoordinate andY: (int) yCoordinate;
- (BOOL)isEqualToMove:(Move *)aMove;

@end

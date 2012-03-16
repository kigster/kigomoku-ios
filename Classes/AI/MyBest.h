//
//  MyBest.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"

@interface MyBest : NSObject {
    Move *move;
    double score;
}

@property(strong, nonatomic) Move *move;
@property(nonatomic) double score;


@end

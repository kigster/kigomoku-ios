//
//  MyBest.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 3/15/12.
//  Copyright (c) 2012 LeftCtrl Labs. All rights reserved.
//

#import "MyBest.h"

@implementation MyBest
@synthesize move;
@synthesize score;

-(MyBest *)init {
    if (self = [super init]) {
        self.move = nil;
        self.score = 0;
    }
	return self; 
}

- (NSString *)description {
	return [NSString stringWithFormat:@"MyBest{%@, score = %.6f}", move, score];
}

@end

//
//  Config.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 2/2/12.
//  Copyright (c) 2012 ModCloth Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject {
    int boardSize;
}

@property(nonatomic, assign) int boardSize;

@end


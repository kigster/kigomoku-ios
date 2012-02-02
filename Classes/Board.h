//
//  Board.h
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Move.h"

#define CELL_EMPTY 0
#define CELL_BLACK 1
#define CELL_WHITE 2

@interface Board : NSObject {
	int size;
	// two dimensional int array filled with values above.
	int **matrix;
}

@property(nonatomic) int size;
@property(nonatomic) int** matrix;

-(Board *)initWithSize: (int)size;
-(void) makeMove:(int) color At:(Move *) move;

@end

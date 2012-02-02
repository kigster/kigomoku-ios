//
//  Board.m
//  Gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import "Board.h"

@implementation Board
@synthesize size;
@synthesize matrix;

-(Board *)initWithSize: (int)thisSize {
	if (self = [super init]) { 
		self.size = thisSize;
		self.matrix = malloc(self.size * sizeof(int *));
		// TODO: check for NULL?
		for(int i = 0; i < self.size; i++) {
			self.matrix[i] = malloc(self.size * sizeof(int));
			// TODO: check for NULL
			for (int j = 0; j < self.size; j++) {
				self.matrix[i][j] = 0;
			}
		}
	} 
	NSLog(@"initialized %@", self);
	return self; 
}	
	
-(void) makeMove:(int) color At:(Move *) move {
	NSLog(@"received move to %d %@", color, move);
	// update the board at move.x, move.y
	if (move.x < 0 || move.x >= self.size || move.y < 0 || move.y >= self.size) {
		NSLog(@"invalid move parameters %@ with color %d", move, color);
		return;
	}
	// else all is good.
	self.matrix[move.x][move.y] = color;
}


- (NSString *)description {
	// TODO: provide toString that dumps the full board using space, O and X characters
	return [NSString stringWithFormat:@"Board of Size %d", self.size];
}


- (void)dealloc {
	for(int i = 0; i < self.size; i++)
		free(self.matrix[i]);
	free(self.matrix);
	self.matrix = NULL;
    [super dealloc];
}


@end

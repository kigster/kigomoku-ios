
#import "HumanPlayer.h"

@implementation HumanPlayer

@synthesize game;

-(HumanPlayer *)initWithGame:(Game *) thisGame { 
	if (self = [super init]) { 
		self.game = thisGame;
	} 
	return self; 
} 

- (void) beginTurn {
}




@end

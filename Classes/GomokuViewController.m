//
//  gomokuViewController.m
//

#import "GomokuViewController.h"
#import "Player.h"
#import "UIPlayer.h"
#import "Game.h"


@implementation GomokuViewController

@synthesize gameBoardController;
@synthesize game;

- (IBAction) startSinglePlayerGame:(id) sender {
	[self startGameWithPlayers:1];
}

- (IBAction) startTwoPlayerGame:(id) sender {
	[self startGameWithPlayers:2];
}

- (void) startGameWithPlayers: (int) playerCount {
	if (game != NULL) { 
		[game release];
        game = NULL;
	}
	
	game = [[Game alloc] initGame];
    game.delegate = gameBoardController;
	
	[game addPlayer:[[[UIPlayer alloc] initWithGame:game] autorelease]];
	[game addPlayer:[[[UIPlayer alloc] initWithGame:game] autorelease]];
	[game startGame];
    
	NSLog(@"created game with players: %@", self.game);
	[self.navigationController pushViewController:gameBoardController animated:YES];
    [gameBoardController initBoard];
}

- (void) makeMove: (Move *) move {
    if ([self.game isMoveValid:move]) {
        [self.game makeMove:move];
    }
}

- (void)dealloc {
	[gameBoardController release];
	[game release];
    [super dealloc];
}

@end

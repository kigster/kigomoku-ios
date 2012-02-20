//
//  Game.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//

#import "Game.h"
#import "UIPlayer.h"
#import "basic_ai.h"


@implementation Game

@synthesize players;
@synthesize moves;
@synthesize redoMoves;
@synthesize currentPlayerIndex;
@synthesize board;
@synthesize config;
@synthesize gameStarted;
@synthesize delegate;


- (Game *) initGameWithConfig: (Config *)gameConfig {
	if (self = [super init]) {
        self.config = gameConfig;
		self.players = [[NSMutableArray alloc] initWithCapacity:GOMOKU_PLAYERS];
        self.moves = [[NSMutableArray alloc] initWithCapacity:GOMOKU_PLAYERS];
        for (int i = 0; i < GOMOKU_PLAYERS; i++) {
            [self.moves addObject: [[NSMutableArray alloc] initWithCapacity:20]];
            [self.redoMoves addObject: [[NSMutableArray alloc] initWithCapacity:20]];
        }
		self.board = [[Board alloc] initWithSize:[config boardSize]];
		self.gameStarted = NO;
        self.currentPlayerIndex = 0;
	}
	return self;
}

- (void) addPlayer:(id <Player>) player{
	if ([self.players count] < GOMOKU_PLAYERS) {
        [self.players addObject:player];
    } else {
        NSLog(@"already have enough players!");
    }
}

- (void) startGame {
    if ([self.players count] != GOMOKU_PLAYERS) {
        NSLog(@"not enough players added!");
        return;
    }
	self.gameStarted = YES;
	NSLog(@"starting %@", self);
	// call first player
}

- (id<Player>) player:(int) index {
	if (index < [self.players count])
		return [self.players objectAtIndex:index];
	else
		return nil;
}

- (Move *) lastMove {
    Move *undoMove = [[self.moves objectAtIndex:[self otherPlayerColor]] lastObject];
    return undoMove;
}

- (void) undoLastMove {
    if (self.board.moveCount > 0) {
        [self moveToNextPlayer];
        
        Move *undoMove = [[self.moves objectAtIndex:currentPlayerIndex] lastObject];
        [[self.moves objectAtIndex:currentPlayerIndex] removeObject:undoMove];

        [board undoMove:currentPlayerIndex At:undoMove];
        [delegate undoMove:undoMove byPlayer:currentPlayerIndex];
        if (self.gameStarted == NO) {
            self.gameStarted = YES;
        }
    }
}

- (void) makeMove: (Move *) move {
    if (self.gameStarted != YES) {
        NSLog(@"game is not started, can't make this move %@", move);
        return;
    }
    if ([self isMoveValid:move] == YES) {
        // add move to the history
        [[self.moves objectAtIndex:currentPlayerIndex] addObject:move];

        // save the move
        [board makeMove:[self currentPlayerColor] At:move]; 

        int playerJustMoved = self.currentPlayerIndex;
        // change current player    
        [self moveToNextPlayer];
        
        // update the UI
        [delegate moveMade:move byPlayer:playerJustMoved];

        if ([board isGameOver]) {
            [delegate gameOverWithWinner:currentPlayerIndex];
            self.gameStarted = NO;
        }


    } else {
        NSLog(@"move %@ is NOT valid, ignored", move);
    }
	return;
}

- (void) moveToNextPlayer {
    self.currentPlayerIndex = [self otherPlayerColor];
}

- (int) otherPlayerColor {
    return (self.currentPlayerIndex + 1) % GOMOKU_PLAYERS;
}

- (BOOL) isMoveValid:(Move *)move {
    return [self.board isMoveValid:move];
}

- (void) stopGame {
	gameStarted = NO;
	NSLog(@"stopping %@", self);
}

- (int) currentPlayerColor {
    return self.currentPlayerIndex + 1;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"game: player1:%@, player2:%@, board:%@", 
			[self player:0], 
			[self player:1], 
			 self.board];
}

@end

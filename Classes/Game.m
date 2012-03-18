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

- (MoveByPlayer *) lastMove {
    return [[self.moves objectAtIndex:[self otherPlayerIndex]] lastObject];
}

- (NSMutableArray *) moveHistory {
    NSMutableArray *moveHistory = [NSMutableArray arrayWithCapacity:50];
    for (int moveIndex = [[self.moves objectAtIndex:currentPlayerIndex] count]; moveIndex >= 0; moveIndex --) {
        for (int i = 0; i <= 1; i++) {
            int playerIndex = (currentPlayerIndex + i) % GOMOKU_PLAYERS;
            if ([[self.moves objectAtIndex:playerIndex] count] > moveIndex) {
                [moveHistory addObject:[[self.moves objectAtIndex:playerIndex] objectAtIndex: moveIndex]];
            }
        }
    }
    return moveHistory;
}

- (void) undoLastMove {
    if (self.board.moveCount > 0) {
        // remove from the UI
        [delegate undoLastMove];

        [self advanceToNextPlayer];
        
        Move *undoMove = [[self.moves objectAtIndex:currentPlayerIndex] lastObject];
        [[self.moves objectAtIndex:currentPlayerIndex] removeObject:undoMove];

        [board undoMove:undoMove];
        
        if (self.gameStarted == NO) {
            self.gameStarted = YES;
        }
        
        // refresh UI with the current move
        [delegate didMakeMove];
    }
}

- (void) makeMove: (Move *) move {
    if (self.gameStarted != YES) {
        NSLog(@"game is not started, can't make this move %@", move);
        return;
    }
    
    if ([self isMoveValid:move] == YES) {
        [delegate aboutToMakeMove];
        MoveByPlayer *playerMove;
        if (![move isKindOfClass:[MoveByPlayer class]]) {
            playerMove = [[MoveByPlayer alloc] initWithMove:move andPlayerIndex:currentPlayerIndex];
        } else {
            playerMove = (MoveByPlayer *) move;
            playerMove.playerIndex = currentPlayerIndex;
        }
        
        // add move to the history
        [[moves objectAtIndex:currentPlayerIndex] addObject:playerMove];

        // update the game board state
        [board makeMove:playerMove]; 

        // change current player    
        [self advanceToNextPlayer];

        // update the UI
        [delegate didMakeMove];

        if ([board isGameOver]) {
            [delegate gameOver];
            self.gameStarted = NO;
        }
    } else {
        NSLog(@"move %@ is NOT valid, ignored", move);
    }
	return;
}

- (void) advanceToNextPlayer {
    self.currentPlayerIndex = [self otherPlayerIndex];
}

- (int) otherPlayerIndex {
    return (self.currentPlayerIndex + 1) % GOMOKU_PLAYERS;
}

- (BOOL) isMoveValid:(Move *)move {
    return [self.board isMoveValid:move];
}

- (void) stopGame {
	gameStarted = NO;
	NSLog(@"stopping %@", self);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"game: player1:%@, player2:%@, board:%@", 
			[self player:0], 
			[self player:1], 
			 self.board];
}

@end

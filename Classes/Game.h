//
//  Game.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/3/10.
//  Copyright 2010 Konstantin Gredeskoul, shared under MIT license.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Board.h"

#define GOMOKU_BOARD_SIZE 19
#define GOMOKU_PLAYERS 2

@protocol GameDelegate

- (void) moveMade:(Move *) move byPlayer:(int) playerIndex;
- (void) gameOverWithWinner:(int) playerIndex;

@end


@interface Game : NSObject {
	NSMutableArray *players;
	NSMutableArray *moves;
	int currentPlayerIndex;
	Board *board;
@private
	BOOL gameStarted;
}

@property (nonatomic, retain) id<GameDelegate> delegate;

@property (nonatomic, assign) NSMutableArray *players;
@property (nonatomic, assign) NSMutableArray *moves;
@property (nonatomic, assign) int currentPlayerIndex;
@property (nonatomic, assign) Board *board;
@property (nonatomic, assign) BOOL gameStarted;

- (Game *) initGame;
- (void) addPlayer:(id <Player>) player;
- (id<Player>) player:(int) index;
- (void) makeMove: (Move *) move;
- (BOOL) isMoveValid: (Move *) move;
- (void) startGame;
- (void) stopGame;
@end

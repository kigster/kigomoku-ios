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
#import "Config.h"
#import "MoveByPlayer.h"


@protocol GameDelegate
- (void) aboutToMakeMove;
- (void) didMakeMove;
- (void) undoLastMove;
- (void) gameOver;
@end


@interface Game : NSObject {
	NSMutableArray *players;
	NSMutableArray *moves;
    NSMutableArray *redoMoves;
	int currentPlayerIndex;         // first player: 0,             second player 1, etc.
	Board *board;
    Config *config;
@private
	BOOL gameStarted;
}

@property (strong, nonatomic) id<GameDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) NSMutableArray *moves;
@property (strong, nonatomic) NSMutableArray *redoMoves;
@property (nonatomic)         int currentPlayerIndex;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) Config *config;
@property (nonatomic)         BOOL gameStarted;

- (Game *) initGameWithConfig: (Config *)config;
- (void) addPlayer:(id <Player>) player;
- (id<Player>) currentPlayer;
- (void) makeMove: (Move *) move;
- (MoveByPlayer *) lastMove;
- (NSMutableArray *) moveHistory;
- (void) undoLastMove;
- (BOOL) isMoveValid: (Move *) move;
- (BOOL) startGame;
- (void) stopGame;
- (int) otherPlayerIndex;
- (void) advanceToNextPlayer ;
@end

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


@protocol GameDelegate

- (void) moveMade:(Move *) move byPlayer:(int) playerIndex;
- (void) gameOverWithWinner:(int) playerIndex;

@end


@interface Game : NSObject {
	NSMutableArray *players;
	NSMutableArray *moves;
	int currentPlayerIndex;
	Board *board;
    Config *config;
@private
	BOOL gameStarted;
}

@property (strong, nonatomic) id<GameDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) NSMutableArray *moves;
@property (nonatomic)         int currentPlayerIndex;
@property (strong, nonatomic) Board *board;
@property (strong, nonatomic) Config *config;
@property (nonatomic)         BOOL gameStarted;

- (Game *) initGameWithConfig: (Config *)config;
- (void) addPlayer:(id <Player>) player;
- (id<Player>) player:(int) index;
- (void) makeMove: (Move *) move;
- (BOOL) isMoveValid: (Move *) move;
- (void) startGame;
- (void) stopGame;
- (int) currentPlayerColor;
@end

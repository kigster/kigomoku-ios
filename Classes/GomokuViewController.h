//
//  gomokuViewController.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import <UIKit/UIKit.h>
#import "GameBoardViewController.h"
#import "Game.h"
#import "Move.h"

@interface GomokuViewController : UIViewController{
	GameBoardViewController* gameBoardController;
	Game *game;
}

@property(nonatomic, retain) GameBoardViewController *gameBoardController;
@property(nonatomic, assign) Game *game;

- (IBAction) startSinglePlayerGame:(id) sender;
- (IBAction) startTwoPlayerGame:(id) sender;
- (void) startGameWithPlayers: (int) playerCount;
- (void) makeMove: (Move *) move;

@end


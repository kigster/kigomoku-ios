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
#import "Player.h"
#import "AIPlayer.h"
#import "HumanPlayer.h"

@interface GomokuViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
	GameBoardViewController* gameBoardController;
	Game *game;
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *boardSizes;
    Config *config;
}

@property(strong, nonatomic) GameBoardViewController *gameBoardController;
@property(strong, nonatomic) Game *game;
@property(strong, nonatomic) Config *config;
@property(strong, nonatomic) NSMutableArray *boardSizes;
@property(strong, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction) startTwoPlayerGame:(id) sender;
- (void) startGameWithPlayers: (int) playerCount;
- (void) makeMove: (Move *) move;

@end


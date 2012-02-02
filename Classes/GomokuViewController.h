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

@interface GomokuViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
	GameBoardViewController* gameBoardController;
	Game *game;
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *boardSizes;
    Config *config;
}

@property(nonatomic, retain) GameBoardViewController *gameBoardController;
@property(nonatomic, assign) Game *game;
@property(nonatomic, retain) Config *config;
@property(nonatomic, assign) NSMutableArray *boardSizes;
@property(nonatomic, retain) IBOutlet UIPickerView *pickerView;

- (IBAction) startSinglePlayerGame:(id) sender;
- (IBAction) startTwoPlayerGame:(id) sender;
- (void) startGameWithPlayers: (int) playerCount;
- (void) makeMove: (Move *) move;

@end


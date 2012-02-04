//
//  gomokuViewController.m
//

#import "GomokuViewController.h"
#import "Player.h"
#import "UIPlayer.h"
#import "Game.h"
#import "basic_ai.h"


@implementation GomokuViewController

@synthesize gameBoardController;
@synthesize game;
@synthesize pickerView;
@synthesize boardSizes;
@synthesize config;


- (IBAction) startSinglePlayerGame:(id) sender {
	[self startGameWithPlayers:1];
}

- (IBAction) startTwoPlayerGame:(id) sender {
	[self startGameWithPlayers:2];
}

- (void) startGameWithPlayers: (int) playerCount {
	if (game != nil) { 
        game = nil;
	}
	
	game = [[Game alloc] initGameWithConfig:config];
    game.delegate = gameBoardController;
	
	[game addPlayer:[[UIPlayer alloc] initWithGame:game]];
	[game addPlayer:[[UIPlayer alloc] initWithGame:game]];
	[game startGame];
    
	NSLog(@"created game with players: %@", self.game);
	[self.navigationController pushViewController:gameBoardController animated:YES];
    [gameBoardController initBoardWithGame:game];
}

- (void) makeMove: (Move *) move {
    if ([self.game isMoveValid:move]) {
        [self.game makeMove:move];
        
        if (self.game.currentPlayerIndex == 1 && self.game.gameStarted) {
            int moveX, moveY = 0;
            NSLog(@"making AI move");
            int result = pick_next_move(self.game.board.matrix, self.game.config.boardSize,
                                        self.game.currentPlayerIndex + 1, 
                                        &moveX, &moveY) ;
            NSLog(@"made AI move with result %d, x=%d, y=%d", result, moveX, moveY);
            if (result == 0) {
                [self makeMove:[[Move alloc] initWithX:moveX AndY:moveY]];
            }
        }
    } else {
        NSLog(@"move %@ is NOT valid, ignoring...", move);
    }
}

-(void)viewDidLoad {
    if (![self config]) 
        self.config = [[Config alloc] init];
    
    self.config.boardSize = 15;
    
    [super viewDidLoad];
    boardSizes = [[NSMutableArray alloc] initWithCapacity:3];
    [boardSizes addObject:@"15 x 15"];
    [boardSizes addObject:@"10 x 10"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES  animated:YES];
}

#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1 ;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [boardSizes count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [boardSizes objectAtIndex:row];
}


#pragma mark UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"selected board size: %@. Index of selected color: %i", [boardSizes objectAtIndex:row], row);
    NSString *label = [boardSizes objectAtIndex:row];
    self.config.boardSize = label.intValue;
}


@end

//
//  GameBoardViewController.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import <UIKit/UIKit.h>
#import "BoardCell.h"
#import "Game.h"

#define MAX_CELL_WIDTH 60.0

@interface GameBoardViewController : UIViewController <UIScrollViewDelegate, 
    BoardCellDelegate, GameDelegate> {
    Game *game;
	UIScrollView *boardScrollView;
	UIView *boardView;
	NSMutableArray *cells;
    UIBarButtonItem *undoButton;
    UIBarButtonItem *redoButton;
    id mainController;
}

@property(nonatomic, strong) Game *game;
@property(nonatomic, strong) id mainController;

@property(nonatomic, strong) UIView *boardView;
@property(nonatomic, strong) NSMutableArray *cells;
@property(nonatomic, strong) NSMutableArray *cellImages;
@property(nonatomic, strong) UIBarButtonItem *undoButton;
@property(nonatomic, strong) UIBarButtonItem *redoButton;

@property(nonatomic, strong) IBOutlet UIScrollView *boardScrollView;
@property(nonatomic, strong) IBOutlet UILabel *gameStatus;

- (void) initBoardWithGame:(Game *)game;
- (void) undoRedoMove:(id) sender;


@end

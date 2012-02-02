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

@interface GameBoardViewController : UIViewController <UIScrollViewDelegate, BoardCellDelegate, GameDelegate> {
	UIScrollView *boardScrollView;
	UIView *boardView;
	NSMutableArray *cells;
	id mainController;
}

@property(nonatomic, retain) IBOutlet UIScrollView *boardScrollView;
@property(nonatomic, retain) UIView *boardView;
@property(nonatomic, retain) NSMutableArray *cells;
@property(nonatomic, retain) id mainController;
@property(nonatomic, retain) NSMutableArray *cellImages;

@property (nonatomic, retain) IBOutlet UILabel *gameStatus;

- (void) initBoard;

@end

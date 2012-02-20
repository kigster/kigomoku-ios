//
//  GameBoardViewController.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import "GameBoardViewController.h"
#import "GomokuViewController.h"
#import "Game.h"
#import "Move.h"


@implementation GameBoardViewController

@synthesize boardScrollView;
@synthesize boardView;
@synthesize cells;
@synthesize mainController;
@synthesize cellImages;
@synthesize gameStatus;
@synthesize game;
@synthesize undoButton;
@synthesize redoButton;


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
	//[[self navigationItem] setTitle:@"Some Title"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) initBoardWithGame:(Game *) newGame {
    self.game = newGame;
    int boardSize = self.game.config.boardSize;

    if (self.boardView != nil) {
        self.boardView.hidden = TRUE;
        self.boardView = nil;
    }
    
    self.boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boardSize * MAX_CELL_WIDTH, 
                                                               boardSize * MAX_CELL_WIDTH)];
    
    [self.gameStatus setText:@"Game Starting!"];
    if (self.cellImages == NULL) {
        // lets load board cells of all 3 states
        self.cellImages = [[NSMutableArray alloc] initWithCapacity:(GOMOKU_PLAYERS + 1)];
        NSString *fileName;
        NSString *cellImageFilePath;
        UIImage *cellImage;
        for (int i = 0; i < (GOMOKU_PLAYERS + 1); i++) {
            fileName = [NSString stringWithFormat:@"BoardSquare_%d", i];
            cellImageFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            cellImage = [[UIImage alloc] initWithContentsOfFile:cellImageFilePath];
            [self.cellImages addObject:cellImage];
        }
    }
	
	self.cells = [NSMutableArray array];
	
	//setup squares of the board
	for (int x = 0; x < boardSize; x++) {
		for (int y = 0; y < boardSize; y++) {
			BoardCell *currentCell = [[BoardCell alloc] initWithFrame:CGRectMake( x * MAX_CELL_WIDTH, 
																				  y * MAX_CELL_WIDTH, 
																				  MAX_CELL_WIDTH, 
																				  MAX_CELL_WIDTH)];
			currentCell.image = [self.cellImages objectAtIndex:CELL_EMPTY];
			currentCell.delegate = self;
			[self.cells addObject:currentCell];
			[self.boardView addSubview:currentCell];
		}
	}
	
	[self.boardScrollView addSubview:self.boardView];
	
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    int viewSize = boardSize * MAX_CELL_WIDTH;
    
	self.boardScrollView.zoomScale = screenWidth / viewSize;
	self.boardScrollView.contentSize = CGSizeMake(viewSize, viewSize);
    
    // create Back button
    undoButton = [[UIBarButtonItem alloc] initWithTitle:@"Undo" 
                                                   style:UIBarButtonItemStylePlain 
                                                  target:self 
                                                  action:@selector(undoRedoMove:)];
    
//    redoButton = [[UIBarButtonItem alloc] initWithTitle:@"Redo" 
//                                                  style:UIBarButtonItemStylePlain 
//                                                 target:self 
//                                                 action:@selector(undoRedoMove:)];
                  
    NSArray *buttons = [NSArray arrayWithObjects: undoButton, redoButton, nil];
	self.navigationItem.rightBarButtonItems = buttons;
}


- (void)viewDidUnload {
    NSLog(@"board view unloading");
	self.boardScrollView = nil;
}

- (void)undoRedoMove:(id)sender {
    if (sender == undoButton) {
        NSLog(@"undo UNDO pressed");
        for (int i = 0; i <= 1; i++) {
            [[self game] undoLastMove];
        }

    } else if (sender == redoButton) {
       NSLog(@"undo redo pressed"); 
    }
}


#pragma mark BoardCellDelegate methods

- (void) selectedBoardCell:(BoardCell *)theCell {
	int index = [self.cells indexOfObject: theCell];
	// calculate the move coordinates
	Move *move = [[Move alloc] initWithX: index / self.game.config.boardSize 
									 AndY: index % self.game.config.boardSize ];
	// pass to the main controller for processing.
    [self.mainController makeMove:move];
}

#pragma mark GameDelegate methods

- (void) moveMade:(Move *) move byPlayer:(int) playerIndex {
    NSLog(@"redrawing cell for playerIndex %d at %@", playerIndex, move);
    BoardCell *cell = [self.cells objectAtIndex:(move.x * self.game.config.boardSize + move.y)];
    cell.image = [self.cellImages objectAtIndex:(playerIndex + 1)];
    NSString *nextPlayer = self.game.currentPlayerIndex == 0 ? @"X" : @"O";
    NSString *status = [NSString stringWithFormat:@"Next move: Player %@", nextPlayer];
    [self.gameStatus setText:status];
}

- (void) undoMove:(Move *) move byPlayer:(int) player {
    BoardCell *cell = [self.cells objectAtIndex:(move.x * self.game.config.boardSize + move.y)];
    cell.image = [self.cellImages objectAtIndex:0];
    NSString *nextPlayer = self.game.currentPlayerIndex == 0 ? @"X" : @"O";
    NSString *status = [NSString stringWithFormat:@"Next move: Player %@", nextPlayer];
    [self.gameStatus setText:status];    
}


- (void) gameOverWithWinner:(int) playerIndex {
    NSString *winner = [self.game otherPlayerColor] == 0 ? @"X" : @"O";
    NSString *status = [NSString stringWithFormat:@"Player '%@' Won Yo!", winner];
    [self.gameStatus setText:status];
    NSLog(@"GAME OVER, player %d won!", playerIndex); 
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return boardView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

@end

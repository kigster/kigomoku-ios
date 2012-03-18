//
//  GameBoardViewController.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import "GameBoardViewController.h"
#import "GomokuViewController.h"
#import "Game.h"
#import "MoveByPlayer.h"

@interface GameBoardViewController(hidden)

- (UIImage *) loadImageFromFile:(NSString *) fileName;
- (void) updateCellImageForMove:(MoveByPlayer *) move
                    highlighted:(BOOL) highlighted
                          empty:(BOOL) empty;
- (void) updateGameStatus;
- (NSString *) currentPlayerMarker;

@end


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
    
    // remove subviews if any
    for(UIView *subview in [self.boardScrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    self.boardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boardSize * MAX_CELL_WIDTH, 
                                                                    boardSize * MAX_CELL_WIDTH)];
    
    [self.gameStatus setText:@"Game Starting!"];
    if (self.cellImages == NULL) {
        // lets load board cells of all 3 states
        self.cellImages = [[NSMutableArray alloc] initWithCapacity:(GOMOKU_PLAYERS + 1)];
        NSString *fileName;
        int i;
        for (i = 0; i <= GOMOKU_PLAYERS; i++) {
            fileName = [NSString stringWithFormat:@"BoardSquare_%d", i];
            [self.cellImages addObject:[self loadImageFromFile:fileName]];
        }
        for (i = 1; i <= GOMOKU_PLAYERS; i++) {
            fileName = [NSString stringWithFormat:@"BoardSquare_%d_glow", i];
            [self.cellImages addObject:[self loadImageFromFile:fileName]];
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
		
    CGFloat viewSize = boardSize * MAX_CELL_WIDTH;    
	self.boardScrollView.contentSize = CGSizeMake(viewSize, viewSize);
    CGFloat zoomScale = self.boardScrollView.frame.size.width / viewSize;
    NSLog(@"resetting view zoom scale to %.2f frame size %.2f", zoomScale, self.boardScrollView.frame.size.width);
	[self.boardScrollView setMinimumZoomScale:zoomScale];
	[self.boardScrollView setMaximumZoomScale:zoomScale * 2];
    [self.boardScrollView setZoomScale:zoomScale animated:NO];
	[self.boardScrollView addSubview:self.boardView];
    
    
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

- (UIImage *) loadImageFromFile:(NSString *) fileName {
    NSString *cellImageFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    return [[UIImage alloc] initWithContentsOfFile:cellImageFilePath];
}

- (void)viewDidUnload {
    NSLog(@"board view unloading");
	self.boardScrollView = nil;
}

- (void)undoRedoMove:(id)sender {
    if (sender == undoButton) {
        int moves_to_undo = 2;
        if ([self game].gameStarted == NO && [self game].currentPlayerIndex == 1
            ) {
            moves_to_undo = 1;
        }
        NSLog(@"undo UNDO pressed, undoing %d moves", moves_to_undo);
        for (int i = 0; i < moves_to_undo; i++) {
            [[self game] undoLastMove];
        }

    } else if (sender == redoButton) {
       NSLog(@"undo redo pressed"); 
    }
}

- (void) updateCellImageForMove:(MoveByPlayer *) move
                    highlighted:(BOOL) highlighted
                          empty:(BOOL) empty{
    if (move == nil) return;
    //NSLog(@"redrawing cell for move %@, highlight? %s", move, highlighted ? "YES" : "NO");
    BoardCell *cell = [self.cells objectAtIndex:(move.x * self.game.config.boardSize + move.y)];
    if (empty)
        cell.image = [self.cellImages objectAtIndex: 0];
    else
        cell.image = [self.cellImages objectAtIndex:(1 + move.playerIndex + (highlighted ? GOMOKU_PLAYERS : 0))];
}

- (void) updateGameStatus {
    NSString *status = [NSString stringWithFormat:@"Next move: Player %@", [self currentPlayerMarker]];
    [self.gameStatus setText:status];    
}

- (NSString *) currentPlayerMarker {
    return self.game.currentPlayerIndex == 0 ? @"X" : @"O";
}

#pragma mark BoardCellDelegate methods

- (void) selectedBoardCell:(BoardCell *)theCell {
	int index = [self.cells indexOfObject: theCell];
	// calculate the move coordinates
	MoveByPlayer *move = [[MoveByPlayer alloc] initWithX: index / self.game.config.boardSize 
                                                    andY: index % self.game.config.boardSize              
                                          andPlayerIndex: self.game.currentPlayerIndex];
    // NSLog(@"UI player clicked on %@", move);
	// pass to the main controller for processing.
    [self.mainController makeMove:move];
}

#pragma mark GameDelegate methods

- (void) aboutToMakeMove {
    [self updateCellImageForMove:[game lastMove] highlighted:NO empty:NO];
}

- (void) didMakeMove {
    [self updateCellImageForMove:[game lastMove] highlighted:YES empty:NO];
    [self updateGameStatus];
}

- (void) undoLastMove {
    if (!self.game.gameStarted) {
        // unhighlight the winning 5
        for (MoveByPlayer *move in [game moveHistory]) {
            [self updateCellImageForMove:move highlighted:NO empty:NO];
        }
    }
    [self updateCellImageForMove:[game lastMove] highlighted:NO empty:YES];
    [self updateGameStatus];
}

- (void) gameOver {
    int winner = game.currentPlayerIndex;
    NSString *status = (winner == 0) ? 
                        @"Doh! You lost :("  :
                        @"Great job! You won :)";
    [self.gameStatus setText:status];
    
    NSArray *winningMoves = self.game.board.winningMoves;
    NSLog(@"got winning moves: %@", winningMoves);
    if (winningMoves != nil) {
        for (MoveByPlayer *m in winningMoves) {
            [self updateCellImageForMove:m highlighted:YES empty:NO];
        }
    }
    
    NSLog(@"GAME OVER, player %d won!", game.currentPlayerIndex); 
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return boardView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

@end

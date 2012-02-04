//
//  BoardCell.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import <UIKit/UIKit.h>

@class BoardCell;

@protocol BoardCellDelegate

- (void) selectedBoardCell:(BoardCell *)theCell;

@end


@interface BoardCell : UIImageView {
	id<BoardCellDelegate> delegate;
}

@property(nonatomic, strong) id<BoardCellDelegate> delegate;

@end

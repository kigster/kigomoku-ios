//
//  BoardCell.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import "BoardCell.h"


@implementation BoardCell

@synthesize delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touches began %@, %@", touches, event);
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touches ended %@, %@", touches, event);
	[super touchesEnded:touches withEvent:event];
	[self.delegate selectedBoardCell:self];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}


//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}




@end

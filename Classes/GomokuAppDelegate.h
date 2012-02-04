//
//  gomokuAppDelegate.h
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
// 

#import <UIKit/UIKit.h>


@class GomokuViewController;

@interface GomokuAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end


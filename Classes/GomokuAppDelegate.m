//
//  gomokuAppDelegate.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import "GomokuAppDelegate.h"
#import "GomokuViewController.h"
#import "GameBoardViewController.h"

@implementation GomokuAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	GomokuViewController *mainController = [[GomokuViewController alloc] initWithNibName:@"GomokuViewController" bundle:nil];
	GameBoardViewController *gameBoardController = [[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil];

    mainController.title = @"New Game";
	mainController.gameBoardController = gameBoardController;
	gameBoardController.mainController = mainController;

    // initialize random number generator
    srand(time(NULL));
	
	navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    [[navController navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    [navController setNavigationBarHidden:YES];

    
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}




@end

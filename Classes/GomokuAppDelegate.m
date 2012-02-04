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
	GomokuViewController *mainController = [[[GomokuViewController alloc] initWithNibName:@"GomokuViewController" bundle:nil] autorelease];
	GameBoardViewController *gameBoardController = [[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] autorelease];

    mainController.title = @"Back to Settings";
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


- (void)dealloc {
	[navController release];
    [window release];
    [super dealloc];
}


@end

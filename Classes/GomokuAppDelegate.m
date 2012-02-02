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

	mainController.gameBoardController = gameBoardController;
	gameBoardController.mainController = mainController;
	
	navController = [[UINavigationController alloc] initWithRootViewController:mainController];
		
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[navController release];
    [window release];
    [super dealloc];
}


@end

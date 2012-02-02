//
//  gomokuViewControllerTest.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//


#import "GTMSenTestCase.h"
#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>
#import <OCMock/OCMock.h>
#import "GomokuViewController.h"

@interface gomokuViewControllerTest : SenTestCase
GomokuViewController *controller;
@end

@implementation gomokuViewControllerTest

- (void) setUp {
	controller = [[GomokuViewController alloc] initWithNibName:@"gomokuViewController" bundle:nil];
	[controller loadView];
}

- (void) tearDown {
	[controller release];
	controller = nil;
}

- (void) testgomokuViewControllerIBOutlets {
	assertThat(controller, notNilValue());
	assertThat(controller.view, notNilValue());
	assertThat(controller.button, notNilValue());
}

- (void) testgomokuViewControllerIBActions {
	assertThat(controller, notNilValue());
	assertThat([controller.button actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside], onlyContains(@"buttonTapped:", nil));
}

@end
//
//  gomokuExampleTest.m
//  gomoku
//
//  Created by Konstantin Gredeskoul on 5/2/10.
//

#import "GTMSenTestCase.h"
#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>
#import <OCMock/OCMock.h>

@interface gomokuExampleTest : SenTestCase
@end

@implementation gomokuExampleTest

- (void) testMethod {
    assertThat(@"foo", is(@"foo"));
    assertThat(@"foo", isNot(@"bar"));
}

- (void) testFailingTest {
	assertThat([NSNumber numberWithInt:5], lessThan([NSNumber numberWithInt:1]));
}

@end

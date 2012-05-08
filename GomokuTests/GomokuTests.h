//
//  GomokuTests.h
//  GomokuTests
//
//  Created by Konstantin Gredeskoul on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "TestUtils.h"

@interface GomokuTests : SenTestCase {
    TestUtils *testUtils;
}

@property(nonatomic) TestUtils *testUtils;

@end

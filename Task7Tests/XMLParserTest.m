//
//  XMLParserTest.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VideoItem.h"

@interface XMLParserTest : XCTestCase
@property (nonatomic, copy) void (^completion)(NSArray<VideoItem *> *, NSError *);

@end

@implementation XMLParserTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCompletion {
//    XCTAssertNotNil(self.completion);
}


@end

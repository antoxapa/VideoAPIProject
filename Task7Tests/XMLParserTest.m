//
//  XMLParserTest.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VideoItem.h"
#import "XMLParser.h"

@interface XMLParserTest : XCTestCase
@property (nonatomic, copy) void (^completion)(NSArray<VideoItem *> *, NSError *);
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) XMLParser *parser;

@end

@implementation XMLParserTest

- (void)setUp {
   
//    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@".xml"];
//    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Mock_XML" ofType:nil];
//    self.data = [NSData dataWithContentsOfFile:filePath];
//    self.parser = [[XMLParser alloc]init];
}

- (void)tearDown {
    
}

- (void)testParseVideo {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"parse_expectation"];
//    [self.parser parseVideo:self.data completion:self.completion];
//    self.completion = ^(NSArray<VideoItem *> *item, NSError *error) {
//        [expectation fulfill];
//    };
//    [self waitForExpectations:@[expectation] timeout:5];
}

@end

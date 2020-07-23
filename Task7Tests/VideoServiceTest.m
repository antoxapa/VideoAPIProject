//
//  VideoServiceTest.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VideoService.h"
#import "XMLParser.h"
#import "ParserProtocol.h"
#import "RLURLSessionMock.h"

@interface VideoServiceTest : XCTestCase

@property (nonatomic, strong) VideoService *videoService;
@property (nonatomic, strong) XMLParser *parser;
@property (nonatomic, strong) NSArray<VideoItem *> *videoArray;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) RLURLSessionMock *mockSession;

@end

@implementation VideoServiceTest

- (void)setUp {
    self.parser = [[XMLParser alloc]init];
    self.videoService = [[VideoService alloc]initWithParser: self.parser];
    self.videoArray = [NSArray array];
    self.mockSession = [[RLURLSessionMock alloc]init];
}

- (void)tearDown {
    self.videoService = nil;
}

- (void)testLoad {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Mock_XML" ofType:nil];
    NSData *mockData = [[NSData alloc]initWithContentsOfFile:filePath];
    self.mockSession.data = mockData;
    self.videoService.session = self.mockSession;
    __block NSData* resultData = nil;
    
    [self.videoService loadDataWithURL:@"random url" completion:^(NSData * data, NSError * error) {
        resultData = data;
    }];
    XCTAssertEqual(mockData, resultData);
}

- (void)testParsing {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Mock_XML" ofType:nil];
    NSData *mockData = [[NSData alloc]initWithContentsOfFile:filePath];
    self.mockSession.data = mockData;
    self.videoService.session = self.mockSession;
    
    [self.videoService parseData:^(NSArray<VideoItem *> * data, NSError * error) {
        XCTAssertTrue(data.count == 2);
    }];
}
@end

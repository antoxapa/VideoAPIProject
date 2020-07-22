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

@interface VideoServiceTest : XCTestCase

@property (nonatomic, strong) VideoService *videoService;
@property (nonatomic, strong) XMLParser *parser;
@property (nonatomic, strong) NSArray<VideoItem *> *videoArray;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *downloadedImage;

@end

@implementation VideoServiceTest

- (void)setUp {
    self.videoService = [[VideoService alloc]initWithParser: self.parser];
    self.videoArray = [NSArray array];
    self.url = @"https://pi.tedcdn.com/r/pe.tedcdn.com/images/ted/e98a047229351dbda3f53fb5a70102f2daf48c4d_800x600.jpg?w=615&amp;h=461";
    self.downloadedImage = [[UIImage alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//- (void)testLoad {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"load_expectation"];
//    [self.videoService loadVideo:^(NSArray<VideoItem *> *array, NSError *error) {
//        self.videoArray = array;
//        [expectation fulfill];
//    }];
//    [self waitForExpectations:@[expectation] timeout:10];
//    XCTAssertTrue(self.videoArray.count > 0);
//}

- (void)testDownloadImage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"download_expectation"];
    [self.videoService downloadImgeForURL:self.url completion:^(UIImage * image, NSError * error) {
        self.downloadedImage = image;
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:1];
    XCTAssertNotNil(self.downloadedImage);
//    xcassert
}

@end

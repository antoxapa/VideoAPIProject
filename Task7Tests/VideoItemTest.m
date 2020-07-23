//
//  VideoItemTest.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VideoItem.h"

@interface VideoItemTest : XCTestCase
@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, strong) NSDictionary *mediaGroup;
@property (nonatomic, strong) VideoItem *item;
@property (nonatomic, strong) VideoItem *secondItem;

@end

@implementation VideoItemTest

- (void)setUp {
    self.mediaGroup = @{@"media:credit":@"credit", @"media:content":@"content"};
    self.dataDictionary = @{@"title":@"1",@"link":@"2",@"description":@"3",@"itunes:image":@"4",@"itunes:duration":@"5",@"media:group":self.mediaGroup};
    self.item = [[VideoItem alloc]initWithDictionary:self.dataDictionary];
}

- (void)tearDown {
    self.dataDictionary = nil;
    self.mediaGroup = nil;
    self.item = nil;
}

- (void)testInit {
    XCTAssertTrue([self.item.videoTitle  isEqual: @"1"]);
    XCTAssertTrue([self.item.videoLink  isEqual: @"2"]);
    XCTAssertTrue([self.item.videoDescription isEqual: @"3"]);
    XCTAssertTrue([self.item.videoImageURL  isEqual: @"4"]);
    XCTAssertTrue([self.item.videoDuration  isEqual: @"5"]);
    XCTAssertTrue([self.item.videoSpeaker  isEqual: @"credit"]);
    XCTAssertTrue([self.item.videoStreamLink  isEqual: @"content"]);
}

@end

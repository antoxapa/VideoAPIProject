//
//  TestVideoCell.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/23/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VideoCell.h"

@interface TestVideoCell : XCTestCase
@property (nonatomic, strong) VideoCell *cell;
@property (nonatomic, strong) NSMutableString *inputStringDuration;
@property (nonatomic, strong) NSString *inputStringSubstring;

@end

@implementation TestVideoCell

- (void)setUp {
    self.cell = [[VideoCell alloc]init];
    self.inputStringDuration = [NSMutableString stringWithString:@"00:00:00"];
    self.inputStringSubstring = @"Bla=bla | <- should remove before these symbol";
}

- (void)tearDown {
    self.cell = nil;
    self.inputStringDuration = nil;
    self.inputStringSubstring = nil;
}

- (void)testGetDuration {
    NSString *resultString = [self.cell getDuration:self.inputStringDuration];
    NSString *trueString = @"00:00";
    XCTAssertTrue([resultString isEqualToString:trueString]);
    
    NSMutableString *wrongResultString = [NSMutableString stringWithString: @"00:00:0"];
    NSString *newResultString = [self.cell getDuration:wrongResultString];
    NSString *emptyString = @"";
    XCTAssertTrue([newResultString isEqualToString:emptyString]);
}

- (void)testGetSubstring {
    NSString *resultString = [self.cell getSubstring:self.inputStringSubstring];
    NSString *trueString = @"Bla=bla";
    XCTAssertTrue([resultString isEqualToString:trueString]);
    
    NSString *stringWOSymbol = @"Bla=bla";
    NSString *newResultString = [self.cell getSubstring:stringWOSymbol];
    XCTAssertTrue([newResultString isEqualToString:stringWOSymbol]);
}

@end

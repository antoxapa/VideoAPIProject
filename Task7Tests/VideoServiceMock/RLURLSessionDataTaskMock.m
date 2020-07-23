//
//  RLURLSessionDataTaskMock.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "RLURLSessionDataTaskMock.h"

@implementation RLURLSessionDataTaskMock

- (instancetype)initWithBlock:(MyBlock)sessionBlock {
    self = [super init];
    if (self) {
        _sessiongBlock = sessionBlock;
    }
    return self;
}

- (void)resume {
    self.sessiongBlock();
}
@end

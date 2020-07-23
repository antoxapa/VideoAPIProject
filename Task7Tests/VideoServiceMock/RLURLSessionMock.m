//
//  RLURLSessionMock.m
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "RLURLSessionMock.h"
#import "RLURLSessionDataTaskMock.h"

@implementation RLURLSessionMock
-(NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(CompletionHandler)completionHandler {
    RLURLSessionDataTaskMock *myTask = [[RLURLSessionDataTaskMock alloc]initWithBlock:^{
        completionHandler(self.data, nil, self.error);
    }];
    return myTask;
}

@end

//
//  RLURLSessionMock.h
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionHandler)(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error);

@interface RLURLSessionMock : NSURLSession

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END

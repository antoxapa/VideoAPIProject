//
//  RLURLSessionDataTaskMock.h
//  Task7Tests
//
//  Created by Антон Потапчик on 7/22/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyBlock)(void);

@interface RLURLSessionDataTaskMock : NSURLSessionDataTask
@property (nonnull, nonatomic, copy) MyBlock sessiongBlock;

-(instancetype)initWithBlock:(nonnull MyBlock)sessionBlock;
@end

NS_ASSUME_NONNULL_END

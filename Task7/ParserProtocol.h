//
//  ParserProtocol.h
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoItem;

@protocol ParserProtocol <NSObject>

- (void)parseVideo:(NSData *)data completion:(void(^)(NSArray<VideoItem *> *, NSError *))completion;

@end


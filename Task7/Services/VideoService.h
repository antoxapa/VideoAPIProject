//
//  VideoService.h
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface VideoService : NSObject

- (instancetype)initWithParser:(id<ParserProtocol>)parser;

@property (nonatomic, strong) NSURLSession *session;

- (void)parseData:(void(^)(NSArray<VideoItem *> *, NSError *))completion;
- (void)loadDataWithURL:(NSString *)url completion:(void(^)(NSData *, NSError *))completion;
- (void)stopDownload;

@end

NS_ASSUME_NONNULL_END

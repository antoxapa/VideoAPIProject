//
//  VideoItem.h
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoItem : NSObject

@property (nonatomic, strong) NSNumber *videoID;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *videoLink;
@property (nonatomic, copy) NSString *videoDescription;
@property (nonatomic, copy) NSString *videoImageURL;
@property (nonatomic, copy) NSString *videoDuration;
@property (nonatomic, copy) NSString *videoSpeaker;
@property (nonatomic, copy) NSString *videoStreamLink;
@property (nonatomic, strong) UIImage *image;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

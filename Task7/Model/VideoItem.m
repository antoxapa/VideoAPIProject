//
//  VideoItem.m
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _videoTitle = dictionary[@"title"];
        _videoLink = dictionary[@"link"];
        _videoDescription = dictionary[@"description"];
        _videoImageURL = dictionary[@"itunes:image"];
        _videoDuration = dictionary[@"itunes:duration"];
        
        NSDictionary *mediaGroup = dictionary[@"media:group"];
        _videoSpeaker = mediaGroup[@"media:credit"];
        
    }
    return self;
}





@end

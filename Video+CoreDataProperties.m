//
//  Video+CoreDataProperties.m
//  Task7
//
//  Created by Антон Потапчик on 7/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//
//

#import "Video+CoreDataProperties.h"

@implementation Video (CoreDataProperties)

+ (NSFetchRequest<Video *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Video"];
}

@dynamic videoTitle;
@dynamic videoImageURL;
@dynamic videoLink;
@dynamic videoDescription;
@dynamic videoSpeaker;
@dynamic videoDuration;
@dynamic videoStreamLink;
@dynamic videoImage;

@end

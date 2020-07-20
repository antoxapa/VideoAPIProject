//
//  Video+CoreDataProperties.h
//  Task7
//
//  Created by Антон Потапчик on 7/20/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//
//

#import "Video+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Video (CoreDataProperties)

+ (NSFetchRequest<Video *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *videoTitle;
@property (nullable, nonatomic, copy) NSString *videoImageURL;
@property (nullable, nonatomic, copy) NSString *videoLink;
@property (nullable, nonatomic, copy) NSString *videoDescription;
@property (nullable, nonatomic, copy) NSString *videoSpeaker;
@property (nullable, nonatomic, copy) NSString *videoDuration;
@property (nullable, nonatomic, copy) NSString *videoStreamLink;
@property (nullable, nonatomic, retain) NSData *videoImage;

@end

NS_ASSUME_NONNULL_END

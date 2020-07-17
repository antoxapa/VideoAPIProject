//
//  VideoCell.h
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UILabel *videoDuration;
@property (nonatomic, strong) UILabel *speakerLabel;
@property (nonatomic, strong) UILabel *speachTitleLabel;

@end

NS_ASSUME_NONNULL_END

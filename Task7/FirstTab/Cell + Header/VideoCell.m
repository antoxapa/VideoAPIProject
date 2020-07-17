//
//  VideoCell.m
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell ()

@end

@implementation VideoCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.videoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"po"]];
    [self addSubview:self.videoImage];
    self.videoImage.contentMode = UIViewContentModeScaleToFill;
    self.videoImage.translatesAutoresizingMaskIntoConstraints = false;
    self.videoImage.layer.cornerRadius = 5;
    self.videoImage.layer.masksToBounds = YES;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.videoImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.videoImage.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.videoImage.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.videoImage.widthAnchor constraintEqualToConstant:170],
    ]];
    
    self.speakerLabel = [[UILabel alloc]init];
    [self addSubview:self.speakerLabel];
    
    self.speakerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.speakerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.speakerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.speakerLabel.text = @"My favourite author calling blasldalsdlasldalsd";
    self.speakerLabel.textAlignment = NSTextAlignmentLeft;
    self.speakerLabel.numberOfLines = 1;
    self.speakerLabel.textColor = UIColor.darkGrayColor;
    [NSLayoutConstraint activateConstraints:@[
    
        [self.speakerLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [self.speakerLabel.leadingAnchor constraintEqualToAnchor:self.videoImage.trailingAnchor constant:10],
        [self.speakerLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.speakerLabel.heightAnchor constraintEqualToConstant:20],
        
    ]];
    
    self.speachTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.speachTitleLabel];
    
    self.speachTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.speachTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.speachTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.speachTitleLabel.text = @"My favourite author calling blasldalsdlasldalsdasdasdasdasdasdasdhjksdkhfbsldjfgosdljfljsdgfljbsdljfbsdljfsljdbfljsdbfljsdbfljsdbfljsdblfdfsbljfb";
    self.speachTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.speachTitleLabel.numberOfLines = 3;
    self.speachTitleLabel.textColor = UIColor.blackColor;
    [NSLayoutConstraint activateConstraints:@[
    
        [self.speachTitleLabel.topAnchor constraintEqualToAnchor:self.speakerLabel.bottomAnchor constant:5],
        [self.speachTitleLabel.leadingAnchor constraintEqualToAnchor:self.videoImage.trailingAnchor constant:10],
        [self.speachTitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
    
    self.videoDuration = [[UILabel alloc]init];
    [self.videoImage addSubview:self.videoDuration];
    
    self.videoDuration.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoDuration.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.videoDuration.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.videoDuration.text = @"15:20";
    self.videoDuration.textAlignment = NSTextAlignmentCenter;
    self.videoDuration.textColor = UIColor.whiteColor;
    self.videoDuration.backgroundColor = UIColor.blackColor;
    self.videoDuration.alpha = 0.7;
    
    [NSLayoutConstraint activateConstraints:@[
    
        [self.videoDuration.bottomAnchor constraintEqualToAnchor:self.videoImage.bottomAnchor constant:-5],
        [self.videoDuration.trailingAnchor constraintEqualToAnchor:self.videoImage.trailingAnchor constant:-5],
        [self.videoDuration.widthAnchor constraintEqualToConstant:50],
        [self.videoDuration.heightAnchor constraintEqualToConstant:20],

    ]];
}


@end

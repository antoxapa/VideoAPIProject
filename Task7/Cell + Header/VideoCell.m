//
//  VideoCell.m
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "VideoCell.h"
#import "Video+CoreDataProperties.h"

@interface VideoCell ()

@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UILabel *videoDuration;
@property (nonatomic, strong) UILabel *speakerLabel;
@property (nonatomic, strong) UILabel *speachTitleLabel;

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

-(void)initWithCoreItem:(Video *)item; {
    if (!item.videoImage) {
        _videoImage.image = [UIImage imageNamed:@"loading"];
    } else {
        _videoImage.image = [UIImage imageWithData:item.videoImage];
    }
    
    _speakerLabel.text = item.videoSpeaker;
    _speachTitleLabel.text = [self getSubstring:item.videoTitle];
    _videoDuration.text = [self getDuration:[NSMutableString stringWithString:item.videoDuration]];
    
}

-(void)initWithItem:(VideoItem *)item; {
    
    _videoImage.image = item.image;
    _speakerLabel.text = item.videoSpeaker;
    _speachTitleLabel.text = [self getSubstring:item.videoTitle];
    _videoDuration.text = [self getDuration:[NSMutableString stringWithString:item.videoDuration]]; ;
}

- (NSString *)getDuration:(NSMutableString *)duration {
    NSMutableString *newDuration = duration;
    NSString *substring = [duration substringWithRange:NSMakeRange(0, 3)];
    if ([substring isEqualToString:@"00:"]) {
        [newDuration deleteCharactersInRange:NSMakeRange(0, 3)];
    }
    return newDuration;
}

- (NSString *)getSubstring:(NSString *)string {
    NSRange range = [string rangeOfString:@" |"];
    if(range.location != NSNotFound) {
        NSString *result = [string substringWithRange:NSMakeRange(0, range.location)];
        return result;
    }
    return string;
}

- (void)setupViews {
    
    self.videoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading"]];
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
    self.videoDuration.alpha = 0.8;
    
    [NSLayoutConstraint activateConstraints:@[
        
        [self.videoDuration.bottomAnchor constraintEqualToAnchor:self.videoImage.bottomAnchor constant:-5],
        [self.videoDuration.trailingAnchor constraintEqualToAnchor:self.videoImage.trailingAnchor constant:-5],
        [self.videoDuration.heightAnchor constraintEqualToConstant:20],
        
    ]];
}


@end

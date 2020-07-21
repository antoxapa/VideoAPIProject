//
//  VideoInfoVC.m
//  Task7
//
//  Created by Антон Потапчик on 7/19/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "VideoInfoVC.h"
#import "VideoService.h"
#import "XMLParser.h"
#import "AVKit/AVKit.h"
#import "AVFoundation/AVFoundation.h"
#import "AppDelegate.h"
#import "Video+CoreDataProperties.h"

@interface VideoInfoVC ()


@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIStackView *labelsStackView;
@property (nonatomic, strong) UIStackView *buttonsContentView;
@property (nonatomic, strong) UIStackView *textViewContentView;
@property (nonatomic, strong) UILabel *speachLabel;
@property (nonatomic, strong) UILabel *speakerLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *playVideoButton;

@property (nonatomic, strong) NSString *speachTitle;
@property (nonatomic, strong) NSString *speachSpeaker;
@property (nonatomic, strong) NSString *speachDescription;
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, strong) NSString *videoImageURL;
@property (nonatomic, strong) NSString *videoStreamLink;
@property (nonatomic, strong) NSString *videoLink;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) VideoService *videoService;


//@property (nonatomic, copy) VideoItem *videoItem;
//@property (nonatomic, copy) Video *coreItem;


@property (nonatomic, weak) NSLayoutConstraint *videoImageConstraintPortrait;
@property (nonatomic, weak) NSLayoutConstraint *videoImageConstraintLandscape;

@property (nonatomic) BOOL isLiked;
@property (nonatomic, strong) NSMutableArray <Video *> *coreVideoItems;

@end

@implementation VideoInfoVC

- (NSManagedObjectContext *)viewContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
}
- (NSManagedObjectContext *)newBackgroundContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.newBackgroundContext ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.coreVideoItems = [self fetchVideoItems];
    
    for (Video *item in self.coreVideoItems) {
        if ([item.videoLink isEqualToString:self.videoLink]) {
            self.isLiked = YES;
        }
    }
    
    [self setupViews];
    
}

- (void)showVideo {
    NSURL *url = [NSURL URLWithString:self.videoStreamLink];
    if (url){
        AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:playerViewController animated:YES completion:^{
                [playerViewController.player play];
            }];
        });
    }
}

- (void)likeVideo {
    if (!self.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed: @"like_selected"] forState:UIControlStateNormal];
        self.isLiked = YES;
        
        NSManagedObjectContext *context = [self viewContext];
        
        __weak typeof (self) weakSelf = self;
        __block Video *video;
        
        [context performBlockAndWait:^{
            video = [[Video alloc]initWithContext:context];
            video.videoTitle = weakSelf.speachTitle;
            video.videoImage = UIImagePNGRepresentation(weakSelf.videoImage);
            video.videoLink = weakSelf.videoLink;
            video.videoSpeaker = weakSelf.speachSpeaker;
            video.videoDuration = weakSelf.duration;
            video.videoImageURL = weakSelf.videoImageURL;
            video.videoStreamLink = weakSelf.videoStreamLink;
            video.videoDescription = weakSelf.speachDescription;
        }];
        [context save:nil];
        
        self.coreVideoItems = [self fetchVideoItems];
        
    } else {
        self.isLiked = NO;
        [self.likeButton setImage:[UIImage imageNamed: @"like_unselected"] forState:UIControlStateNormal];
        
        NSManagedObjectContext *context = [self viewContext];
        
        if (self.indexPath) {
            Video *video  = [self.coreVideoItems objectAtIndex:self.indexPath.row];
            [context performBlockAndWait:^{
                [context deleteObject:video];
            }];
            [context save:nil];
            
            self.coreVideoItems = [self fetchVideoItems];
        } else {
            Video *video  = self.coreVideoItems.lastObject;
            [context performBlockAndWait:^{
                [context deleteObject:video];
            }];
            [context save:nil];
            
            self.coreVideoItems = [self fetchVideoItems];
        }
    }
}

- (NSMutableArray <Video *>*)fetchVideoItems {
    NSManagedObjectContext *context = [self viewContext];
    NSFetchRequest *fetchRequest = [Video fetchRequest];
    
    return [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)initWithItem:(VideoItem *)item {
    //    _videoItem = item;
    _videoStreamLink = item.videoStreamLink;
    _videoImageURL = item.videoImageURL;
    _videoLink = item.videoLink;
    _videoImage = item.image;
    _speachSpeaker = item.videoSpeaker;
    _speachTitle = [self getSubstring:item.videoTitle];
    _speachDescription = item.videoDescription;
    _duration = [self getDuration:[NSMutableString stringWithString:item.videoDuration]];
}

-(void)initWithCoreItem:(Video *)item at:(NSIndexPath *)indexPath {
    _videoStreamLink = item.videoStreamLink;
    _videoImageURL = item.videoImageURL;
    _videoLink = item.videoLink;
    _videoImage = [UIImage imageWithData:item.videoImage];
    _speachSpeaker = item.videoSpeaker;
    _speachTitle = item.videoTitle;
    _speachDescription = item.videoDescription;
    _duration = [self getDuration:[NSMutableString stringWithString:item.videoDuration]];
    _isLiked = YES;
    _indexPath = indexPath;
}

- (void)shareVideo {
    NSMutableArray *activityItems= [NSMutableArray arrayWithObjects:self.videoLink, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop];
    
    if (@available (iOS 13,*)) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityViewController animated:YES completion:nil];
        } else {
            activityViewController.modalPresentationStyle = UIModalPresentationPopover;
            activityViewController.popoverPresentationController.sourceView = self.shareButton;
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityViewController animated:YES completion:nil];
        } else {
            activityViewController.modalPresentationStyle = UIModalPresentationPopover;
            activityViewController.popoverPresentationController.sourceView = self.shareButton;
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
    }
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
    return @"";
}

- (void)loadImageForURL:(NSString *)url {
    
    __weak typeof(self) weakSelf = self;
    self.videoService = [[VideoService alloc]initWithParser: [XMLParser new]];
    [self.videoService loadImageForURL:url completion:^(UIImage *image) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.videoImage = image;
            weakSelf.videoImageView.image = weakSelf.videoImage;
            [weakSelf.playVideoButton setHidden:NO];
            [weakSelf.durationLabel setHidden:NO];
            
            [weakSelf setImageViewHeightConstraint];
            
            [weakSelf.videoImageView setNeedsDisplay];
            [weakSelf.videoImageView setNeedsLayout];
        });
    }];
}

- (void)setImageViewHeightConstraint {
    CGFloat coef = self.videoImage.size.height/self.videoImage.size.width;
    if (self.view.bounds.size.height > self.view.bounds.size.width) {
        self.videoImageConstraintPortrait = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        self.videoImageConstraintPortrait.constant = self.view.frame.size.width * coef;
        [self.videoImageView addConstraint:self.videoImageConstraintPortrait];
    } else {
        self.videoImageConstraintLandscape = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:self.view.frame.size.height * coef];
        [self.videoImageView addConstraint:self.videoImageConstraintLandscape];
    }
}

- (void)setupViews {
    //    Scroll view
    self.mainScrollView = [UIScrollView new];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainScrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.mainScrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.mainScrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.mainScrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    
    //    Scroll contentView
    self.scrollContentView = [[UIView alloc]init];
    [self.mainScrollView addSubview:self.scrollContentView];
    self.scrollContentView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollContentView.topAnchor constraintEqualToAnchor:self.mainScrollView.topAnchor],
        [self.scrollContentView.leadingAnchor constraintEqualToAnchor:self.mainScrollView.leadingAnchor],
        [self.scrollContentView.trailingAnchor constraintEqualToAnchor:self.mainScrollView.trailingAnchor],
        [self.scrollContentView.bottomAnchor constraintEqualToAnchor:self.mainScrollView.bottomAnchor],
    ]];
    
#pragma mark: - Image and labels content View
    
    // VideoImage View
    self.videoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"loading"]];
    
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.videoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoImageView setUserInteractionEnabled:YES];
    
    self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playVideoButton setImage:[UIImage imageNamed:@"playVideo"] forState:UIControlStateNormal];
    self.playVideoButton.backgroundColor = [UIColor whiteColor];
    self.playVideoButton.alpha = 0.8;
    
    [self.playVideoButton addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playVideoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.videoImageView addSubview:self.playVideoButton];
    
    self.playVideoButton.layer.cornerRadius = 35;
    self.playVideoButton.clipsToBounds = YES;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.playVideoButton.centerXAnchor constraintEqualToAnchor:self.videoImageView.centerXAnchor],
        [self.playVideoButton.centerYAnchor constraintEqualToAnchor:self.videoImageView.centerYAnchor],
        [self.playVideoButton.heightAnchor constraintEqualToConstant:70],
        [self.playVideoButton.widthAnchor constraintEqualToConstant:70],
    ]];
    
    self.durationLabel = [[UILabel alloc]init];
    [self.videoImageView addSubview:self.durationLabel];
    
    self.durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.durationLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.durationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.durationLabel.text = self.duration;
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.textColor = UIColor.whiteColor;
    self.durationLabel.backgroundColor = UIColor.blackColor;
    self.durationLabel.alpha = 0.8;
    
    [NSLayoutConstraint activateConstraints:@[
        
        [self.durationLabel.bottomAnchor constraintEqualToAnchor:self.videoImageView.bottomAnchor constant:-20],
        [self.durationLabel.trailingAnchor constraintEqualToAnchor:self.videoImageView.trailingAnchor constant:-20],
        [self.durationLabel.heightAnchor constraintEqualToConstant:30],
        [self.durationLabel.widthAnchor constraintEqualToConstant:50],
    ]];
    
    if (self.videoImage) {
        self.videoImageView.image = self.videoImage;
        [self setImageViewHeightConstraint];
    } else {
        [self.playVideoButton setHidden:YES];
        [self.durationLabel setHidden:YES];
        [self loadImageForURL:self.videoImageURL];
    }
    
    
    [self.scrollContentView addSubview:self.videoImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.videoImageView.topAnchor constraintEqualToAnchor:self.scrollContentView.topAnchor],
        [self.videoImageView.leadingAnchor constraintEqualToAnchor:self.scrollContentView.leadingAnchor],
        [self.videoImageView.trailingAnchor constraintEqualToAnchor:self.scrollContentView.trailingAnchor],
    ]];
    
    //    Image and labels view
    
    self.labelsStackView = [[UIStackView alloc]init];
    self.labelsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelsStackView.axis = UILayoutConstraintAxisVertical;
    self.labelsStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.labelsStackView.alignment = UIStackViewAlignmentLeading;
    self.labelsStackView.spacing = 10;
    
    // Speach label
    self.speachLabel = [[UILabel alloc]init];
    self.speachLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.speachLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    self.speachLabel.text = self.speachTitle;
    
    self.speachLabel.textAlignment = NSTextAlignmentLeft;
    self.speachLabel.numberOfLines = 3;
    self.speachLabel.textColor = UIColor.blackColor;
    
    
    [self.labelsStackView addArrangedSubview:self.speachLabel];
    
    // speaker label
    self.speakerLabel = [[UILabel alloc]init];
    self.speakerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.speakerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.speakerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.speakerLabel.text = self.speachSpeaker;
    
    //    self.speakerLabel.text = @"asdasdasdsadasdasd ad a dsa dsad sa sa d";
    self.speakerLabel.textAlignment = NSTextAlignmentLeft;
    self.speakerLabel.textColor = UIColor.darkGrayColor;
    
    [self.labelsStackView addArrangedSubview:self.speakerLabel];
    
#pragma mark: - Button content view
    
    self.buttonsContentView = [[UIStackView alloc]init];
    self.buttonsContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.buttonsContentView.alignment = UIStackViewAlignmentLeading;
    self.buttonsContentView.distribution = UIStackViewDistributionEqualCentering;
    self.buttonsContentView.spacing = 15;
    //    [self.buttonsContentView setUserInteractionEnabled:YES];
    
    [NSLayoutConstraint activateConstraints:@[
        //        [self.buttonsContentView.heightAnchor constraintEqualToConstant:50],
        //        [self.buttonsContentView.widthAnchor constraintEqualToConstant:50],
    ]];
    
    //    Like button
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_unselected"] forState:UIControlStateNormal];
    }
    
    self.likeButton.backgroundColor = [UIColor whiteColor];
    
    [self.likeButton addTarget:self action:@selector(likeVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.buttonsContentView addArrangedSubview:self.likeButton];
    
    //    [NSLayoutConstraint activateConstraints:@[
    //        [self.likeButton.topAnchor constraintEqualToAnchor:self.buttonsContentView.topAnchor],
    //        [self.likeButton.leadingAnchor constraintEqualToAnchor:self.buttonsContentView.leadingAnchor],
    //        [self.likeButton.centerYAnchor constraintEqualToAnchor:self.buttonsContentView.centerYAnchor],
    //                [self.likeButton.heightAnchor constraintEqualToConstant:50],
    //                [self.likeButton.widthAnchor constraintEqualToConstant:50],
    //    ]];
    
    //    Share button
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor whiteColor];
    [self.shareButton setUserInteractionEnabled:YES];
    
    [self.shareButton addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.buttonsContentView addArrangedSubview:self.shareButton];
    
    //    [NSLayoutConstraint activateConstraints:@[
    //        [self.shareButton.topAnchor constraintEqualToAnchor:self.buttonsContentView.topAnchor],
    //        [self.shareButton.leadingAnchor constraintEqualToAnchor:self.likeButton.trailingAnchor constant:15],
    //        [self.shareButton.centerYAnchor constraintEqualToAnchor:self.likeButton.centerYAnchor],
    //    ]];
    
#pragma mark: - Info and Description labels
    
    self.textViewContentView = [[UIStackView alloc]init];
    self.textViewContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textViewContentView.axis = UILayoutConstraintAxisVertical;
    self.textViewContentView.distribution = UIStackViewDistributionEqualSpacing;
    self.textViewContentView.alignment = UIStackViewAlignmentLeading;
    self.textViewContentView.spacing = 10;
    
    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    
    self.infoLabel.textColor = [UIColor darkGrayColor];
    self.infoLabel.text = @"ИНФОРМАЦИЯ";
    
    UIView *labelView = [[UIView alloc]init];
    [labelView addSubview:self.infoLabel];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *underlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.infoLabel.frame.size.width, 5)];
    [labelView addSubview:underlineView];
    underlineView.translatesAutoresizingMaskIntoConstraints = NO;
    underlineView.backgroundColor = [UIColor redColor];
    underlineView.alpha = 0.8;
    
    [self.textViewContentView addArrangedSubview:labelView];
    
    [NSLayoutConstraint activateConstraints:@[
        
        [self.infoLabel.topAnchor constraintEqualToAnchor:labelView.topAnchor],
        [self.infoLabel.leadingAnchor constraintEqualToAnchor:labelView.leadingAnchor],
        [self.infoLabel.trailingAnchor constraintEqualToAnchor:labelView.trailingAnchor],
        //        [self.infoLabel.heightAnchor constraintEqualToConstant: 30],
        
        [underlineView.topAnchor constraintEqualToAnchor:self.infoLabel.bottomAnchor constant:3],
        [underlineView.leadingAnchor constraintEqualToAnchor:self.infoLabel.leadingAnchor],
        [underlineView.trailingAnchor constraintEqualToAnchor:self.infoLabel.trailingAnchor],
        [underlineView.heightAnchor constraintEqualToConstant: 2],
        
        [labelView.heightAnchor constraintEqualToConstant: 20],
        [labelView.widthAnchor constraintEqualToAnchor:self.infoLabel.widthAnchor],
    ]];
    //    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"ИНФОРМАЦИЯ"];
    //    [attributeString addAttribute:NSUnderlineStyleAttributeName
    //                            value:[NSNumber numberWithInt:1]
    //                            range:(NSRange){0,[attributeString length]}];
    //
    //    self.infoLabel.attributedText = attributeString;
    
    //    [self.infoLabel.heightAnchor constraintEqualToConstant:50].active = true;
    
    self.descriptionLabel = [[UILabel alloc]init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    
    self.descriptionLabel.text = self.speachDescription;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.textColor = UIColor.blackColor;
    self.descriptionLabel.alpha = 0.8;
    
    
    [self.textViewContentView addArrangedSubview:self.descriptionLabel];
    
#pragma mark: - Main StackView
    
    self.mainStackView = [[UIStackView alloc]init];
    
    self.mainStackView.axis = UILayoutConstraintAxisVertical;
    self.mainStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.mainStackView.alignment = UIStackViewAlignmentLeading;
    self.mainStackView.spacing = 30;
    self.mainStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.mainStackView addArrangedSubview:self.labelsStackView];
    [self.mainStackView addArrangedSubview:self.buttonsContentView];
    [self.mainStackView addArrangedSubview:self.textViewContentView];
    
    [self.scrollContentView addSubview:self.mainStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        
        [self.mainStackView.topAnchor constraintEqualToAnchor:self.videoImageView.bottomAnchor constant:15],
        [self.mainStackView.leadingAnchor constraintEqualToAnchor:self.scrollContentView.leadingAnchor constant:15],
        [self.mainStackView.trailingAnchor constraintEqualToAnchor:self.scrollContentView.trailingAnchor constant:-15],
        [self.mainStackView.bottomAnchor constraintEqualToAnchor:self.scrollContentView.bottomAnchor constant:-15],
        [self.mainStackView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor constant: - 30],
    ]];
}
@end

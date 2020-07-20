//
//  SecondTabVC.m
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "SecondTabVC.h"
#import "VideoCell.h"
#import "HeaderView.h"
#import "VideoInfoVC.h"
#import "AppDelegate.h"
#import "Video+CoreDataProperties.h"
#import "VideoService.h"
#import "XMLParser.h"

@interface SecondTabVC ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSArray<VideoItem *> *dataSource;
@property (nonatomic, strong) VideoService *videoService;

@property (nonatomic, strong) NSMutableArray <Video *> *coreVideoItems;



@end

@implementation SecondTabVC

- (NSManagedObjectContext *)viewContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
}
- (NSManagedObjectContext *)newBackgroundContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.newBackgroundContext ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoService = [[VideoService alloc]initWithParser: [XMLParser new]];

    [self viewContext].automaticallyMergesChangesFromParent = YES;
    
    [self setupCollectionView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.coreVideoItems = [[self fetchCoreVideos] mutableCopy];
    [self.collectionView reloadData];
}

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Video *item = self.coreVideoItems[indexPath.item];
    [self.videoService loadImageForURL:item.videoImageURL completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.coreVideoItems[indexPath.item].videoImage = UIImagePNGRepresentation(image);
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        });
    }];
}


- (NSArray <Video *> *)fetchCoreVideos {
    NSManagedObjectContext *context = [self viewContext];
    NSFetchRequest *fetchRequest = [Video fetchRequest];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

- (void)setupCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        ]];
    }
    
    self.flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - 40, 100);
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.headerReferenceSize = CGSizeMake(150, 100);
    [self.flowLayout setSectionInset:UIEdgeInsetsMake(30, 0, 0, 0)];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Video *item = self.coreVideoItems[indexPath.item];
    
    if (!item.videoImage) {
        [self loadImageForIndexPath:indexPath];
    }
    [cell initWithCoreItem:item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    return headerView;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 40;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.collectionView.bounds.size.width - 40);
    return CGSizeMake(width, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.coreVideoItems.count;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.flowLayout.headerReferenceSize = CGSizeMake(150, 50);
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        self.flowLayout.headerReferenceSize = CGSizeMake(150, 100);
    }
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoVC *vc = [[VideoInfoVC alloc]init];
    
    if (self.tabBarController.selectedIndex == 0) {
         [vc initWithItem: self.dataSource[indexPath.item]];
    } else {
         [vc initWithCoreItem: self.coreVideoItems[indexPath.item]at:indexPath];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


@end
//
//  FirstTabVC.m
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "FirstTabVC.h"
#import "VideoCell.h"
#import "HeaderView.h"

@interface FirstTabVC ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation FirstTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupCollectionView];
    
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
    cell.backgroundColor = [UIColor yellowColor];
    
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
    return 5;
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



@end

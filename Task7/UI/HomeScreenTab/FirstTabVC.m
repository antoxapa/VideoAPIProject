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
#import "VideoService.h"
#import "VideoItem.h"
#import "XMLParser.h"
#import "VideoInfoVC.h"


@interface FirstTabVC () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) VideoService *videoService;

@property (nonatomic, copy) NSArray<VideoItem *> *dataSource;
@property (nonatomic, strong) NSMutableArray<VideoItem *> *searchResults;

@property (nonatomic, strong) UIAlertController *pending;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation FirstTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoService = [[VideoService alloc]initWithParser: [XMLParser new]];
    self.dataSource = [NSArray new];
    self.searchResults = [NSMutableArray new];
    
    [self setupCollectionView];
    [self startLoading];
    [self setupSearchController];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupLoadingAlertController];
}

- (void)setupLoadingAlertController {
    if (!self.pending) {
        self.pending = [UIAlertController alertControllerWithTitle:nil
                                                           message:@"Loading...\n\n"
                                                    preferredStyle:UIAlertControllerStyleAlert];
        if (@available(iOS 13.0, *)) {
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
            
        } else {
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        self.indicator.color = [UIColor blackColor];
        self.indicator.translatesAutoresizingMaskIntoConstraints=NO;
        [self.pending.view addSubview:self.indicator];
        
        [self.indicator.centerYAnchor constraintEqualToAnchor:self.pending.view.centerYAnchor constant:15].active = true;
        [self.indicator.centerXAnchor constraintEqualToAnchor:self.pending.view.centerXAnchor].active = true;
        
        [self.indicator setUserInteractionEnabled:NO];
        [self.indicator startAnimating];
        [self presentViewController:self.pending animated:YES completion:nil];
    }
}

- (void)startLoading {
    __weak typeof (self) weakSelf = self;
    [self.videoService parseData:^(NSArray<VideoItem *> *video, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            } else {
                for (VideoItem *videoItem in video) {
                    NSUInteger index = [video indexOfObject:videoItem];
                    videoItem.videoID = [NSNumber numberWithUnsignedInteger:index];
                    [weakSelf.searchResults addObject:videoItem];
                }
                weakSelf.dataSource = weakSelf.searchResults;
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.collectionView reloadData];
            }
        });
    }];
}
#pragma mark:- Setup UI methods

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

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

#pragma mark:- Download methods

- (void)downloadImageForIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    VideoItem *item = self.dataSource[indexPath.item];
    NSString *imageURL = item.videoImageURL;
    NSInteger index = indexPath.item;
    NSNumber *itemID = item.videoID;
    if (item.image) {
        return;
    }
    [self.videoService loadDataWithURL: imageURL completion:^(NSData * data, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                return;
            }
            if (index >= weakSelf.dataSource.count) { return; }
            if ([weakSelf.dataSource[index].videoID isEqualToNumber:itemID]) {
                UIImage *image = [UIImage imageWithData:data];
                weakSelf.dataSource[index].image = image;
                if ([weakSelf.searchResults containsObject:item]) {
                    [weakSelf.searchResults replaceObjectAtIndex:[weakSelf.searchResults indexOfObject:item]  withObject:item];
                }
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        });
    }];
}
- (void)stopDownloading  {
    [self.videoService stopDownload];
}

#pragma mark:- CollectionViewDataSource and CollectionViewDelegate methods
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    VideoItem *item = [[VideoItem alloc]init];
    
    item = self.dataSource[indexPath.item];
    
    if (!self.collectionView.isDecelerating) {
        if (!item.image) {
            [self downloadImageForIndexPath:indexPath];
        }
    }
    [cell initWithItem:item];
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
    return self.dataSource.count;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoVC *vc = [[VideoInfoVC alloc]init];
    [vc initWithItem: self.dataSource[indexPath.item]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollView methods
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.videoService stopDownload];
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
        for (NSIndexPath *index in indexPaths) {
            [self downloadImageForIndexPath:index];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.videoService stopDownload];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *index in indexPaths) {
        [self downloadImageForIndexPath:index];
    }
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(VideoItem *item, NSDictionary *bindings) {
            return [item.videoTitle containsString:searchText] || [item.videoSpeaker containsString:searchText];
        }];
        
        self.dataSource = [[self.searchResults filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else {
        self.dataSource = [self.searchResults mutableCopy];
    }
    [self.collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

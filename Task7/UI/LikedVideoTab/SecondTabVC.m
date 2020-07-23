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

@interface SecondTabVC () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) VideoService *videoService;

@property (nonatomic, strong) NSMutableArray <Video *> *coreVideoItems;
@property (nonatomic, strong) NSMutableArray<Video *> *searchResults;

@property (nonatomic, strong) UISearchController *searchController;

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
    self.searchResults = [NSMutableArray new];
    
    [self viewContext].automaticallyMergesChangesFromParent = YES;
    
    [self setupCollectionView];
    [self setupSearchController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.coreVideoItems = [[self fetchCoreVideos] mutableCopy];
    self.searchResults = self.coreVideoItems;
    [self.collectionView reloadData];
}

#pragma mark: - Search COntroller
- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)downloadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    Video *item = self.coreVideoItems[indexPath.item];
    NSString *imageURL = item.videoImageURL;
    NSInteger index = indexPath.item;
    if (item.videoImage) {
        return;
    }
    [self.videoService loadDataWithURL:imageURL completion:^(NSData * data, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index >= weakSelf.coreVideoItems.count) { return; }
            if ([weakSelf.coreVideoItems[index].videoLink isEqualToString:item.videoLink]) {
                weakSelf.coreVideoItems[index].videoImage = UIImagePNGRepresentation([UIImage imageWithData:data]);;
                if ([weakSelf.searchResults containsObject:item]) {
                    [weakSelf.searchResults replaceObjectAtIndex:[weakSelf.searchResults indexOfObject:item]  withObject:item];
                }
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
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
    
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    
    self.flowLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - 40, 100);
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.headerReferenceSize = CGSizeMake(150, 100);
    [self.flowLayout setSectionInset:UIEdgeInsetsMake(30, 0, 0, 0)];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Video *item = self.coreVideoItems[indexPath.item];
    
    if (!self.collectionView.isDecelerating) {
        if (!item.videoImage) {
            [self downloadImageForIndexPath:indexPath];
        }
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
    [vc initWithCoreItem: self.coreVideoItems[indexPath.item]at:indexPath];
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Video *item, NSDictionary *bindings) {
            return [item.videoTitle containsString:searchText] || [item.videoSpeaker containsString:searchText];
        }];
        
        self.coreVideoItems = [[self.coreVideoItems filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else {
        self.coreVideoItems = [self.searchResults mutableCopy];
    }
    [self.collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

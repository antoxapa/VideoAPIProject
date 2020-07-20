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
@property (nonatomic, strong) UIAlertController *pending;


@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSArray<VideoItem *> *searchResults;


//this custom controller is only suppose to have number of rows and cell for row function of table datasource

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

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
    if (!self.pending) {
    self.pending = [UIAlertController alertControllerWithTitle:nil
                                                                        message:@"Loading...\n\n"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         indicator.color = [UIColor blackColor];
         indicator.translatesAutoresizingMaskIntoConstraints=NO;
    [self.pending.view addSubview:indicator];
         
    [indicator.centerYAnchor constraintEqualToAnchor:self.pending.view.centerYAnchor constant:15].active = true;
        [indicator.centerXAnchor constraintEqualToAnchor:self.pending.view.centerXAnchor].active = true;
      
         [indicator setUserInteractionEnabled:NO];
         [indicator startAnimating];
    [self presentViewController:self.pending animated:YES completion:nil];
    }
}

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

- (void)startLoading {
        
//    [self.activityIndicator performSelector:@selector(startAnimating) withObject:nil afterDelay:0.1];
    
    __weak typeof (self) weakSelf = self;
    [self.videoService loadVideo:^(NSArray<VideoItem *> *video, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            } else {
                weakSelf.dataSource = video;
                weakSelf.searchResults = [video mutableCopy];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                [self.activityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.1];
                [weakSelf.collectionView reloadData];
                
            }
        });
    }];
     
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

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    VideoItem *item = self.searchResults[indexPath.item];
    [self.videoService loadImageForURL:item.videoImageURL completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.searchResults[indexPath.item].image = image;
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        });
    }];
}

- (UIImage *)loadImageForItem:(VideoItem *)item {
    __block UIImage *downloadedImage;
    [self.videoService loadImageForURL:item.videoImageURL completion:^(UIImage *image) {
        downloadedImage = image;
    }];
    return downloadedImage;
}

#pragma mark:- CollectionViewDataSource and CollectionViewDelegate methods
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    VideoItem *item = [[VideoItem alloc]init];
    
        item = self.searchResults[indexPath.item];
    
    if (!item.image) {
        [self loadImageForIndexPath:indexPath];
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
    
    return self.searchResults.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoVC *vc = [[VideoInfoVC alloc]init];
    
    [vc initWithItem: self.searchResults[indexPath.item]];

    
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - UISearchBarDelegate
//
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSString *searchText = searchController.searchBar.text;
    if (searchText.length != 0) {
        self.searchControllerWasActive = true;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(VideoItem *item, NSDictionary *bindings) {
                return [item.videoTitle containsString:searchText];
        }];
        
        self.searchResults = [[self.searchResults filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else {
        self.searchResults = [self.dataSource mutableCopy];
    }
    [self.collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchControllerWasActive = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.searchControllerWasActive = true;
//    [self.collectionView reloadData];
//}





@end

//
//  MainController.m
//  Task7
//
//  Created by Антон Потапчик on 7/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "MainController.h"
#import "FirstTabVC.h"
#import "SecondTabVC.h"


@interface MainController ()
@property (nonatomic, strong) UINavigationController *firstVC;
@property (nonatomic, strong) UINavigationController *secondVC;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupViews];
}

- (void)setupViews {
    FirstTabVC *firstTab = [[FirstTabVC alloc]init];
    firstTab.view.backgroundColor = [UIColor whiteColor];
    //    firstTab.title = @"";
    UITabBarItem *infoTab = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"home_unselected"] selectedImage:[UIImage imageNamed:@"home_selected"]];
    firstTab.tabBarItem = infoTab;
    
    self.firstVC = [[UINavigationController alloc]initWithRootViewController:firstTab];
    
    
    SecondTabVC *secondTab = [[SecondTabVC alloc]init];
    
    secondTab.view.backgroundColor = [UIColor whiteColor];
    UITabBarItem *galleryTab = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"like_unselected"] selectedImage:[UIImage imageNamed:@"like_selected"]];
    secondTab.tabBarItem = galleryTab;
    self.secondVC = [[UINavigationController alloc]initWithRootViewController:secondTab];
    
    
    self.viewControllers = @[self.firstVC, self.secondVC];
    self.selectedIndex = 0;
}

@end

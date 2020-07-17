//
//  AppDelegate.h
//  Task7
//
//  Created by Антон Потапчик on 7/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void)saveContext;


@end


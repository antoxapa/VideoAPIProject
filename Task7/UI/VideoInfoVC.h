//
//  VideoInfoVC.h
//  Task7
//
//  Created by Антон Потапчик on 7/19/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoInfoVC : UIViewController

-(void)initWithItem:(VideoItem *)item;

@end

NS_ASSUME_NONNULL_END

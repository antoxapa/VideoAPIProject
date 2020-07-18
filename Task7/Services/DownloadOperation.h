//
//  DownloadOperation.h
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DownloadOperation : NSOperation

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^completion)(UIImage *);

- (instancetype)initWithUrl:(NSString *)url;


@end


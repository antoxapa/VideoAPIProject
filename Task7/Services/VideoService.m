//
//  VideoService.m
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "VideoService.h"
#import "ParserProtocol.h"
#import "XMLParser.h"
#import "VideoItem.h"


@interface VideoService ()


@property (nonatomic, strong) id<ParserProtocol> parser;

@property (copy, nonatomic) void (^completion)(NSData *, NSError *);

@end

@implementation VideoService

- (instancetype)initWithParser:(id<ParserProtocol>)parser {
    self = [super init];
    if (self) {
        _parser = parser;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (void)parseData:(void(^)(NSArray<VideoItem *> *, NSError *))completion {
    NSString *url = @"https://www.ted.com/themes/rss/id";
    [self loadDataWithURL:url completion:^(NSData *data, NSError *error) {
        if (data) {
            [self.parser parseVideo:data completion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

- (void)loadDataWithURL:(NSString *)url completion:(void(^)(NSData *, NSError *))completion {
    NSURL *newURL = [NSURL URLWithString:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:newURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (!data) { return; }
        if (completion) {
            self.completion = completion;
        }
        completion(data, nil);
    }];
    [dataTask resume];
}

- (void)stopDownload {
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * dataTasks, NSArray<NSURLSessionUploadTask *> * uploadTasks, NSArray<NSURLSessionDownloadTask *> * downloadTasks) {
        
        for (NSURLSessionDataTask *task in dataTasks) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [task cancel];
            }
        }
    }];
}
@end

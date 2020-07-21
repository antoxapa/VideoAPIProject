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
#import "DownloadOperation.h"


@interface VideoService ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) id<ParserProtocol> parser;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<NSOperation *> *> *operations;

@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

@property (copy, nonatomic) void (^completion)(UIImage *, NSError *);



@end

@implementation VideoService

- (instancetype)initWithParser:(id<ParserProtocol>)parser {
    self = [super init];
    if (self) {
        _parser = parser;
        _queue = [NSOperationQueue new];
        _operations = [NSMutableDictionary new];
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

- (void)loadVideo:(void(^)(NSArray<VideoItem *> *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:@"https://www.ted.com/themes/rss/id"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        [self.parser parseVideo:data completion:completion];
    }];
    [dataTask resume];
}
- (void)loadImageForURL:(NSString *)url completion:(void(^)(UIImage *))completion {
    [self cancelDownloadingForUrl:url];
    DownloadOperation *operation = [[DownloadOperation alloc]initWithUrl:url];
    
    self.operations[url] = @[operation];
    operation.completion = ^(UIImage *image) {
        completion(image);
    };
    [self.queue addOperation:operation];
}
- (void)cancelDownloadingForUrl:(NSString *)url {
    NSArray<NSOperation *> *operations = self.operations[url];
    if (!operations) { return; }
    for (NSOperation *operation in operations) {
        [operation cancel];
    }
}

- (void)downloadImgeForURL:(NSString *)url completion:(void(^)(UIImage *, NSError *))completion {
    
    NSURL *newURL = [NSURL URLWithString:url];
    self.dataTask = [[NSURLSession sharedSession] dataTaskWithURL:newURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data) { return; }
        UIImage *image = [UIImage imageWithData:data];
        if (completion) {
            self.completion = completion;
        }
        completion(image, nil);
    }];
    [self.dataTask resume];
}

- (void)stopDownload {
    [self.dataTask cancel];
    
}




@end

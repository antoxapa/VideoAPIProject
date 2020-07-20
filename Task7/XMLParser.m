//
//  XMLParser.m
//  Task7
//
//  Created by Антон Потапчик on 7/18/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

#import "XMLParser.h"
#import "VideoItem.h"

@interface XMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void (^completion)(NSArray<VideoItem *> *, NSError *);
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *itemDictionary;
@property (nonatomic, strong) NSMutableDictionary *parsingDictionary;
@property (nonatomic, strong) NSMutableString *parsingString;

//@property (nonatomic, strong) NSMutableString *parsingString;

@end

@implementation XMLParser

- (void)parseVideo:(NSData *)data completion:(void (^)(NSArray<VideoItem *> *, NSError *))completion {
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    self.completion = completion;
    parser.delegate = self;
    [parser parse];
    
    
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) {
        self.completion(nil, parseError);
    }
    [self resetParserState];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.items = [NSMutableArray new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        self.itemDictionary = [NSMutableDictionary new];
        self.parsingDictionary = [NSMutableDictionary new];
        self.parsingString = [NSMutableString new];
        
    } else if ([elementName isEqualToString:@"media:group"]) {
        self.parsingDictionary = [NSMutableDictionary new];
        
    }
    else if ([elementName isEqualToString:@"media:content"]) {

        NSString *url = [attributeDict objectForKey:@"url"];;
        [self.parsingDictionary setObject:url forKey:elementName];
    }
    else if ([elementName isEqualToString:@"itunes:image"]) {
        NSString *url = [attributeDict objectForKey:@"url"];;
        [self.parsingDictionary setObject:url forKey:elementName];
    } else {
        self.parsingString = [NSMutableString new];
    }
    

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (self.parsingString) {

        [self.parsingDictionary setObject:self.parsingString forKey:elementName];
        self.parsingString = nil;
    }
    
    if ([elementName isEqualToString:@"media:group"]) {
        [self.itemDictionary setObject:self.parsingDictionary forKey:elementName];
        
        self.parsingDictionary = nil;
    
    } else if ([elementName isEqualToString:@"itunes:duration"]) {
    [self.itemDictionary addEntriesFromDictionary:self.parsingDictionary];
    self.parsingDictionary = nil;
    } else if ([elementName isEqualToString:@"item"]) {
        VideoItem *item = [[VideoItem alloc]initWithDictionary:self.itemDictionary];
        self.itemDictionary = nil;
        [self.items addObject:item];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.completion) {
        self.completion(self.items, nil);
    }
    [self resetParserState];
}

- (void)resetParserState {
    self.completion = nil;
    
    self.items = nil;
    self.itemDictionary = nil;
    self.parsingDictionary = nil;
    self.parsingString = nil;
    
}

@end

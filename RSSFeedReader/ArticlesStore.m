//
//  ArticlesStore.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/29/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "ArticlesStore.h"
#import "RestKit.h"
#import "RSSEntry.h"

@interface ArticlesStore () 
@property (strong) NSMutableArray *articles;
@end

@implementation ArticlesStore

+ (id)allocWithZone:(NSZone *)zone {
    return [ArticlesStore sharedStore];
}

+ (id)sharedStore {
    static ArticlesStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
        sharedStore.articles = [NSMutableArray new];
        [RKClient clientWithBaseURLString:@"http://www.xkcd.com/"];
    }
    return sharedStore;
}

- (void)refreshArticlesWithBLock:(void (^)(void))block {
    RKClient *client = [RKClient sharedClient];
    
    dispatch_async((dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)), ^{
        [client get:@"/rss.xml" usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response){
                if ([response isXML]) {
                    id xmlParser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];
                    id parsedResponse = [xmlParser objectFromString:[response bodyAsString] error:nil];
                    [self parseArticles:parsedResponse];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            };
        }];
    });
}

- (NSArray*)allArticles {
    return self.articles;
}

- (void)parseArticles:(NSDictionary*)dictionary {
    NSArray *items = [[[dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
    NSString *blogTitle = [[[dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"description"];
    
    for ( NSDictionary *item in items ) {
        NSString *description = [item objectForKey:@"description"];
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [linkDetector matchesInString:description options:0 range:NSMakeRange(0, [description length])];
        
        RSSEntry *newEntry = [[RSSEntry alloc] initWithBlogTitle:blogTitle withArticleTitle:[item objectForKey:@"title"] withURL:[[[matches objectAtIndex:0] URL] absoluteString] withDate:[item objectForKey:@"pubDate"] withImage:[[matches objectAtIndex:0] URL]];
        
        [self.articles addObject:newEntry];
    }
}

@end

//
//  RSSEntry.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle, articleTitle, date, url, image;

- (id)initWithBlogTitle:(NSString *)bTitle withArticleTitle:(NSString *)aTitle withURL:(NSString *)addr withDate:(NSString *)pubDate withImage:(UIImage*)img {
    self = [super init];
    if (self) {
        self.blogTitle = bTitle;
        self.articleTitle = aTitle;
        self.url = addr;
        self.date = pubDate;
        self.image = img;
    }
    return self;
}

@end

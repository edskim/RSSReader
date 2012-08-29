//
//  RSSEntry.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle, articleTitle, date, url, image, imageURL;

- (id)initWithBlogTitle:(NSString *)bTitle withArticleTitle:(NSString *)aTitle withURL:(NSString *)addr withDate:(NSString *)pubDate withImage:(NSURL *)imgURL {
    self = [super init];
    if (self) {
        self.blogTitle = bTitle;
        self.articleTitle = aTitle;
        self.url = addr;
        self.date = pubDate;
        self.imageURL = imgURL;
    }
    return self;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)performBlockWithImage:(void (^)(void))block {
    dispatch_async((dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)), ^{
        if (!self.image) {
            CGSize thumbnailSize = CGSizeMake(30, 30);
            UIImage *fullImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
            self.image = [RSSEntry imageWithImage:fullImage scaledToSize:thumbnailSize];
        }
        dispatch_async(dispatch_get_main_queue(), block);
    });
    
}

@end

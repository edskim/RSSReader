//
//  RSSEntry.h
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject 
@property (strong) NSString *blogTitle;
@property (strong) NSString *articleTitle;
@property (strong) NSString *url;
@property (strong) NSString *date;
@property (strong) NSURL *imageURL;
@property (strong) UIImage *image;

- (id)initWithBlogTitle:(NSString*)bTitle withArticleTitle:(NSString*)sTitle withURL:(NSString*)url withDate:(NSString*)date withImage:(NSURL*)imgURL;

- (void)performBlockWithImage:(void(^)(void))block;
@end

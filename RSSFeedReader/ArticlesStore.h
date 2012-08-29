//
//  ArticlesStore.h
//  RSSFeedReader
//
//  Created by Edward Kim on 8/29/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticlesStore : NSObject
+ (id)sharedStore;
- (NSArray*)allArticles;
- (void)refreshArticlesWithBLock:(void(^)(void))block;
@end

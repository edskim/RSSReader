//
//  RSSTableViewCell.h
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSSEntry;

@interface RSSTableViewCell : UITableViewCell
- (id)initWithRSSEntry:(RSSEntry*)entry;
@end

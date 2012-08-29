//
//  RSSTableViewCell.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "RSSEntry.h"
#import "RSSTableViewCell.h"

@implementation RSSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (id)init {
    self = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    return self;
}

- (id)initWithRSSEntry:(RSSEntry*)entry {
    self = [self init];
    if (self) {
        self.textLabel.text = entry.articleTitle;
        self.detailTextLabel.text = [entry.date description];
        self.imageView.image = entry.image;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

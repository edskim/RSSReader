//
//  RSSTableViewController.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "ArticlesStore.h"
#import "RSSEntry.h"
#import "RSSTableViewController.h"
#import "RSSTableViewCell.h"
#import "WebViewController.h"

@interface RSSTableViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RSSTableViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    ArticlesStore *sharedStore = [ArticlesStore sharedStore];
    [sharedStore refreshArticlesWithBLock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticlesStore *sharedStore = [ArticlesStore sharedStore];
    
    WebViewController *webController = [WebViewController new];
    webController.url = [NSURL URLWithString:((RSSEntry*)[sharedStore.allArticles objectAtIndex:indexPath.row]).url];
    [self.navigationController pushViewController:webController animated:YES];
}

#pragma mark UITableView Datasource methods
- (UITableViewCell*)tableView:(UITableView *)tableViewIn cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticlesStore *sharedStore = [ArticlesStore sharedStore];
    
    RSSEntry *article = [sharedStore.allArticles objectAtIndex:indexPath.row];
    RSSTableViewCell *newCell = [[RSSTableViewCell alloc] initWithRSSEntry:article];
    [article performBlockWithImage:^{
        newCell.imageView.image = article.image;
        [newCell setNeedsLayout];
    }];
    return newCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ArticlesStore *sharedStore = [ArticlesStore sharedStore];
    return [sharedStore.allArticles count];
}


@end

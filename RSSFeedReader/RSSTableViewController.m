//
//  RSSTableViewController.m
//  RSSFeedReader
//
//  Created by Edward Kim on 8/28/12.
//  Copyright (c) 2012 AppAcademy. All rights reserved.
//

#import "RestKit.h"
#import "RSSEntry.h"
#import "RSSTableViewController.h"
#import "RSSTableViewCell.h"
#import "WebViewController.h"

@interface RSSTableViewController () <UITableViewDataSource,UITableViewDelegate,RKRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) NSMutableArray *articles;
@end

@implementation RSSTableViewController
@synthesize tableView;
@synthesize articles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.articles = [NSMutableArray new];
        [RKClient clientWithBaseURLString:@"http://www.xkcd.com/"];
    }
    return self;
}

- (void)createArticles {
    RKClient *client = [RKClient sharedClient];
    [client get:@"/rss.xml" delegate:self];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)parseArticles:(NSDictionary*)dictionary {
    NSArray *items = [[[dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
    NSString *blogTitle = [[[dictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"description"];
    CGSize thumbnailSize = CGSizeMake(30, 30);
    
    for ( NSDictionary *item in items ) {
        NSString *description = [item objectForKey:@"description"];
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [linkDetector matchesInString:description options:0 range:NSMakeRange(0, [description length])];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[matches objectAtIndex:0] URL]]];
        UIImage *newImage = [RSSTableViewController imageWithImage:image scaledToSize:thumbnailSize];
        
        RSSEntry *newEntry = [[RSSEntry alloc] initWithBlogTitle:blogTitle withArticleTitle:[item objectForKey:@"title"] withURL:[item objectForKey:@"link"] withDate:[item objectForKey:@"pubDate"] withImage:newImage];

        [self.articles addObject:newEntry];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createArticles];
    // Do any additional setup after loading the view from its nib.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *webController = [WebViewController new];
    webController.url = [NSURL URLWithString:((RSSEntry*)[self.articles objectAtIndex:indexPath.row]).url];
    [self.navigationController pushViewController:webController animated:YES];
}

#pragma mark UITableView Datasource methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[RSSTableViewCell alloc] initWithRSSEntry:[self.articles objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

#pragma mark RKRequestDelegate methods
//- (void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response {
//    NSLog(@"This is the response: %@",response);
//}
-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    //NSLog(@"%@",[response bodyAsString]);
    
    if ([response isXML]) {
        id xmlParser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];
        id parsedResponse = [xmlParser objectFromString:[response bodyAsString] error:nil];
        [self parseArticles:parsedResponse];
    }
}

@end

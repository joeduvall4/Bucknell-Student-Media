//
//  BSMBucknellianViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMBucknellianViewController.h"
#import "WVBUPlayer.h"
#import "Post.h"

@interface BSMBucknellianViewController ()

@property (nonatomic, strong) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BSMBucknellianViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playPausePressed:(id)sender {
    if ([[WVBUPlayer sharedPlayer] rate] != 0.0) {
        [[WVBUPlayer sharedPlayer] pause];
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPlay];
    }
    else {
        [[WVBUPlayer sharedPlayer] play];
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPause];
    }
}

- (void)setRightBarButtonItemForSystemItem:(UIBarButtonSystemItem)item {
    UIBarButtonItem *currentItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:currentItem.target action:currentItem.action];
    self.navigationItem.rightBarButtonItem = newItem;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[WVBUPlayer sharedPlayer] rate] != 0.0) {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPause];
    }
    else {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPlay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPosts];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *postsURL = [NSURL URLWithString:@"http://bucknellian.net/?json=get_recent_posts&count=50&dev=1"];
    NSURLSessionTask *task = [session dataTaskWithURL:postsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            [self parsePostJSONData:data];
        } else {
            NSLog(@"Error Occurred: %@", error);
        }
            }];
    [task resume];
}

- (void)parsePostJSONData:(NSData *)data {
    NSDictionary *postsJSONDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *postsJSONArray = [postsJSONDict objectForKey:@"posts"];
    //NSLog(@"Post JSON: %@", postsJSON);
    //NSLog(@"Posts Count: %d", postsJSON.count);
    
    self.posts = [NSMutableArray array];
    for (NSDictionary *postJSON in postsJSONArray) {
        NSError *error;
        Post *post = [MTLJSONAdapter modelOfClass:[Post class] fromJSONDictionary:postJSON error:&error];
        if (post) {
            NSLog(@"Post: %@", post);
            [self.posts addObject:post];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - TableView Required Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Post *post = self.posts[indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.excerpt;
    cell.textLabel.numberOfLines = 3;
//    UIFont *myFont = cell.textLabel.font;
//    [myFont fontWithSize:(44.0 + (cell.textLabel.numberOfLines - 1) * 19.0)];
//    [cell.textLabel setFont:myFont];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

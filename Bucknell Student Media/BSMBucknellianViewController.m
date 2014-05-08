//
//  BSMBucknellianViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMBucknellianViewController.h"
#import "WVBUPlayer.h"

@interface BSMBucknellianViewController ()

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  BSMWVBUViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMWVBUViewController.h"
#import <AVFoundation/AVPlayer.h>

static NSString *currentSongLocation = @"http://eg.bucknell.edu/~wvbu/current.txt";

@interface BSMWVBUViewController ()

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@end

@implementation BSMWVBUViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateCurrentlyPlaying];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateCurrentlyPlaying];
    
    
//    NSURL *streamURL = [NSURL URLWithString:@"http://stream.bucknell.edu:90/wvbu.m3u"];
//    AVPlayer *player = [AVPlayer playerWithURL:streamURL];
//    [player play];
//    NSLog(@"Error: %@", [player error]);
}

- (void)updateCurrentlyPlaying {
    __block NSString *nowPlaying;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        nowPlaying = [NSString stringWithContentsOfURL:[NSURL URLWithString:currentSongLocation]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nowPlaying) {
                if (nowPlaying.length > 0) {
                    nowPlaying = [nowPlaying substringToIndex:nowPlaying.length-1];
                    NSArray *currentSongAttributes = [nowPlaying componentsSeparatedByString:@"-"];
                    _artistLabel.text = currentSongAttributes[0];
                    _songLabel.text = currentSongAttributes[1];
                }
            }
        });
    });
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

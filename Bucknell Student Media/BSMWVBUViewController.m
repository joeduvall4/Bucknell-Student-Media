//
//  BSMWVBUViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMWVBUViewController.h"
#import <AVFoundation/AVPlayer.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "iTunesClient.h"

static NSString *currentSongLocation = @"http://eg.bucknell.edu/~wvbu/current.txt";

@interface BSMWVBUViewController ()

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSString *currentSong;
@property (nonatomic, strong) NSString *currentArtist;
@property (nonatomic, strong) NSDictionary *currentSongInfo;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

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

- (void)searchiTunesForSong:(NSString *)song byArtist:(NSString *)artist {
    NSString *term = [NSString stringWithFormat:@"%@ %@", song, artist];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[iTunesClient sharedClient] searchForTerm:term
                                    completion:^(NSArray *results, NSError *error) {
                                        if (results) {
                                            self.currentSongInfo = results[0];
                                            [self updateAlbumArtworkForCurrentSongInfo];
                                        } else {
                                            NSLog(@"Error Occurred: %@", error);
                                        }
                                    }];
}

- (void)updateAlbumArtworkForCurrentSongInfo {
    if (self.currentSongInfo) {
        NSString *urlString = self.currentSongInfo[@"artworkUrl100"];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"100x100" withString:@"600x600"];
        NSURL *imageURL = [NSURL URLWithString:urlString];
        NSLog(@"URL: %@", imageURL);
        if (imageURL) {
            [self.artworkImageView setImageWithURL:imageURL];
        }
    }
}

- (void)updateCurrentlyPlaying {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *nowPlaying = [NSString stringWithContentsOfURL:[NSURL URLWithString:currentSongLocation]
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([[nowPlaying substringFromIndex:nowPlaying.length-1] isEqualToString:@"^"])
            nowPlaying = [nowPlaying substringToIndex:nowPlaying.length-1];
        NSArray *currentSongAttributes = [nowPlaying componentsSeparatedByString:@"-"];
        self.currentSong = currentSongAttributes[1];
        self.currentArtist = currentSongAttributes[0];
        [self searchiTunesForSong:self.currentSong byArtist:self.currentArtist];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _artistLabel.text = self.currentArtist;
            _songLabel.text = self.currentSong;
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

//
//  BSMWVBUViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMWVBUViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "iTunesClient.h"
#import "WVBUPlayer.h"

static NSString *currentSongLocation = @"http://eg.bucknell.edu/~wvbu/current.txt";

@interface BSMWVBUViewController ()

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSString *currentSong;
@property (nonatomic, strong) NSString *currentArtist;
@property (nonatomic, strong) NSDictionary *currentSongInfo;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIButton *iTunesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *albumArtLoadingIndicator;

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
    if ([[WVBUPlayer sharedPlayer] rate] != 0.0) {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPause];
    }
    else {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPlay];
    }
    [self updateCurrentlyPlaying];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateCurrentlyPlaying) userInfo:nil repeats:YES];
    //[self updateCurrentlyPlaying];
}

- (void)searchiTunesForSong:(NSString *)song byArtist:(NSString *)artist {
    NSString *term = [NSString stringWithFormat:@"%@ %@", song, artist];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.albumArtLoadingIndicator startAnimating];
    [[iTunesClient sharedClient] searchForTerm:term
                                    completion:^(NSArray *results, NSError *error) {
                                        [self.albumArtLoadingIndicator stopAnimating];
                                        if (results) {
                                            if (results.count > 0) {
                                                self.currentSongInfo = results[0];
                                                [self updateAlbumArtworkForCurrentSongInfo];
                                            }
                                            else {
                                                self.artworkImageView.image = [UIImage imageNamed:@"artworkGeneric"];
                                                NSLog(@"Unable to find a suitable match on iTunes for the current track.");
                                            }
                                        } else {
                                            self.artworkImageView.image = [UIImage imageNamed:@"artworkGeneric"];
                                            NSLog(@"Error Occurred: %@", error);
                                        }
                                    }];
}

- (IBAction)iTunesButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentSongInfo[@"trackViewUrl"]]];
}

- (void)updateAlbumArtworkForCurrentSongInfo {
    if (self.currentSongInfo) {
        //self.artworkImageView.image = nil;
        [self.artworkImageView cancelImageRequestOperation];
        NSString *urlString = self.currentSongInfo[@"artworkUrl100"];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"100x100" withString:@"600x600"];
        NSURL *imageURL = [NSURL URLWithString:urlString];
        //NSLog(@"URL: %@", imageURL);
        if (imageURL) {
            [self.artworkImageView setImageWithURL:imageURL];
        }
        [self.iTunesButton setEnabled:YES];
    }
}

- (void)updateCurrentlyPlaying {
    //NSLog(@"Updating Currently Playing...");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSError *error;
        NSString *nowPlaying = [NSString stringWithContentsOfURL:[NSURL URLWithString:currentSongLocation]
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to update current song." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        else {
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
        }
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

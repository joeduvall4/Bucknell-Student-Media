//
//  BSMBucknellianDetailViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMBucknellianDetailViewController.h"
#import "WVBUPlayer.h"

@interface BSMBucknellianDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *articleTextView;

@end

@implementation BSMBucknellianDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTextView];
    self.navigationItem.title = self.currentPost.title;
}

- (void)setTextView {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.currentPost.content dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    // Handle iOS Dynamic Type.
    self.articleTextView.attributedText = [self updateUserFontSizeForAttributedString:attributedString withTextStyle:UIFontTextStyleBody];
}

/**
 *  Called before the view appears.
 *
 *  @param animated Whether or not it should be animated. Doesn't concern us.
 */
- (void)viewWillAppear:(BOOL)animated {
    // Register for updateAboutTextViewFont to be called when the app becomes active.
    if ([[WVBUPlayer sharedPlayer] rate] != 0.0) {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPause];
    }
    else {
        [self setRightBarButtonItemForSystemItem:UIBarButtonSystemItemPlay];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateArticleTextViewFont)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  Updates the articleTextView font to reflect the latest Dynamic Type settings within Settings.app. This is really only useful in the off chance that a user changes their Dynamic Type setting while the app is running, but stranger things have happened!
 */
- (void)updateArticleTextViewFont {
    self.articleTextView.attributedText = [self updateUserFontSizeForAttributedString:self.articleTextView.attributedText
                                                                  withTextStyle:UIFontTextStyleBody];
}

/**
 *  Applies iOS's built-in Dynamic Type settings (set by the user in Settings.app) to the specified NSAttributedString, given a specified UIFontDescriptor Text Style.
 *
 *  @param attributedString An NSAttributedString to modify.
 *  @param style            A UIFontDescriptor Text Style (NSString *const) for which we want to get the user's Dynamic Type settings.
 *
 *  @return NSAttributedString with the Dynamic Type font size applied.
 */
- (NSAttributedString *)updateUserFontSizeForAttributedString:(NSAttributedString *)attributedString
                                                withTextStyle:(NSString *const)style {
    NSRange fullRange = NSMakeRange(0, attributedString.length);
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont preferredFontForTextStyle:style]
                                    range:fullRange];
    return mutableAttributedString;
}

- (void)setRightBarButtonItemForSystemItem:(UIBarButtonSystemItem)item {
    UIBarButtonItem *currentItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:currentItem.target action:currentItem.action];
    self.navigationItem.rightBarButtonItem = newItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

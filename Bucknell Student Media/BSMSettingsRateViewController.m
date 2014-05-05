//
//  BSMSettingsRateViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/2/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMSettingsRateViewController.h"

@interface BSMSettingsRateViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rateTextView;

@end

@implementation BSMSettingsRateViewController

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
    
    // Read in RTF file with rating text. We shouldn't need to change this more often than every release of the app, so it shouldn't be necessary to fetch a copy from the network.
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"RateMe" withExtension:@"rtf"] options:nil documentAttributes:nil error:NULL];
    // Handle iOS Dynamic Type.
    _rateTextView.attributedText = [self updateUserFontSizeForAttributedString:attributedString withTextStyle:UIFontTextStyleBody];
}

/**
 *  Called before the view appears.
 *
 *  @param animated Whether or not it should be animated. Doesn't concern us.
 */
- (void)viewWillAppear:(BOOL)animated {
    // Register for updateAboutTextViewFont to be called when the app becomes active.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRateTextViewFont)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  Updates the rateTextView font to reflect the latest Dynamic Type settings within Settings.app. This is really only useful in the off chance that a user changes their Dynamic Type setting while the app is running, but stranger things have happened!
 */
- (void)updateRateTextViewFont {
    _rateTextView.attributedText = [self updateUserFontSizeForAttributedString:_rateTextView.attributedText
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

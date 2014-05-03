//
//  BSMSettingsAboutViewController.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 4/25/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "BSMSettingsAboutViewController.h"

@interface BSMSettingsAboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation BSMSettingsAboutViewController

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
    // NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] forKey:NSFontAttributeName]
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"Acknowledgements" withExtension:@"rtf"] options:nil documentAttributes:nil error:NULL];
    NSRange fullRange = NSMakeRange(0, attributedString.length);
    NSMutableAttributedString *newAttributedString = [attributedString mutableCopy];
    [newAttributedString addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:fullRange];
    _aboutTextView.attributedText = newAttributedString;
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

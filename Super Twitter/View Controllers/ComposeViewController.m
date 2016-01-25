//
//  ComposeViewController.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-25.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterAPI.h"
#import "DataManager.h"

#define kTweetLengthLimit 140
@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

-(void)disableButtons{
    self.doneButton.enabled = NO;
    self.cancelButton.enabled = NO;
}

-(void)enableButtons{
    self.doneButton.enabled = YES;
    self.cancelButton.enabled = YES;
}
#pragma mark - IBActions
- (IBAction)tappedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedDone:(id)sender {
    [self disableButtons];
    __weak typeof(self) weakSelf = self;
    [[TwitterAPI sharedInstance] sendTweet:self.textField.text responseHandler:^(BOOL success, NSString *errorMessage, NSString *tweetContent, NSInteger tweetId, NSDate *date) {
        [weakSelf enableButtons];
        if(success){
            //Add tweet to local data manager. Check if add operation was succesful.
            BOOL addedTweet = [[DataManager sharedInstance] addTweet:tweetContent date:date identifier:tweetId];
            NSString *title = addedTweet? @"Success!" : @"Error";
            NSString *message = addedTweet? @"Tweet was sent succesfully." : @"There was an error sending the tweet. Try again later.";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      if(addedTweet){
                                                                          [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                                      }
                                                                  }];

            [alert addAction:defaultAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    return textView.text.length < kTweetLengthLimit;
}
@end

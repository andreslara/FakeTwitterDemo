//
//  LoginViewController.m
//  Super Twitter
//
//  Created by Andres Lara Aguirre on 2016-01-24.
//  Copyright © 2016 Andres Lara. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterAPI.h"
#import "DataManager.h"

#define kLoginToMainSegue @"loginToMainSegue"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actvityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@end

@interface LoginViewController()

@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[DataManager sharedInstance] isLoggedIn]){
        [self performSegueWithIdentifier:kLoginToMainSegue sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self hideActivityIndicator];
}

-(void)showActivityIndicator{
    self.signInButton.hidden = YES;
    [self.actvityIndicator startAnimating];
    self.password.enabled = NO;
    self.userName.enabled = NO;
}

-(void)hideActivityIndicator{
    self.signInButton.hidden = NO;
    [self.actvityIndicator stopAnimating];
    self.password.enabled = YES;
    self.userName.enabled = YES;
}

#pragma mark - IBActions
- (IBAction)tappedLogin:(id)sender {
    [self showActivityIndicator];
    __weak typeof(self) weakSelf = self;
    [[TwitterAPI sharedInstance] login:self.userName.text password:self.password.text responseHandler:^(BOOL success, NSString *errorMessage) {
        if(success){
            [[DataManager sharedInstance] loginAsUser:self.userName.text];
            [weakSelf performSegueWithIdentifier:kLoginToMainSegue sender:weakSelf];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        [weakSelf hideActivityIndicator];
    }];
}

@end

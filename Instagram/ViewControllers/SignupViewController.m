//
//  SignupViewController.m
//  Instagram
//
//  Created by addisonz on 7/8/19.
//  Copyright © 2019 addisonz. All rights reserved.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordText setSecureTextEntry:YES];
}

- (IBAction)signupClicked:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameText.text;
    newUser.email = self.emailText.text;
    newUser.password = self.passwordText.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // log user in
            [PFUser logInWithUsernameInBackground:self.usernameText.text password:self.passwordText.text block:^(PFUser * user, NSError *  error) {
                if (error != nil) {
                    NSLog(@"User log in failed: %@", error.localizedDescription);
                } else {
                    NSLog(@"User logged in successfully");
                    
                    // manually segue to logged in view
                    [self performSegueWithIdentifier:@"timeline" sender:self];
                }
            }];
        }
    }];
}

@end

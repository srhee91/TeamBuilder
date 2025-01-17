//
//  NewUserViewController.m
//  Team-Up
//
//  Created by Kartik Sawant on 1/29/15.
//  Copyright (c) 2015 Kartik Sawant. All rights reserved.
//

#import "NewUserViewController.h"
#import "Parse/parse.h"
#import "AppDelegate.h"


@interface NewUserViewController ()

@end

@implementation NewUserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

-(void) dismissKeyboard {
    [self.un resignFirstResponder];
    [self.pw resignFirstResponder];
    [self.bd resignFirstResponder];
    [self.em resignFirstResponder];
    [self.newpw resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signup:(id)sender {
    PFUser *user = [PFUser user];

    NSString *username = self.un.text;
    NSString *password = self.pw.text;
    NSString *password2 = self.newpw.text;
    NSString *email = self.em.text;
    if ([password compare:password2 options:NSCaseInsensitiveSearch] == NSOrderedSame){
            if(![self.un.text isEqualToString:@""]&&![self.un.text isEqualToString:@" "]&&![self.pw.text isEqualToString:@""]&&![self.newpw.text isEqualToString:@""]&&![self.bd.text isEqualToString:@""]&&![self.em.text isEqualToString:@""]&&[self.pw.text isEqualToString:self.newpw.text]){
                user.username = username;
                user.password = password;
                user[@"birthday"] = self.bd.text;
                user.email = email;
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"successful");
                        user[@"initial"] = [NSNumber numberWithBool:YES];
                        // Now Sign Up successful, continue to onto next page
                        AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                        ad.storePassword = self.pw.text;
                        NSLog(@"%@",ad.storePassword);
                        [self performSegueWithIdentifier:@"toMain" sender:sender];
                    } else {
                        NSLog(@"Fail");
                        // Sign Up failed, ask for re-input of user information
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                }];
            }
            else{
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter information again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                //Do not move onto next Page, ask for re-input of information
            }
    }
    else{
        NSLog(@"pass not equal");
        //Do not move onto next Page, ask for re-input of passwords
    }
    
}


@end

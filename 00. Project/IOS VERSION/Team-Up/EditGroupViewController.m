//
//  EditGroupViewController.m
//  Team-Up
//
//  Created by Kartik Sawant on 2/8/15.
//  Copyright (c) 2015 Kartik Sawant. All rights reserved.
//

#import "EditGroupViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@implementation EditGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.gn.text = [ad.myGlobalArray objectAtIndex:0][@"groupname"];
    self.des.text = [ad.myGlobalArray objectAtIndex:0][@"description"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
}

-(void) dismissKeyboard {
    [self.gn resignFirstResponder];
    [self.des resignFirstResponder];
    [self.edit resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)edit:(id)sender {
    if(![self.gn.text isEqualToString:@""]&&![self.des.text isEqualToString:@""]){
        PFObject *group = [PFObject objectWithClassName:@"Group"];
        AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        group[@"admin"]= [ad.myGlobalArray objectAtIndex:0][@"admin"];
        group[@"groupId"]= [ad.myGlobalArray objectAtIndex:0][@"groupId"];
        group[@"categoryName"]= [ad.myGlobalArray objectAtIndex:0][@"categoryName"];
        group[@"category"]= [ad.myGlobalArray objectAtIndex:0][@"category"];
        group[@"groupname"] = self.gn.text;
        group[@"description"] = self.des.text;
        PFQuery *deleteGroup = [PFQuery queryWithClassName:@"Group"];
        [deleteGroup whereKey:@"groupId" equalTo:[ad.myGlobalArray objectAtIndex:0][@"groupId"]];
        [deleteGroup findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                [[results objectAtIndex:0] deleteInBackground];
                [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        // The object has been saved.
                        NSLog(@"yay");
                        UIAlertView *edit = [[UIAlertView alloc] initWithTitle:@"Group Edited" message:@"Group has been edited." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [edit show];
                        [ad.myGlobalArray removeAllObjects];
                        [ad.myGlobalArray addObject:group];
                    } else {
                        // There was a problem, check error.description
                        NSLog(@"%@",error.description);
                    }
                }];
            } else {
                // The find succeeded.
                NSLog(@"failed to retrieve the object.");
            }
        }];
        

    }
    else{
        NSLog(@"Missing information");
        //Do not move onto next Page, ask for re-input of information
    }
}

@end
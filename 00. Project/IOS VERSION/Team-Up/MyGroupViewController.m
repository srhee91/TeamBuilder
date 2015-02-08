//
//  MyGroupViewController.m
//  Team-Up
//
//  Created by Kartik Sawant on 2/6/15.
//  Copyright (c) 2015 Kartik Sawant. All rights reserved.
//

#import "MyGroupViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
@interface MyGroupViewController ()

@end

@implementation MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *name = [ad.myGlobalArray objectAtIndex:0][@"groupname"];
    self.navbar.title = name;
    self.gn.text = name;
    self.an.text = [ad.myGlobalArray objectAtIndex:0][@"admin"];
    self.cat.text = [ad.myGlobalArray objectAtIndex:0][@"categoryName"];
    self.des.text = [ad.myGlobalArray objectAtIndex:0][@"description"];
    PFQuery *member = [PFQuery queryWithClassName:@"Member"];
    [member orderByDescending: @"createdAt"];
    [member whereKey:@"username" notEqualTo:currentUser.username];
    [member whereKey:@"groupId" equalTo:[ad.myGlobalArray objectAtIndex:0][@"groupId"]];
    [member findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        //join button
        self.navbar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:@selector(join)];
        if (!error) {
            self.array = results;
            NSLog(@"made it");
            NSLog(@"%@",results);
            [self.tv setDelegate:self];
            [self.tv setDataSource:self];
            [self.tv reloadData];
        } else {
            // The find succeeded.
            NSLog(@"failed to retrieve the object.");
        }
        PFQuery *members = [PFQuery queryWithClassName:@"Member"];
        [members whereKey:@"username" equalTo:currentUser.username];
        [members whereKey:@"groupId" equalTo:[ad.myGlobalArray objectAtIndex:0][@"groupId"]];
        [members findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            NSLog(@"username %@",[results objectAtIndex:0][@"username"]);
            NSLog(@"error %@",error.description);
            int k = 0;
            if([currentUser.username isEqualToString:[results objectAtIndex:0][@"username"]]) {
                //leave button
                self.navbar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave" style:UIBarButtonItemStylePlain target:self action:@selector(leave)];
                k = 1;
            }
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
}

- (void)join {
    PFUser *currentUser = [PFUser currentUser];
    PFObject *member = [PFObject objectWithClassName:@"Member"];
    member[@"username"] = currentUser.username;
    AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    member[@"groupId"] = [ad.myGlobalArray objectAtIndex:0][@"groupId"];
    [member saveInBackground];
    self.navbar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Leave" style:UIBarButtonItemStylePlain target:self action:@selector(leave)];
}

- (void)leave {
    PFUser *currentUser = [PFUser currentUser];
    AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    PFQuery *mem = [PFQuery queryWithClassName:@"Member"];
    [mem whereKey:@"username" equalTo:currentUser.username];
    [mem whereKey:@"groupId" equalTo:[ad.myGlobalArray objectAtIndex:0][@"groupId"]];
    [mem findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        [[results objectAtIndex:0] deleteInBackground];
    }];
    self.navbar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:@selector(join)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"count of array %d",[self.array count]);
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.array
                           objectAtIndex: [indexPath row]][@"username"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"%i",indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [ad.myGlobalArray removeAllObjects];
    [ad.myGlobalArray addObject:[self.array objectAtIndex:[indexPath row]]];
    NSLog(@"%@",ad.myGlobalArray);
    [self performSegueWithIdentifier:@"toUserProfile" sender:self];
}

@end
//
//  PFProfileViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/22/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFProfileViewController.h"
#import "Manager.h"

@interface PFProfileViewController ()

@end

@implementation PFProfileViewController
Manager * manager;

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
    manager = [Manager sharedInstance];
    if(self.user)
    {
    
    }
    else{
    if(!manager.user)//hide elements
    {
        self.profilePhoto.image = nil;
        self.userDescription.text = @"";
        self.albumsButton.hidden = YES;
        self.userName.text = @"";
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        //self.userDescription.text = manager.user
        self.userName.text = manager.user.userName;
        
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];

    }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {


}

-(void)logout{

}

@end

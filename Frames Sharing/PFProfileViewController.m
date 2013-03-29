//
//  PFProfileViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/22/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFProfileViewController.h"
#import "Manager.h"
#import "LoginRegisterViewController.h"
#import "PFAlbumsViewController.h"
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
  
}

-(void)viewWillAppear:(BOOL)animated{
    if(!manager.user)//hide elements
    {
        self.profilePhoto.image = nil;
        self.userDescription.text = @"";
        self.albumsButton.hidden = YES;
        self.userName.text = @"";
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"user deoosn't exist??");
    }
    else{
        self.userName.text = self.user.userName;
        if(self.user == manager.user){
            
            [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
            
            
            //            [self.loginButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            
            NSLog(@"Button Logged In Text %@ ",self.loginButton.titleLabel.text);
            
        }
        else{
            NSLog(@"User not logged in");
            
        }
        self.albumsButton.hidden =NO;
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    //get to the login controller.
    LoginRegisterViewController *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPopover"];
    [self.navigationController pushViewController:pf animated:YES];
}

- (IBAction)showAlbums:(id)sender {
    PFAlbumsViewController *pfa = [self.storyboard instantiateViewControllerWithIdentifier:@"PFAlbumsViewController"];
    pfa.user = self.user;
    [self.navigationController pushViewController:pfa animated:YES];
    
    
}

-(void)logout{
    [manager.ff logout];
     manager.user = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end

//
//  PFSharingViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFSharingViewController.h"
#import "Photo.h"
#import "PFProfileViewController.h"
#import "LoginRegisterViewController.h"

@interface PFSharingViewController () <UITextFieldDelegate>

@end

@implementation PFSharingViewController

    Manager * manager;


-(void)viewDidAppear:(BOOL)animated{
    [self configureView];
}





- (void)viewDidLoad
{
    
    manager =[Manager sharedInstance];
    
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated{
     
}

-(void)configureView{
    if(manager.user){
        //configure view
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
        self.navigationItem.rightBarButtonItem = anotherButton;
        
    }
    else{
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginOrSignUp:)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
}

-(IBAction)showProfile{
    if(manager.user){
     PFProfileViewController * p = [self.storyboard instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
     p.user = manager.user;
    
     [self.navigationController pushViewController:p animated:YES];
    }
    else
    {
     [manager displayMessage:@"You need be logged in to display profile."];
    }
}


//-(void)updateUIWithUIImage:(UIImage *)image{
//    
//    NSLog(@"Update it");
//    //self.imgView.image = image;
//    
//    float x = arc4random()%200;
//    float y = arc4random()%400;
//    
//    float w = 100;
//    float h  = 100;
//
//    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
//    img.image =image;
//    
//    [self.view addSubview: img];
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createVCSegue:(UIButton *)sender {

     //[self performSegueWithIdentifier:@"menu" sender:self];
    if(self.navigationController)
    {
        [manager showPhotoEditorForNavigationController:self.navigationController editImage:nil];
    }
    if(self.currentNavigationController){
        [manager showPhotoEditorForNavigationController:self.currentNavigationController editImage:nil];
    }
}

- (IBAction)exploreVCSegue:(UIButton *)sender {
    if(manager.user){
        [self performSegueWithIdentifier:@"explore" sender:self];
    }
    else{
        [manager displayMessage:@"You need to be logged in to explore albums."];
    }
}
- (IBAction)shareVCSegue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"share" sender:self];
}

- (IBAction)albumsVCSegue:(UIButton *)sender {
    if(manager.user){
        [self performSegueWithIdentifier:@"albums" sender:self];
    }
    else{
        [manager displayMessage:@"You need to be logged in to access albums."];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"explore"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"share"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"albums"]) {
        
    }
}

- (IBAction)loginOrSignUp:(UIBarButtonItem *)sender {
    LoginRegisterViewController *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPopover"];
    [self.navigationController pushViewController:pf animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}




@end

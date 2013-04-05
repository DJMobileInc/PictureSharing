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
    [self testIt];
    
    
    
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
    else{
            [manager displayMessage:@"You need be logged in to display profile."];
    }
}


-(void)updateUIWithUIImage:(UIImage *)image{
    
    NSLog(@"Update it");
    self.imgView.image = image;
    
    float x = arc4random()%200;
    float y = arc4random()%400;
    
    float w = 100;
    float h  = 100;

    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    img.image =image;
    
    [self.view addSubview: img];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createVCSegue:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"create" sender:self];
   
    UIViewController *vc;
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        vc = [iPhoneStoryboard instantiateInitialViewController];
    }
    else{
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        vc =[iPadStoryboard instantiateInitialViewController];
    }

    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentModalViewController:initialSettingsVC animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    if ([segue.identifier isEqualToString:@"create"]) {
        //
    }
    else if ([segue.identifier isEqualToString:@"explore"]) {
        
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

#pragma mark test it.
-(void)testIt{

#if DEBUG
    NSLog(@"Debug mode on: ");
    manager = [Manager sharedInstance];

    
#endif

}



@end

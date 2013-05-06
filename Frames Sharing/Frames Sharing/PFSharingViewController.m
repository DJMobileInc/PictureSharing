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
#import "PFExploreViewController.h"
#import "PFAlbumsViewController.h"
#import "PFiPadAlbumsViewController.h"
#import "PFNotificationController.h"


@interface PFSharingViewController () <UITextFieldDelegate>

@end

@implementation PFSharingViewController
UIPopoverController * profilePopover;
UIPopoverController * notificationsPopover;

    Manager * manager;

- (void)viewDidLoad
{
    
    manager =[Manager sharedInstance];
    if(self.navigationController){
        manager.currentNavigationController = self.navigationController;
        self.currentNavigationController = self.navigationController;
    }
    else{
    
    }
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated{
     
}

-(void)viewDidAppear:(BOOL)animated{
    [self configureView];
}

-(void)pushNotificationReceived:(NSNotification *)push{
    NSLog(@"Received ! ");
}

-(void)configureView{
//    if(manager.user){
//        //configure view
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(showProfile)];
//        self.navigationItem.rightBarButtonItem = anotherButton;
//        
//    }
//    else{
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginOrSignUp:)];
//        self.navigationItem.rightBarButtonItem = anotherButton;
//    }
}

-(IBAction)showProfile{
    if(manager.user){
        PFProfileViewController * p;
        UIStoryboard * st;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            
            p.user = manager.user;
            
            if(!profilePopover)
            {
                profilePopover = [[UIPopoverController alloc]initWithContentViewController:p];
            }
            if([profilePopover isPopoverVisible]){
                [profilePopover dismissPopoverAnimated:YES];
            }
            else{
                [profilePopover presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
       // [manager dismissPopover: self];
        
        }
        else{
            st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = manager.user;
            
            //NSLog(@"User is %@ ",p.user);
          
  
        //    [self.navigationController pushViewController:p animated:YES];
            
        }
    }
    else
    {   
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.currentNavigationController andViewController:self];
    }
    
    
}

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
    else if(self.currentNavigationController){
        [manager showPhotoEditorForNavigationController:self.currentNavigationController editImage:nil];
    }
}

- (IBAction)exploreVCSegue:(UIButton *)sender {
    [self explorePhotos:NO];
}


- (IBAction)exploreFavorites:(id)sender {
    if(manager.user){
        [self explorePhotos:YES];
    }
    else{
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.currentNavigationController andViewController:self];  
    
    }
}

- (IBAction)showNotifications:(id)sender {
    UIStoryboard *st;
    PFNotificationController * explorer;
    if(manager.user){
    
    st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    explorer =[st instantiateViewControllerWithIdentifier:@"PFNotificationsController"];
    explorer.user = manager.user;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(!notificationsPopover)
        {
            notificationsPopover = [[UIPopoverController alloc]initWithContentViewController:explorer];
        }
        if(notificationsPopover.isPopoverVisible){
            [notificationsPopover dismissPopoverAnimated:YES];
        }
        [notificationsPopover presentPopoverFromRect:[(UIButton *)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else{
           [self.currentNavigationController pushViewController:explorer animated:YES];
    }
    }
    else{
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.currentNavigationController andViewController:self];

    }
}

-(void)explorePhotos:(BOOL)favorite{
    UIStoryboard *st;
    PFExploreViewController * explorer;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
      if(![self.currentNavigationController.topViewController isKindOfClass:[PFExploreViewController  class ]])
      {
        st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        explorer =[st instantiateViewControllerWithIdentifier:@"PFExploreViewController"];
        explorer.favoritesMode = favorite;
          if(favorite){
              
          }
          [self.currentNavigationController pushViewController:explorer animated:YES];
          
     }
    }
    else{
        st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        explorer= [st instantiateViewControllerWithIdentifier:@"PFExploreViewController"];
        explorer.favoritesMode = favorite;
        [self.navigationController pushViewController:explorer animated:YES];
    }
}


- (IBAction)shareVCSegue:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"share" sender:self];
}

- (IBAction)albumsVCSegue:(UIButton *)sender {
    if(manager.user){
        UIViewController * vc;
        if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
        {
            UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            vc = [iPhoneStoryboard instantiateViewControllerWithIdentifier:@"PFAlbumsViewController"];
            
            
            [manager.currentNavigationController pushViewController:vc animated:YES];
        }
        else{
            UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            if(![self.currentNavigationController.topViewController isKindOfClass:[PFiPadAlbumsViewController  class ]])
            {
                vc =[iPadStoryboard instantiateViewControllerWithIdentifier:@"PFiPadAlbumsViewController"];
                if(self.navigationController){
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    [manager.currentNavigationController pushViewController:vc animated:YES];
                }
            }
            else{
                NSLog(@"");
            
            }
            
        }

    }
    else{
   
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.currentNavigationController andViewController:self];
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


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == (UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown));
}

- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation) [[UIDevice currentDevice] orientation];
    
    if (orientation==UIInterfaceOrientationPortrait) {
       
        return YES;
    }
    
    return NO;
}


- (IBAction)pushIt:(id)sender {
    
}






@end

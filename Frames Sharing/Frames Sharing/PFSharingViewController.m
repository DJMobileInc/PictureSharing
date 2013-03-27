//
//  PFSharingViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFSharingViewController.h"
#import "PFLogin.h"
#import <FFEF/FatFractal.h>
#import <FFEF/FFMetaData.h>
#import "Photo.h"

@interface PFSharingViewController () <UITextFieldDelegate>
@property (strong, nonatomic)PFLogin *loginView;

@end

@implementation PFSharingViewController

    Manager * manager;


-(void)viewDidAppear:(BOOL)animated{
}





- (void)viewDidLoad
{
    
    manager =[Manager sharedInstance];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoggedIn:) name:loginSucceededNotification object:nil];
    
    [self testIt];
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:loginSucceededNotification object:nil];
    
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
    [self performSegueWithIdentifier:@"create" sender:self];
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
    self.loginView = [[PFLogin alloc]initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200)];
    self.loginView.userName.delegate = self;
    self.loginView.password.delegate = self;
    [self.loginView.loginButton addTarget:self action:@selector(doStuff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginView];
    [self.navigationItem.rightBarButtonItems[0] setEnabled:NO];
    [UIView animateWithDuration:1 animations:^() {
        self.loginView.frame = CGRectOffset(self.loginView.frame, 0, 200);
    }completion:^(BOOL finished) {
        
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)doStuff{
    
    if( self.loginView.userName.text.length>0 &&self.loginView.password.text.length>0)
    {
    [manager loggingInWithName: self.loginView.userName.text andPassword: self.loginView.password.text];
    
    [UIView animateWithDuration:1 animations:^() {
        self.loginView.frame = CGRectOffset(self.loginView.frame, 0, -200);
    }completion:^(BOOL finished) {
        if (finished) {
            self.loginView = nil;
    [self.navigationItem.rightBarButtonItems[0] setEnabled:YES];
            [self.loginView removeFromSuperview];
        }
        
    }];
    }
    else{
        [manager displayMessage:@"Please Fill All Required Information"];
    }
}

#pragma mark test it.
-(void)testIt{

#if DEBUG
    NSLog(@"Debug mode on: ");
    manager = [Manager sharedInstance];
    manager.delegate = self;
    
    [manager loggingInWithName:@"Janek2004" andPassword:@"Stany174"];
    
    

#endif

}

#pragma manager delegate
-(void)userLoggedIn:(NSNotification *)notification{
    NSLog(@"User Logged In and now calling %@",(FFUser *)notification.object);
    //if user logged in create an album?
  //  NSString * guid = [manager.ff metaDataForObj:manager.user].guid;
  //  [manager createNewAlbumOfName:@"TestAlbum" forUser:guid privacy:YES];
    manager.user = notification.object;
    //[self addPicture];
}

-(void)addPicture{
    NSString * albumGuid = @"3_0cgjEmNcfuw6oN_kAYU4";
    NSArray * images = @[@"lampard1",@"lampard2",@"lampard3",@"lampard4"];
    
    int ranIndex = arc4random()%images.count;
    
    NSString * path= [[NSBundle mainBundle]pathForResource:[images objectAtIndex:ranIndex] ofType:@"png"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    if(data!=nil)
    {
        NSLog(@"Data yes");
    }
    else{
        NSLog(@"Data no");    
    }
    NSString * userGuid = [manager.ff metaDataForObj:manager.user].guid;
    
    [manager createNewPhotoWithDescription:@"Some Description goes here" forUser:userGuid forAlbum:albumGuid withData:data];
    
    
}

-(void)createdAlbum:(Album *)album{
    NSLog(@"Album Created: %@", album);
    if(album!=nil){
        //add photos to album
        [self addPicture];
    }

}

-(void)uploadedPhoto{
    NSLog(@"Photo Uploaded. Yay");
    //Get Albums
    [manager getAlbumsForUser:[manager.ff metaDataForObj:manager.user].guid];
}

-(void)downloadedAlbums:(NSArray *)albums{
    NSLog(@" Albums downloaded %@",albums);

}

-(void)receivedAlbums:(NSArray *)albums{

}



@end

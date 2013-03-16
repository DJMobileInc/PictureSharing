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
//    NSError * error;
//    NSLog(@" _________________START __________________");
//    NSArray *responseArray = [[FatFractal main]getArrayFromUrl:[NSString stringWithFormat:@"/ff/resources/Images"] error:&error];
//    
//    for(int i =0;i<responseArray.count;i++){
//        
//        Photo * p = [responseArray objectAtIndex:i];
//        FFMetaData * meta = [[FatFractal main]metaDataForObj:p  ];
//        
//        NSLog(@"Meta: guid %@ ff url %@  ff refs %@ ",[meta guid],[meta ffUrl], [meta ffRefs]);
//        
//        
//        
//        if(p.imageData)
//        {
//            /*
//            UIImage * img = [UIImage imageWithData:p.imageData];
//            [self updateUIWithUIImage:img];
//            // NSLog(@"Update Image ");
//             */
//        }
//        else{
//            NSLog(@"It doesn;t");
//        }
//    }
//
//    NSLog(@" _________________END __________________");
//

}





- (void)viewDidLoad
{
    
    manager =[Manager sharedInstance];
    [self testIt];
    [super viewDidLoad];
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
    
    //[manager loggingInWithName:@"Janek2004" andPassword:@"Stany174"];
    
    

#endif

}

#pragma manager delegate
-(void)userLoggedIn:(id)user{
//    NSLog(@"User Logged In and now calling %@",(FFUser *)user);
//    //if user logged in create an album?
//      NSString * guid = [manager.ff metaDataForObj:manager.user].guid;
//    [manager createNewAlbumOfName:@"TestAlbum" forUser:guid privacy:YES];
}

-(void)createdAlbum:(Album *)album{
    NSLog(@"Album Created: %@", album);
    if(album!=nil){
        //add photos to album
        NSString * albumGuid = [manager.ff metaDataForObj:album].guid;
        
        
        NSArray * images = @[@"lampard1",@"lampard2",@"lampard3",@"lampard4"];
        
        int ranIndex = arc4random()%images.count;
        
        NSString * path= [[NSBundle mainBundle]pathForResource:[images objectAtIndex:ranIndex] ofType:@"png"];
        NSData * data = [NSData dataWithContentsOfFile:path];
        
        NSString * userGuid = [manager.ff metaDataForObj:manager.user].guid;
        
        [manager createNewPhotoWithDescription:@"Some Description goes here" forUser:userGuid forAlbum:albumGuid withData:data];
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

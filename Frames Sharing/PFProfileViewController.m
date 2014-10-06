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
#import "User.h"
#import "CameraPicker.h"
#import "PFiPadAlbumsViewController.h"

@interface PFProfileViewController ()<UITextViewDelegate>

@end

@implementation PFProfileViewController
Manager * manager;
UIActionSheet * photoAction;
CameraPicker * camera;
UIPopoverController * cameraPopoverController;
BOOL tryLoading =NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    self.userDescription.delegate = self;
     camera = [[CameraPicker alloc]init];
    [self loadPhoto];
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.preferredContentSize =  CGSizeMake(350, 404);
    }

}

-(void)loadPhoto{
    [manager.ff loadBlobsForObj:self.user onComplete:^
     (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
         tryLoading = YES;
         if(theErr)
         {
             NSLog(@" Error for blob  %@ ",[theErr debugDescription]);
         }
         
         User * user = (User *) theObj;
         
         
         self.user = user;
         UIImage * img = [UIImage imageWithData: user.profilePicture];
         if(img){
             self.profileImageView.image = img;
         }
     }];
}

-(void)viewWillAppear:(BOOL)animated{
    if(!tryLoading)
    {
         [self loadPhoto];
    }
    if(!manager.user)//hide elements
    {
        self.userDescription.text = @"";
        self.albumsButton.hidden = YES;
        self.userName.text = @"";
        self.profilePictureButton.enabled = NO;
        [self.profilePictureButton setHidden:YES];
        [self.loginButton setHidden:YES];
    }
    else{
        self.userName.text = self.user.userName;
        self.userDescription.text =self.user.aboutDescription;
        self.albumsButton.hidden =NO;
        
        if(self.user == manager.user){
                        
            [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
            [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            [self.userDescription setEditable:YES];
           
            self.profilePictureButton.enabled = YES;
            [self.profilePictureButton setHidden:NO];
            [self.loginButton setHidden:NO];
        }
        else{
                       
           [self.userDescription setEditable:NO];
           [self.loginButton setHidden:YES];
            
        }    
    }
    //setting image
 //   
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlbums:(id)sender {
    UIViewController * vc;
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        vc = [iPhoneStoryboard instantiateViewControllerWithIdentifier:@"PFAlbumsViewController"];
        [(PFAlbumsViewController *)vc setUser:self.user];
        
        [manager.currentNavigationController pushViewController:vc animated:YES];
    }
    else{
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        vc =[iPadStoryboard instantiateViewControllerWithIdentifier:@"PFiPadAlbumsViewController"];  
       [(PFiPadAlbumsViewController *)vc setUser:self.user];
        if(self.navigationController){
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
          [manager.currentNavigationController pushViewController:vc animated:YES];
        }
    }
      
}

-(void)logout{
   // [manager.ff logout];
    manager.user = nil;
    
    if(self.navigationController){
        [manager dismissPopovers];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [manager.currentNavigationController  popToRootViewControllerAnimated:YES];

    }
    else{
        [manager dismissPopovers];
        [manager.currentNavigationController  popToRootViewControllerAnimated:YES];
    }
//    
//    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone){
//         UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
//        //iPadStoryboard.
//    }
 
    [self dismissViewControllerAnimated:YES completion:nil];
    [manager displayMessage:@"Successfully logged out."];
    
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)done{
    manager.user.aboutDescription = self.userDescription.text;
    [manager updateObject:self.user];
    [self.userDescription resignFirstResponder];
    

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem =nil;
    [manager updateObject:self.user];
}



- (IBAction)profilePictureButtonClicked:(id)sender {
    if(self.user == manager.user){
        photoAction=[[UIActionSheet alloc]initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Photo", @"Photo Library", nil];
        [photoAction showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    if([actionSheet isEqual:photoAction]){
        if(buttonIndex==0) // make photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.view picker:NO andPopover:cameraPopoverController];
        }
        else//pick photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.view picker:YES andPopover:cameraPopoverController];
            
        }
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage;
    UIImage * imageToUse;
   
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
   
        } else {
            imageToUse = originalImage;
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [cameraPopoverController dismissPopoverAnimated:YES];


    
    self.profileImageView.image = imageToUse;
    
    self.user.profilePicture = UIImageJPEGRepresentation([imageToUse imageByScalingProportionallyToSize:CGSizeMake(200, 200)],0.7);
    self.user.smallProfilePicture = UIImageJPEGRepresentation([imageToUse imageByScalingProportionallyToSize:CGSizeMake(50, 50)],0.7);
    
    
[manager.ff updateBlob:self.user.profilePicture withMimeType:@"image/jpeg" forObj:self.user memberName:@"profilePicture" onComplete: ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse){
    if(!theErr){
        NSLog(@"Object Updated");
    }
    else{
        NSLog(@"Object Not  Updated %@", [theErr debugDescription]);
    }
 }
 ];

[manager.ff updateBlob:self.user.smallProfilePicture withMimeType:@"image/jpeg" forObj:self.user memberName:@"smallProfilePicture" onComplete: ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse){
        if(!theErr){
            NSLog(@"Object Updated");
        }
        else{
            NSLog(@"Object Not  Updated %@", [theErr debugDescription]);
        }
    }
     ];

    

}

@end

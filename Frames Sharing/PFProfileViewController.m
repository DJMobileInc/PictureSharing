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
@interface PFProfileViewController ()<UITextViewDelegate>

@end

@implementation PFProfileViewController
Manager * manager;
UIActionSheet * photoAction;
CameraPicker * camera;
UIPopoverController * cameraPopoverController;

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
    self.userDescription.delegate = self;
     camera = [[CameraPicker alloc]init];
    [manager.ff loadBlobsForObj:self.user onComplete:^
     (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
         if(theErr)
         {
             NSLog(@" Error for blob  %@ ",[theErr debugDescription]);
         }
         
         User * user = (User *) theObj;
         NSLog(@"User is: %@ %@",self.user, user);
         
         self.user = user;
         UIImage * img = [UIImage imageWithData: user.profilePicture];
         NSLog(@"Image is: %@",img);
         [self.profilePictureButton setImage:img forState:UIControlStateNormal];
         NSLog(@" Image should be updated and updated user is: %@",self.user.profilePicture);
     }];

}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Testing User %@ %@",manager.user,self.user);
    
    if(!manager.user)//hide elements
    {
        self.userDescription.text = @"";
        self.albumsButton.hidden = YES;
        self.userName.text = @"";
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        self.profilePictureButton.enabled = NO;
        NSLog(@"user deoosn't exist??");
    }
    else{
        self.userName.text = self.user.userName;
        self.albumsButton.hidden =NO;

        if(self.user == manager.user){
                        
            [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
            
            [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            [self.userDescription setEditable:YES];
            NSLog(@"Button Logged In Text %@ ",self.loginButton.titleLabel.text);
            self.profilePictureButton.enabled = YES;
            [self.loginButton setHidden:NO];
        }
        else{
            NSLog(@"User not logged in");
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

-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)done{
    manager.user.aboutDescription = self.userDescription.text;
    [manager updateObject:self.user];

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem =nil;
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
    //  NSLog(@"Did Finish Picking");
    UIImage *originalImage, *editedImage;
    UIImage * imageToUse;
    // Handle a still image capture
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

    [self.profilePictureButton setImage:imageToUse forState:UIControlStateNormal];
     self.user.profilePicture = UIImageJPEGRepresentation(imageToUse,0.7);
    
    [manager updateObject:self.user];
}

@end

//
//  PFProfileViewController.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/22/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface PFProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextView *userDescription;
@property (strong, nonatomic) IBOutlet UIButton *albumsButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) User * user;

- (IBAction)showAlbums:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *profilePictureButton;
- (IBAction)profilePictureButtonClicked:(id)sender;

@end

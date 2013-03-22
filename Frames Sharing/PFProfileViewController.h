//
//  PFProfileViewController.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/22/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextView *userDescription;

@end

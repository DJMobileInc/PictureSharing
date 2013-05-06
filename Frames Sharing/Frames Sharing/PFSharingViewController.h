//
//  PFSharingViewController.h
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"

@interface PFSharingViewController : UIViewController
//@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong,nonatomic) UINavigationController * currentNavigationController;

- (IBAction)createVCSegue:(UIButton *)sender;
- (IBAction)exploreVCSegue:(UIButton *)sender;
- (IBAction)shareVCSegue:(UIButton *)sender;
- (IBAction)albumsVCSegue:(UIButton *)sender;
- (IBAction)showProfile;
@end

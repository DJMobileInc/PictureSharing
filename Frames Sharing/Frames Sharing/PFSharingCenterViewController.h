//
//  PFSharingCenterViewController.h
//  Frames Sharing
//
//  Created by sadmin on 4/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFSharingCenterViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property(nonatomic,strong)UIImage * imageToShare;
@property(nonatomic,strong)UINavigationController *   currentNavigationController;


@end

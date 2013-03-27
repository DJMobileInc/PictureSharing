//
//  PFAlbumDetailsViewController.h
//  Frames Sharing
//
//  Created by sadmin on 3/14/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface PFAlbumDetailsViewController : UIViewController <ManagerDelegate>
@property (nonatomic,strong) NSString * albumGuid;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

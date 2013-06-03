//
//  PFPickAlbumViewController.h
//  Frames Sharing
//
//  Created by sadmin on 4/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Manager.h"

@interface PFPickAlbumViewController : UIViewController<UITableViewDelegate>
@property (nonatomic,strong)User * user;
@property (nonatomic,strong)UIImage * imageToShare;

@end

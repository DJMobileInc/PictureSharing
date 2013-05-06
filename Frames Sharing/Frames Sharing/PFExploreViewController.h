//
//  PFExploreViewController.h
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "User.h"

@interface PFExploreViewController : UIViewController

@property (nonatomic,strong)User * user;
@property (nonatomic, assign) BOOL favoritesMode;

@end

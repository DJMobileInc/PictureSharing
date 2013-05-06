//
//  PFUsersViewController.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 4/27/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@interface PFUsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain)Photo * photo;

@end

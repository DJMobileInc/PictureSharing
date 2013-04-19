//
//  PFAlbumDetailsViewController.h
//  Frames Sharing
//
//  Created by sadmin on 3/14/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "Album.h"

@interface PFAlbumDetailsViewController : UIViewController
@property (nonatomic,strong) NSString * albumGuid;
@property (nonatomic,strong) Album * album;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

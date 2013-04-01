//
//  PFDisplayPhotoViewController.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/19/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@class User;

@interface PFDisplayPhotoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *starsCount;
@property (strong,nonatomic) Photo * photo;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;
@property (strong,nonatomic) User * user;

-(void)changeDescription:(NSString *)desc;
-(void)changeImage:(UIImage *)image;
-(void)changeRatings :(int)ratings;
-(void)displayAuthor :(NSString *)author;
-(IBAction)voteForPhoto:(id)sender;


@end

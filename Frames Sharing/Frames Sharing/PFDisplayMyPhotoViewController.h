//
//  PFDisplayMyPhotoViewController.h
//  Frames Sharing
//
//  Created by sadmin on 3/15/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PFDisplayMyPhotoViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *starsCount;
@property(strong,nonatomic)Photo * photo;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentTappedOn:(id)sender;
-(void)changeDescription:(NSString *)desc;
-(void)changeImage:(UIImage *)image;
-(void)changeRatings :(int)ratings;
- (IBAction)showPhotoEditor:(id)sender;

@end

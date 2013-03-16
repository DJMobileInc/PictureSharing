//
//  PFDisplayMyPhotoViewController.h
//  Frames Sharing
//
//  Created by sadmin on 3/15/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFDisplayMyPhotoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *description;
@property(strong,nonatomic) NSString * descriptionText;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *imageData;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentTappedOn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *starsCount;

-(void)changeDescription:(NSString *)desc;
-(void)changeImage:(UIImage *)image;
-(void)changeRatings :(int)ratings;


@end

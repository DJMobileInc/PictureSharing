//
//  FrameCell.h
//  iPictureFrames Lite
//
//  Created by Janusz Chudzynski on 12/21/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photoFrame;
@property (strong, nonatomic) IBOutlet UIImageView *lock;
@property (nonatomic) BOOL locked;


@end

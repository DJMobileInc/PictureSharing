//
//  FilterEffects.h
//  iPictureFrames Lite
//
//  Created by sadmin on 12/23/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface FilterEffects : NSObject
@property (nonatomic, strong) UIImage * image;
-(void)filterSelected:(CIFilter *)filter;
@end

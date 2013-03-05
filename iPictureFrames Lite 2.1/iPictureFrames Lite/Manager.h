//
//  Manager.h
//  iPictureFrames Lite
//
//  Created by sadmin on 12/29/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject
@property (nonatomic, strong) UIImage * defaultImage;
@property (nonatomic, strong) UIImage * defaultFrame;
@property (nonatomic,strong) UIImage * modifiedImage;
+ (id)sharedManager;


@end

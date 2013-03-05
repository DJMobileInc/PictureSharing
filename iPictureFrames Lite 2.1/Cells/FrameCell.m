//
//  FrameCell.m
//  iPictureFrames Lite
//
//  Created by Janusz Chudzynski on 12/21/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "FrameCell.h"

@implementation FrameCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.locked = false;
        self.lock.hidden =YES;
    }
    return self;
}

-(void)setLocked:(BOOL)locked{

    self.lock.hidden =!locked;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

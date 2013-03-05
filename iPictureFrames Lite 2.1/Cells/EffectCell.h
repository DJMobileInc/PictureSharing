//
//  EffectCell.h
//  iPictureFrames Lite
//
//  Created by sadmin on 12/29/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EffectCell  : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView * photo;
@property (nonatomic, strong) IBOutlet UILabel * effectLabel;

@end

    //
//  NotificationCell.h
//  Frames Sharing
//
//  Created by sadmin on 5/5/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UITextView * message;
@property (nonatomic,strong) IBOutlet UIImageView * profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

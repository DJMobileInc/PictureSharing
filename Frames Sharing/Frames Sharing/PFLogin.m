//
//  PFLogin.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFLogin.h"

@implementation PFLogin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userName = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, 30)];
        self.userName.borderStyle = UITextBorderStyleRoundedRect;
        self.userName.backgroundColor = [UIColor blueColor];
        self.password = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, frame.size.width, 30)];
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.backgroundColor = [UIColor blueColor];
        self.password.secureTextEntry = YES;
        self.userName.keyboardType = UIKeyboardTypeDefault;
        self.password.keyboardType = UIKeyboardTypeDefault;
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 30)];
        userLabel.backgroundColor = [UIColor clearColor];
        userLabel.textAlignment = NSTextAlignmentCenter;
        userLabel.textColor = [UIColor blackColor];
        userLabel.text = @"UserName";
        UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, frame.size.width, 30)];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.textAlignment = NSTextAlignmentCenter;
        passwordLabel.textColor = [UIColor blackColor];
        passwordLabel.text = @"Password";
        self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, frame.size.width, 44)];
        [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [self addSubview:self.loginButton];
        [self addSubview:userLabel];
        [self addSubview:passwordLabel];
        [self addSubview:self.userName];
        [self addSubview:self.password];
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
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

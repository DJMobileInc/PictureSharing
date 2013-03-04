//
//  PFSharingViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFSharingViewController.h"
#import "PFLogin.h"
@interface PFSharingViewController () <UITextFieldDelegate>
@property (strong, nonatomic)PFLogin *loginView;
@end

@implementation PFSharingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createVCSegue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"create" sender:self];
}
- (IBAction)exploreVCSegue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"explore" sender:self];
}
- (IBAction)shareVCSegue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"share" sender:self];
}

- (IBAction)albumsVCSegue:(UIButton *)sender {
    [self performSegueWithIdentifier:@"albums" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"create"]) {
        //
    }
    else if ([segue.identifier isEqualToString:@"explore"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"share"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"albums"]) {
        
    }
}
- (IBAction)loginOrSignUp:(UIBarButtonItem *)sender {
    self.loginView = [[PFLogin alloc]initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200)];
    self.loginView.userName.delegate = self;
    self.loginView.password.delegate = self;
    [self.loginView.loginButton addTarget:self action:@selector(doStuff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginView];
    [self.navigationItem.rightBarButtonItems[0] setEnabled:NO];
    [UIView animateWithDuration:1 animations:^() {
        self.loginView.frame = CGRectOffset(self.loginView.frame, 0, 200);
    }completion:^(BOOL finished) {
        
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)doStuff {
    [UIView animateWithDuration:1 animations:^() {
        self.loginView.frame = CGRectOffset(self.loginView.frame, 0, -200);
    }completion:^(BOOL finished) {
        if (finished) {
            self.loginView = nil;
    [self.navigationItem.rightBarButtonItems[0] setEnabled:YES];
        }
        
    }];
}
@end

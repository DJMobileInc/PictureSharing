//
//  LoginRegisterViewController.m
//  Lecture Capture
//
//  Created by Janusz Chudzynski on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginRegisterViewController.h"

@interface LoginRegisterViewController ()

@end

@implementation LoginRegisterViewController

@synthesize registrationView;



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//Hiding the keyboard
-(void) hideKeyboard{
    for(UITextField * t in textFields)
    {
        [t resignFirstResponder];
    }
}


#pragma mark Views

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    manager = [Manager sharedInstance];
    //setting up text array with text fields
    textFields = [NSArray arrayWithObjects:_usernameLoginTextField,_passwordLoginTextField,_emailTextField,_passwordTextField,_confirmPasswordTextField,_displayNameTextField, nil];
    for(UITextField * t in textFields)
    {
        t.delegate=self;
    }
    [registrationView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoggedIn:) name:loginSucceededNotification object:nil];
}

-(void)userLoggedIn:(NSNotification *)notification{
    NSLog(@"User Logged In and now calling %@",(User *)notification.object);
    manager.user = notification.object;
    for (int i=0; i<6; i++) {
       // [self addPicture];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.delegate dissmissPopover];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter]removeObserver:self name:loginSucceededNotification object:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [self setDisplayNameTextField:nil];
    [self setPasswordLoginTextField:nil];
    [self setRegistrationView:nil];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)registerUser:(id)sender {
    
    //Validating Data:
    int l2= _passwordTextField.text.length;
    int l3= _confirmPasswordTextField.text.length;
    int l4= _displayNameTextField.text.length;
    
    //Check if all fields are filled
    if(l2>0&&l3>0&&l4>0)
    {
     
        //Checking Passwords
        if([_passwordTextField.text isEqualToString:_confirmPasswordTextField.text])
        {
            [manager signUpWithName:_displayNameTextField.text andPassword:_passwordTextField.text];
            [self hideKeyboard];
        }
        else{
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your passwords don't match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [a show];
        }
    }
      
    else{
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You need to fill all fields to register a new user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [a show];
    }
}


//Validating Email:
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (IBAction)loginUser:(id)sender {
  
    NSLog(@"Trying to log in user....");
    
    
    //Validate fields
    int l1 = _usernameLoginTextField.text.length;
    int l2 = _passwordLoginTextField.text.length;
    //Checking if fields are filled
    if(l1>0&&l2>0)
    {
        //Checking for valid email
        //Check if the first field is an email:
        //trying to log in:
         [manager loggingInWithName:_usernameLoginTextField.text andPassword:_passwordLoginTextField.text];
        [self hideKeyboard];
    }
    else{
        [manager displayMessage:@"You need to fill all fields to log in."];        
    }
}


-(void)addPicture{
    NSString * albumGuid = @"3_0cgjEmNcfuw6oN_kAYU4";
    NSArray * images = @[@"lampard1",@"lampard2",@"lampard3",@"lampard4"];
    
    int ranIndex = arc4random()%images.count;
    
    NSString * path= [[NSBundle mainBundle]pathForResource:[images objectAtIndex:ranIndex] ofType:@"png"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    if(data!=nil)
    {
        NSLog(@"Data yes");
    }
    else{
        NSLog(@"Data no");
    }
    NSString * userGuid = [manager.ff metaDataForObj:manager.user].guid;
    
    [manager createNewPhotoWithDescription:@"Some Description goes here" forUser:userGuid forAlbum:albumGuid withData:data];
    
    
}

-(void)createdAlbum:(Album *)album{
    NSLog(@"Album Created: %@", album);
    if(album!=nil){
        //add photos to album
       // [self addPicture];
    }
    
}

-(void)uploadedPhoto{
    NSLog(@"Photo Uploaded. Yay");
    //Get Albums
    [manager getAlbumsForUser:[manager.ff metaDataForObj:manager.user].guid];
}

-(void)downloadedAlbums:(NSArray *)albums{
    NSLog(@" Albums downloaded %@",albums);
    
}

-(void)receivedAlbums:(NSArray *)albums{
    
}

- (IBAction)showRegistrationScreen:(id)sender {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
    [self.view addSubview: registrationView];
    [UIView commitAnimations];
    [self hideKeyboard];    
}

- (IBAction)showLoginScreen:(id)sender {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
    [registrationView removeFromSuperview];
    [UIView commitAnimations];
    [self hideKeyboard];
}

@end

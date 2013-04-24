//
//  ViewController.m
//  iPictureFrames Lite
//
//  Created by Janusz Chudzynski on 12/21/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//


#define blackBarY 223
#define blackBarTallY 270

#define kFrameCellId @"frameCellId"
#define kEffectCellId @"effectCellId"

#import "ViewController.h"
#import "FrameCell.h"
#import "EffectCell.h"

#import "Content.h"
#import "ContentPack.h"

#import "FilterEffects.h"
#import "FiltersPack.h"
#import "MKStoreManager.h"

#import "Manager.h"
#import "SocialHelper.h"
#import "CameraPicker.h"
#import "PFSharingCenterViewController.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *framesView;
@property (strong, nonatomic) IBOutlet UIView *effectsView;

@property (strong, nonatomic) IBOutlet UIButton *framesTitleButton;
@property (strong, nonatomic) IBOutlet UIImageView *applicationFrame;
@property (strong, nonatomic) IBOutlet UIImageView *photoContainerImgView;
@property (strong, nonatomic) IBOutlet UIImageView *frameContainerImageView;

@property (strong, nonatomic) IBOutlet UIImageView *applicationBackground;

@property (strong, nonatomic) IBOutlet UIView *menuViewHolder;


@property (strong, nonatomic) IBOutlet UICollectionView *framesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *effectsCollectionView;

@property (strong, nonatomic) ContentPack * currentContentPack;
@property (strong, nonatomic) FilterEffects * filterEffects;
@property (strong, nonatomic) FiltersPack * filterPack;

@property (strong, nonatomic) Manager * manager;
@property (strong, nonatomic) IBOutlet UIButton *framesButon;
@property (strong, nonatomic) IBOutlet ADBannerView *bannerView;

@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong,nonatomic) UIPinchGestureRecognizer * pinchGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer * tapGesture;


@property (strong, nonatomic) IBOutlet UIView * framesButtonsContainerView;

@property (strong, nonatomic) IBOutlet UIButton *aboutButton;

- (IBAction)hideFramesFor:(id)sender;
- (IBAction)framesButtonAction:(id)sender;
- (IBAction)photoAction:(id)sender;
- (IBAction)hideEffects:(id)sender;
- (IBAction)showMenu:(id)sender;


@end

@implementation ViewController

UIPopoverController * cameraPopoverController;
UIPopoverController * sharingCenterPopoverController;
UIActionSheet *  photoAction;

Manager * manager;
CameraPicker * camera;
CGRect imageFrame;



- (BOOL)deviceIsAnIPad {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
        //We can test if it's an iPad. Running iOS3.2+
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            return YES; //is an iPad
        else
            return NO; //is an iPhone
        else
            return NO; //does not respond to selector, therefore must be < iOS3.2, therefore is an iPhone
}


- (IBAction)showFramesFor:(id)sender {
     [self hideAll];
    int tag = [sender tag];
    switch (tag) {
        case kChristmas:
        {
            self.currentContentPack = [self searchForContentPack:kChristmasPackName];

          break;
        }
          
        case kAnimals:
        {
            self.currentContentPack = [self searchForContentPack:kAnimalPackName];

            break;
        }

        case kAssorted:
        {
            self.currentContentPack = [self searchForContentPack:kAssortedPackName];
            
        }
            break;

        case kLove:
        {
            self.currentContentPack = [self searchForContentPack:kLovePackName];
            
        }
            break;
         
        case kWood:
        {
            self.currentContentPack = [self searchForContentPack:kWoodPackName];
            
        }
            break;
        
        case kStone:
        {
            self.currentContentPack = [self searchForContentPack:kStonePackName];
            
        }
            break;
        default:
            break;
    }
    if(self.currentContentPack){
        [self.framesTitleButton setTitle:self.currentContentPack.commonName forState:UIControlStateNormal];
        [self.framesCollectionView reloadData];
        
    }
    else{
      //  NSLog(@"Pack doesnt exis..");
    }
    
    
  

    [UIView animateWithDuration:1 animations:^{
   if([self deviceIsAnIPad]){     

  float y = self.menuViewHolder.frame.origin.y - self.framesView.frame.size.height;
    
    self.framesView.frame = CGRectMake(0, y, self.view.frame.size.width, self.framesView.frame.size.height);
        
#warning TO DO
//#warning ADD In-App purchase images FRAMES TO ITUNES CONNECT
//#warning if you want to add frames edit me here...
//#warning to do: add dismissing frames
#warning add info about gestures with NSUserDefaults after adding images
   }
   else{
        float y = self.view.bounds.size.height - self.framesView.frame.size.height -30.0 ;

       self.framesView.frame = CGRectMake(self.framesView.frame.origin.x, y, self.framesView.frame.size.width, self.framesView.frame.size.height);
   
   }
       
    } completion:^(BOOL finished){
            }];
}



     
- (IBAction)hideFramesFor:(id)sender {
    
  
    [UIView animateWithDuration:0.5 animations:^{
        float fh = self.framesView.frame.size.height;
        float sh =self.view.bounds.size.height;
        self.framesView.frame = CGRectMake(self.framesView.frame.origin.x,fh+sh , self.framesView.frame.size.width, self.framesView.frame.size.height);

    } completion:^(BOOL finished){}];
}

- (IBAction)showEffects:(id)sender {
    [self hideAll];
    [UIView animateWithDuration:1 animations:^{
        if([self deviceIsAnIPad]){
        float y = self.menuViewHolder.frame.origin.y - self.framesView.frame.size.height;
            
        self.effectsView.frame = CGRectMake(0, y, self.view.frame.size.width, self.effectsView.frame.size.height);
        }
        else{
            float y = self.view.bounds.size.height - self.effectsView.frame.size.height -30.0 ;
         self.effectsView.frame = CGRectMake(self.effectsView.frame.origin.x, y, self.effectsView.frame.size.width, self.effectsView.frame.size.height);   
        
        }
    }
                     completion:^(BOOL finished){
                         
    }];

}

- (IBAction)hideEffects:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        float fh = self.framesView.frame.size.height;
        float sh =self.view.bounds.size.height;
        self.effectsView.frame = CGRectMake(self.effectsView.frame.origin.x,fh+sh , self.effectsView.frame.size.width, self.effectsView.frame.size.height);
        
    } completion:^(BOOL finished){}];
}




- (IBAction)showMenu:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController * vc = [story instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
    //[self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)hideAll{
    [self hideFramesFor:nil];
    [self hideEffects:nil];
}

#pragma mark gestures

-(void)viewTappedOn:(UITapGestureRecognizer *)tapGesture{
    if(tapGesture.view == self.view){
        [self hideAll];
        
    }
}

-(void)viewPanOn:(UIPanGestureRecognizer *)recognizer{
    
    UIView * t= _photoContainerImgView;// recognizer.view;
    CGPoint center = [recognizer translationInView:[t superview]];
    //[t setCenter:CGPointMake(t.center.x + center.x, t.center.y + center.y)];
    //  t.transform =    CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y);
    
    imageFrame =   CGRectApplyAffineTransform(imageFrame, CGAffineTransformTranslate(self.photoContainerImgView.transform, center.x, center.y));
    self.photoContainerImgView.frame = imageFrame;
    
    [recognizer setTranslation:CGPointZero inView:[t superview]];
    
    
}

-(void)viewPinchOn:(UIPinchGestureRecognizer *)recognizer{
    //_photoContainerImgView.transform = CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
    CGAffineTransform  transform = CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
    //    CGRect transformedRect = CGRectApplyAffineTransform[self.frameContainerImageView.frame,
    
    
    CGRect tf =CGRectApplyAffineTransform(_photoContainerImgView.bounds, transform);
    CGRect fRect = self.frameContainerImageView.frame;
    
    
    if(tf.size.width <=fRect.size.width * 2 && tf.size.width>250)
    {
        //_photoContainerImgView.transform = transform;//CGAffineTransformScale(self.photoContainerImgView.transform, recognizer.scale, recognizer.scale);
        // NSLog(@"Affine Transform %f,", _photoContainerImgView.transform.tx);
        _photoContainerImgView.frame= tf;
        _photoContainerImgView.center = self.frameContainerImageView.center;
        imageFrame =_photoContainerImgView.frame;
        
        
        
        
    }
    recognizer.scale = 1;
}



-(void)viewWillAppear:(BOOL)animated{
    [self hideAll];
    [self manageOrientation];
    [manager dismissPopovers];
    NSLog(@"Will Appear");
    self.navigationController.navigationBarHidden = YES;
    if(!self.imageToDisplay)
    {if(manager.defaultFrame){
        self.frameContainerImageView.image= manager.defaultFrame;

    }
    if(manager.modifiedImage)
    {
        self.photoContainerImgView.image = manager.modifiedImage;
    }
    imageFrame = self.photoContainerImgView.frame;
}
}
-(void)viewDidDisappear:(BOOL)animated{
    manager.modifiedImage = self.photoContainerImgView.image;
    manager.defaultFrame = self.frameContainerImageView.image;
    
    self.navigationController.navigationBarHidden = NO;
   
    
}


-(ContentPack *)searchForContentPack:(NSString *)contentPackName{
    SharedStore * sharedStore = [SharedStore sharedStore];
    NSMutableArray * array = [sharedStore updateItems];
    
    for(ContentPack * cp in array)
    {
        if ([cp.commonName isEqualToString:contentPackName]) {
            return cp;
        }
        
    }
    return nil;
}



-(void)manageOrientation{
    float pfx = 86;
    float pfy = 146;
    
    float pfw = 595;
    float pfh = 706;
   
    
    float lfx = 155;
    float lfy = 107;
    
    float lfw = 706;
    float lfh = 587;
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    
    CGRect pFrame =  CGRectMake(pfx, pfy, pfw, pfh);
    CGRect lFrame =  CGRectMake(lfx, lfy, lfw, lfh);
    
    UIView * vup = [[UIView alloc]init];
    UIView * vleft = [[UIView alloc]init];
    UIView * vright = [[UIView alloc]init];
    UIView * vbottom = [[UIView alloc]init];
    
    vup.backgroundColor = [UIColor blackColor];
    vleft.backgroundColor = [UIColor blackColor];
    vright.backgroundColor = [UIColor blackColor];
    vbottom.backgroundColor = [UIColor blackColor];
    
    if([self deviceIsAnIPad]){
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.applicationFrame.image = [UIImage imageNamed:@"ApplicationFrame"];
                vup.frame = CGRectMake(0,0,width, lfy);
                vleft.frame = CGRectMake(0,0,lfx, height);
                vright.frame = CGRectMake(lfx + lfw,0,width - (lfx +lfw), height);
                vbottom.frame = CGRectMake(0,lfy+lfh,width,height-(lfy+lfh));
                self.frameContainerImageView.frame =lFrame;
                         
            } completion:^(BOOL finished){

                self.photoContainerImgView.center = self.view.center;
  
            
            }];
            
        }
        else{
            [UIView animateWithDuration:0.1 animations:^{
                self.applicationFrame.image = [UIImage imageNamed:@"ApplicationFramePortrait"];
              
                vup.frame = CGRectMake(0,0,width, pfy);
                vleft.frame = CGRectMake(0,0,pfx, height);
                vright.frame = CGRectMake(pfx + pfw,0,width - (pfx +pfw), height);
                vbottom.frame = CGRectMake(0,pfy+pfh,width,height-(pfy+pfh));
                
                self.frameContainerImageView.frame =pFrame;
                self.photoContainerImgView.center = self.frameContainerImageView.center;
                
            } completion:^(BOOL finished){}];
        }
    }
    else{
//        float bannerh = 30.0;
//        float buttonsh = 30.0;
        self.applicationFrame.image = nil;
        
        NSLog(@"Bounds %fFrame %f ",self.view.bounds.size.width, self.view.frame.size.width);
//        CGRect piFrame = CGRectMake(0, bannerh*3, self.view.bounds.size.width, self.view.bounds.size.height - 6 *  bannerh);
//        CGRect liFrame = CGRectMake(3 *buttonsh, bannerh, self.view.bounds.size.width-6 * buttonsh, self.view.bounds.size.height - buttonsh - bannerh);
        
//        liFrame = CGRectMake(90, 30, 300, 208);
//        piFrame= CGRectMake(0, 186, 320, 320);
        
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
//            self.photoContainerImgView.frame = liFrame;
//            self.frameContainerImageView.frame = liFrame;
//        }
//        else{
//            self.photoContainerImgView.frame = piFrame;
//            self.frameContainerImageView.frame =piFrame;
        }
        NSLog(@"Frame after %@ ",self.frameContainerImageView);
    
    }
    //User Interface changes.
    [self.view addSubview:self.applicationBackground];
    [self.view addSubview:self.photoContainerImgView];
    [self.view addSubview:vup];
    [self.view addSubview:vleft];
    [self.view addSubview:vright];
    [self.view addSubview:vbottom];

    
    [self.view addSubview:self.frameContainerImageView];
    [self.view addSubview:self.framesView];
    [self.view addSubview:self.effectsView];
    
    [self.view addSubview:self.framesButtonsContainerView];
    [self.view addSubview:self.menuViewHolder];
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.bannerView];

    
#warning add more views
    
    
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    camera = [[CameraPicker alloc]init];
    
    self.panGestureRecognizer =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanOn:)];
    self.pinchGestureRecognizer =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(viewPinchOn:)];
    
    [self.frameContainerImageView addGestureRecognizer:self.panGestureRecognizer];
    [self.frameContainerImageView addGestureRecognizer:self.pinchGestureRecognizer];
    
    self.frameContainerImageView.userInteractionEnabled = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
     self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTappedOn:)];
    [self.tapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:self.tapGesture];
    
    if(!_filterEffects){
        _filterEffects = [[FilterEffects alloc]init];
    }
    if(!_filterPack){
        _filterPack = [[FiltersPack alloc]init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveImageNotification:)
                                                 name:@"ImageNotification"
                                               object:nil];
    SharedStore * st =[SharedStore sharedStore];
    st.delegate =self;
    _manager = [Manager sharedInstance];
    if(self.imageToDisplay){
        NSLog(@" assigning  ");
        self.photoContainerImgView.image = self.imageToDisplay;

    }
    _manager.defaultImage = self.photoContainerImgView.image;
     self.navigationController.navigationBarHidden = YES;
    _manager.currentNavigationController = self.navigationController;
    [self manageOrientation];
    
}

-(void)purchaseCompleted{
    [self.framesCollectionView reloadData];
}

-(void) receiveImageNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"ImageNotification"])
    {
       
        [UIView animateWithDuration:0.5 animations:^{
            self.photoContainerImgView.image= notification.object;
            
        } completion:^(BOOL finished){
        }];   }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self manageOrientation];
    [self hideAll];
   
    
}

     
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
      
}

#pragma mark Collection View
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //need a quick check if we already bought it.
    if([self.framesCollectionView isEqual:collectionView]){
        if([MKStoreManager isFeaturePurchased:self.currentContentPack.key])
        {
            return 1;
        }
            else{
    
            return 2;//
            }
    }
    else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.framesCollectionView isEqual:collectionView]){

        if(section ==0)
        {
            return self.currentContentPack.freeContent.thumbnails.count;
        }
    else{
        return self.currentContentPack.premiumContent.thumbnails.count;
        }
        return 0;

    }
    else{
        NSLog(@"FIlters pack %d",self.filterPack.filtersImages.count);
        
       return  self.filterPack.filtersImages.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if([collectionView isEqual:_framesCollectionView]){
        FrameCell * cell =   [collectionView dequeueReusableCellWithReuseIdentifier:kFrameCellId forIndexPath:indexPath];
  
    if(indexPath.section==0){
        cell.photoFrame.image = [self.currentContentPack.freeContent.thumbnails objectAtIndex:indexPath.row];
        cell.locked= false;
     return cell;
    }
    else{
        
        cell.photoFrame.image = [self.currentContentPack.premiumContent.thumbnails objectAtIndex:indexPath.row];
        cell.locked= true;
    }
        return cell;
    }
    
    else{
        EffectCell * cell =   [collectionView dequeueReusableCellWithReuseIdentifier:kEffectCellId forIndexPath:indexPath];
        cell.photo.image = [UIImage imageNamed:[self.filterPack.filtersImages objectAtIndex:indexPath.row]];
        cell.effectLabel.text = [self.filterPack.filtersNames objectAtIndex:indexPath.row];

        return cell;
    }
       
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([collectionView isEqual:self.framesCollectionView]){
        if(indexPath.section==0){
            [UIView animateWithDuration:0.5 animations:^{
                self.frameContainerImageView.image = [self.currentContentPack.freeContent.images objectAtIndex:indexPath.row];

            } completion:^(BOOL finished){
                _manager.defaultFrame = [self.currentContentPack.freeContent.images objectAtIndex:indexPath.row];
            }];

        self.framesButon.selected = YES;
            
        }
        else{
            [self performSegueWithIdentifier:@"openStoreId" sender:nil];
        
        }
    }
    else{
       
        self.filterEffects.image = _manager.defaultImage;
        [self.filterEffects filterSelected:[CIFilter filterWithName:[self.filterPack.filters objectAtIndex:indexPath.row]]];
    
    }
}


- (IBAction)framesButtonAction:(id)sender {
    UIButton * button = (UIButton *)sender;
     button.selected = !button.selected;
    if(!button.selected){
        [UIView animateWithDuration:1 animations:^{
            self.frameContainerImageView.image = nil;
        } completion:^(BOOL finished){
        }];
    }
    else{
        [UIView animateWithDuration:1 animations:^{
            self.frameContainerImageView.image = _manager.defaultFrame;
        } completion:^(BOOL finished){
        }];
    }
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    if([actionSheet isEqual:photoAction]){
        if(buttonIndex==0) // make photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.framesButon picker:NO andPopover:cameraPopoverController];
        }
        else//pick photo
        {
            [camera startCameraControllerFromViewController:self usingDelegate:self from:self.framesButon picker:YES andPopover:cameraPopoverController];
        }
    }
}


- (IBAction)photoAction:(id)sender {
    
    photoAction=[[UIActionSheet alloc]initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Photo", @"Photo Library", nil];
    [photoAction showInView:self.view];
}


- (IBAction)shareAction:(id)sender {
    UIImage * resultImage = [self createScreenshot];
    [manager showSharingCenterForPhoto:resultImage andPopover:sharingCenterPopoverController inView:self.view andNavigationController:self.navigationController fromBarButton:self.framesButon];

}



#pragma mark banner
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == (UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown));
}

- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation) [[UIDevice currentDevice] orientation];
    
    if (orientation==UIInterfaceOrientationPortrait) {
        // do some sh!t
        return YES;
    }
    
    return NO;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    
    return UIInterfaceOrientationPortrait;
    
}

- (void)viewDidLayoutSubviews
{
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
}

- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    //CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        //       contentFrame.size.height = _bannerView.frame.size.height;
        bannerFrame.origin.y =0;// contentFrame.size.height;
    } else {
        bannerFrame.origin.y =  -_bannerView.frame.size.height;// contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
}

-(UIImage *)createScreenshot{
    UIImage * resultImage;
    float xo = self.frameContainerImageView.frame.origin.x;
    float yo = self.frameContainerImageView.frame.origin.y;
    float wo = self.frameContainerImageView.frame.size.width;
    float ho = self.frameContainerImageView.frame.size.height;
    
    float xi = imageFrame.origin.x;
    float yi = imageFrame.origin.y;
    float wi = imageFrame.size.width;
    float hi = imageFrame.size.height;
    
    float aspect;
    float hnew;
    float wnew;
    
    float maxSize = 640.0;
    
    aspect = ho/wo;
    if(ho>wo){ // portrait
        hnew =maxSize;
        wnew= maxSize * wo/ho;
    }
    else{
        wnew =maxSize;
        hnew= maxSize * ho/wo;
    }
    
    float wScaleAspect = wnew/wo;
    float hScaleAspect = hnew/ho;
    //Will be used for drawing final images in and resizing the images.
    CGSize newSize = CGSizeMake(wnew, hnew);
    float wt = wi * wScaleAspect;
    float ht = hi * hScaleAspect;
    
   // NSLog(@"W %f H %f %f",wt, ht,wScaleAspect);
   // NSLog(@"W %f H %f %f ",wnew, hnew, hScaleAspect);
    //Resize to the frame...
    UIImage * photoImage =   [self.photoContainerImgView.image imageByScalingProportionallyToSize:CGSizeMake(wt, ht)];
    
    //Scaling coordinates
    xo *=wScaleAspect;
    yo *=wScaleAspect;
    wo *=wScaleAspect;
    ho *=wScaleAspect;
    
    xi *=wScaleAspect;
    yi *=wScaleAspect;
    wi *=wScaleAspect;
    hi *=wScaleAspect;
    
    //Checking the cases:
    // 1
    CGRect cropFrame;
    CGRect drawFrame;
    if(xi<=xo&&yi<=yo)
    {
        float dx =(xo-xi);//*wScaleAspect;
        float dy =(yo-yi);//*hScaleAspect;
        float dw =(wi - dx);//*wScaleAspect;
        float dh =(hi - dy);//*hScaleAspect;
        
        cropFrame = CGRectMake(dx, dy, dw, dh);
        drawFrame = CGRectMake(0, 0, dw, dh);
    }
// 2
    if(xi>=xo&&yi<=yo)
    {
        float dx =(xi-xo);
        float dy =(yo-yi);
        float dw =(wo - dx);
        float dh =(hi - dy);
        
        cropFrame = CGRectMake(0, dy, dw, dh);
        drawFrame = CGRectMake(dx, 0, dw, dh);
    }
    // 3
    if(xi<=xo&&yi>yo)
    {
        float dx =(xo-xi);
        float dy =(yi-yo);
        float dw =(wi - dx);
        float dh =(ho - dy);
        
        cropFrame = CGRectMake(dx, 0, dw, dh);
        drawFrame = CGRectMake(0, dy, dw, dh);
    }
// 4
    if(xi>=xo&&yi>yo)
    {
        float dx =(xi-xo);
        float dy =(yi-yo);
        float dw =(wo - dx);
        float dh =(ho - dy);
        
        //Rect is inside the frame and doesn't interact
        if(wi<wo&&hi<ho)
        {
          //  NSLog(@"Case Inside Inside %f %f %f %f",dx,dy,dw,dh);
            
            cropFrame =CGRectMake(0, 0, wi, hi);
            drawFrame = CGRectMake(dx, dy, wi, hi);
        }
        else{
            cropFrame = CGRectMake(0, 0, dw, dh);
            drawFrame = CGRectMake(dx, dy, dw, dh);
        }
    }
    
    
    CGRect newFrame = CGRectZero;
    newFrame.size = newSize;
    
    photoImage = [photoImage crop:cropFrame];
    
    UIImage *  frameImage = [UIImage imageWithImage:self.frameContainerImageView.image scaledToSize:newFrame.size];
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    if(photoImage){
        [photoImage drawInRect:drawFrame];
    }
    
    if(frameImage){
        [frameImage drawInRect:newFrame];
    }
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData * pngData = UIImagePNGRepresentation(resultImage);
    pngData = UIImageJPEGRepresentation(resultImage, 0.7);
    resultImage = [UIImage imageWithData:pngData];

//    NSData *imageData;
//    if ( /* PNG IMAGE */ )
//        imageData = UIImagePNGReprensentation(selectedImage);
//    else
//        imageData = UIImageJPEGReprensentation(selectedImage);
    
    NSUInteger fileLength = [pngData length];
    NSLog(@"file length : [%u]", fileLength);
    
    
    
    return resultImage;
}


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
   
    
    UIImage *originalImage, *editedImage;
    UIImage * imageToUse;
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        imageToUse = [info objectForKey: UIImagePickerControllerEditedImage];
       
        NSLog(@"Image Size %f  %f",imageToUse.size.height,imageToUse.size.width);

    //imageToUse = UIImageJPEGRepresentation(imageToUse, 0.60);
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [cameraPopoverController dismissPopoverAnimated:YES];
    
    self.photoContainerImgView.image = imageToUse;
    _manager.defaultImage = imageToUse;
    _manager.modifiedImage = imageToUse;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"menu"]) {
        [segue.destinationViewController performSelector:@selector(setCurrentNavigationController:)
                                              withObject:self.navigationController];
        NSLog(@"Segue menu");
    }
}


@end

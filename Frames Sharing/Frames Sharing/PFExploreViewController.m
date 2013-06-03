//
//  PFExploreViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFExploreViewController.h"
#import "PFExploreCell.h"
#import "Photo.h"
#import "PFDisplayPhotoViewController.h"
#import "LoginRegisterViewController.h"
#import "PFProfileViewController.h"

@interface PFExploreViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *searchStatus;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation PFExploreViewController
Manager * manager;
NSMutableArray * currentPhotoArray;
NSMutableArray * allPhotosArray;
UIPopoverController * profilePopover;
#pragma mark iPad Methods
MBProgressHUD *hud;
NSOperationQueue *_queue;
NSMutableDictionary *  currentOperations;
NSMutableDictionary *  currentPhotos;


#pragma mark end of iPad

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    _queue = [NSOperationQueue new];
    currentOperations =[[NSMutableDictionary alloc]initWithCapacity:0];
    currentPhotos=[[NSMutableDictionary alloc]initWithCapacity:0];
    
       
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchCompletedWithResults:) name:photosRetrievedFromSearchNotification object:nil];
    
    if(!currentPhotoArray){
        currentPhotoArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    else{
        [currentPhotoArray removeAllObjects];
    }

    if(!allPhotosArray){
        allPhotosArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    else{
        [allPhotosArray removeAllObjects];
    }

    
    if(self.navigationController){
        manager.currentNavigationController = self.navigationController;
    }
    
    
    if(!self.favoritesMode){
       [manager getNewestPhotos];
        hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
        hud.labelText = @"Loading";
       
    }
    else{
        self.title = @"My Favorite Photos";
        self.user = manager.user;
         self.searchBar.hidden = YES;
        //[self.collectionView reloadData];
    

    }
}





-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:photosRetrievedFromSearchNotification object:nil];
    [_queue cancelAllOperations];
    manager.ff.autoLoadBlobs = NO;
    
}



-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchCompletedWithResults:) name:photosRetrievedFromSearchNotification object:nil];
}

- (IBAction)loginOrSignUp:(UIBarButtonItem *)sender {
    LoginRegisterViewController *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPopover"];
    [self.navigationController pushViewController:pf animated:YES];
}


-(IBAction)showProfile{
    if(manager.user){
        PFProfileViewController * p;
        UIStoryboard * st;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = manager.user;
            
            if([profilePopover isPopoverVisible]){
                [profilePopover dismissPopoverAnimated:YES];
            }
            
            if(!profilePopover)
            {
                profilePopover = [[UIPopoverController alloc]initWithContentViewController:p];
            }
            
            else{
                [profilePopover presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
            
        }
        else{
            st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = manager.user;
            [self.navigationController pushViewController:p animated:YES];
            
        }
    }
    else
    {
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController andViewController:self];
    }
}



#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFDisplayPhotoViewController * pdp;
    Photo * p;
    if(self.favoritesMode)
    {
       NSString * guid =  [self.user.favoritePictures objectAtIndex:indexPath.row];
        p = [currentPhotos objectForKey:guid];
        
    }
    else{
         p = [currentPhotoArray objectAtIndex:indexPath.row];

    }
     
    pdp= [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayPhotoViewController"];
    pdp.photo = p;
    //NSLog(@"%@",p);
    [self.navigationController pushViewController:pdp animated:YES];
 
    [pdp changeDescription:p.description];
    [pdp changeImage:[UIImage imageWithData:p.imageData]];
    
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    if(self.favoritesMode){
        return self.user.favoritePictures.count;
    }
    
    return [currentPhotoArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFExploreCell*cell =  (PFExploreCell*) [cv dequeueReusableCellWithReuseIdentifier:@"ExploreCell" forIndexPath:indexPath];
    
    NSString * guid = [self updateCollectionViewForIndexPath:indexPath andCell:cell];
    if(!guid) return cell;
    
    if([currentPhotos objectForKey:guid]){
    
        cell.imageView.image =[UIImage imageWithData:[[currentPhotos objectForKey:guid]thumbnailImageData]];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"images.jpg"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //get photo guid.
   NSString * guid;
    
    
    
    if(currentOperations.count>0){
        
        if(self.favoritesMode){
            guid = [self.user.favoritePictures objectAtIndex:indexPath.row];
        
        }
        else{
                
            Photo * photo =  [currentPhotoArray objectAtIndex:indexPath.row];
            if(![photo guid])
            {
            // it doesn't have a guid. Let's load one.
                guid=[manager getGUID:photo];
            }
            else{
                guid =photo.guid;
            }
        }
        NSOperation * operation = [currentOperations objectForKey:guid];
        if(operation){
            [operation cancel];
            [currentOperations removeObjectForKey:guid];
            
        }
        else{

        }
    }
}



-(NSString *)updateFavoriteCollectionViewForIndexPath:(NSIndexPath*)indexPath andCell:(PFExploreCell *)cell{
    NSString  * guid =  [self.user.favoritePictures objectAtIndex:indexPath.row];
    if([currentPhotos objectForKey:guid]){
        [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
    }
    else{
        NSBlockOperation * loadImage = [[NSBlockOperation alloc]init];
        __weak NSBlockOperation * weak = loadImage;
        [MBProgressHUD showHUDAddedTo:cell.imageView animated:YES];
        
        [loadImage addExecutionBlock:^{
            if(!weak.isCancelled)
            {
                manager.ff.autoLoadBlobs = YES;
                NSError * error = nil;
                Photo * photo = [manager.ff getObjFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/(guid eq'%@')",guid] error:&error];
                if(!photo.guid){
                    photo.guid = guid;
                }
                if(photo){
                    [currentPhotos setObject:photo forKey:guid];
                
                }
                //we don't want to load blobs automatically.
                manager.ff.autoLoadBlobs = NO;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    PFExploreCell * cell = (PFExploreCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image =[UIImage imageWithData:photo.thumbnailImageData];
                    [currentOperations removeObjectForKey:guid];
                    [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
                }];                
            }
        }];
    }

    return guid;
}



-(NSString *)updateCollectionViewForIndexPath:(NSIndexPath*)indexPath andCell:(PFExploreCell *)cell{

    NSString * guid;
    if(self.favoritesMode)
    {
        guid = [self.user.favoritePictures objectAtIndex:indexPath.row];
    }
    else{
        Photo * photo =  [currentPhotoArray objectAtIndex:indexPath.row];
        if(![photo guid])
        {
            // it doesn't have a guid. Let's load one.
            guid = [manager getGUID:photo];
        }
        else{
            guid = [photo guid];
        }

    
    }

    
    if([currentPhotos objectForKey:guid]){

        [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
    }
    else{
      
    NSBlockOperation * loadImage = [[NSBlockOperation alloc]init];
    __weak NSBlockOperation * weak = loadImage;
    [MBProgressHUD showHUDAddedTo:cell.imageView animated:YES];

        [loadImage addExecutionBlock:^{
            if(!weak.isCancelled)
            {
               
                manager.ff.autoLoadBlobs = YES;
                NSError * error = nil;
                Photo * photo = [manager.ff getObjFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/(guid eq'%@')",guid] error:&error];
                if(!photo.guid){
                    photo.guid = guid;
                }
                if(photo){
                    [currentPhotos setObject:photo forKey:guid];
                    [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
                    
                }
                else{
                    //NSLog(@" there was an error");
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    PFExploreCell * cell = (PFExploreCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image =[UIImage imageWithData:photo.thumbnailImageData];
                    [currentOperations removeObjectForKey:guid];
                    [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
                }];
            }
            else{
                NSLog(@"Operation is cancelled");
                [MBProgressHUD hideAllHUDsForView:cell.imageView animated:NO];
            
            }
        }];
        
        if(loadImage)
        {
            [_queue addOperation:loadImage];
           // NSLog(@" _queue %@",_queue);
            
            [currentOperations setObject:loadImage forKey:guid];
            
        }
    }
    return guid;
   }

#pragma mark Search Bar

- (IBAction)refreshButtonClicked:(id)sender
{
    [self searchBarSearchButtonClicked:self.searchBar];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [currentOperations removeAllObjects];
    [currentPhotoArray removeAllObjects];
    [allPhotosArray removeAllObjects];
    
    [self.collectionView reloadData];
    
    if(self.searchBar.text.length==0)
    {
        [manager getNewestPhotos];
    }else{
        [manager getPhotosWithSearchQuery:self.searchBar.text];    
    }
    
    [self.searchBar resignFirstResponder];
    self.searchStatus.text = @" Searching ";
       
}

-(void)searchCompletedWithResults:(NSNotification *)notification{
    NSArray * array = notification.object;
    
    NSLog(@"All Photos array: %d",allPhotosArray.count);
    allPhotosArray = (NSMutableArray *) array;
    [currentPhotoArray removeAllObjects];
    int c = allPhotosArray.count - currentPhotoArray.count;
    if(c>16)
    {
        c = 16;
    }
    
    for (int i = currentPhotoArray.count;i<allPhotosArray.count;i++ )
    {
        [currentPhotoArray addObject:[allPhotosArray objectAtIndex:i]];
        c--;
        if(c==0){break;}
    }

    [self.collectionView reloadData];
    //NSLog(@"Search completed with results");
    if(allPhotosArray.count == 0)
    {
         self.searchStatus.text = @" No results found. Try different query. ";
    }
    else{
         self.searchStatus.text = @"";
    }
    
     [hud hide:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
        int c = allPhotosArray.count - currentPhotoArray.count;
        if (c == 0 ) return;
        
        if(c>16)
        {
            c = 16;
        }
    
        
        for (int i = currentPhotoArray.count;i<allPhotosArray.count;i++ )
        {
            [currentPhotoArray addObject:[allPhotosArray objectAtIndex:i]];
            c--;
            if(c==0){break;}
        }
        
            [self.collectionView reloadData];
        
        //testing
        NSLog(@"End ");
       // [_queue cancelAllOperations];
    }
}




- (IBAction)getAll:(id)sender {
      [manager getNewestPhotos];
}




- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [allPhotosArray removeAllObjects];
    [currentPhotoArray removeAllObjects];
    if(searchBar.selectedScopeButtonIndex == 0)
    {
       [manager getNewestPhotos];
    }
    else{
        [self searchBarSearchButtonClicked:searchBar];
    }    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"menu"]) {
        [segue.destinationViewController performSelector:@selector(setCurrentNavigationController:)
                                              withObject:self.navigationController];
    
    }
}



@end

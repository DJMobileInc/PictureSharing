//
//  PFPickAlbumViewController.m
//  Frames Sharing
//
//  Created by sadmin on 4/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFPickAlbumViewController.h"
#import "Manager.h"
#import "AlbumPickerListData.h"
#import "Album.h"

@interface PFPickAlbumViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *objects;
@property (strong, nonatomic)NSString *albumName;


@end

@implementation PFPickAlbumViewController
Manager * manager;
AlbumPickerListData * albumsList;
UIAlertView * photoDescriptionAlert;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    [manager.ff setAutoLoadBlobs:NO];
    self.user = manager.user;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumCreated:) name:albumCreatedNotification object:nil];
        [manager getAlbumsForUser:[manager.ff metaDataForObj:manager.user].guid];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoCreated:) name: photoCreatedNotification object:nil];
    [manager getAlbumsForUser:[manager.ff metaDataForObj:manager.user].guid];
   
    //hide elements if not my album
    
    albumsList = [[AlbumPickerListData alloc]init];
    albumsList.storyboard  = self.storyboard;
    albumsList.navigationController = self.navigationController;
    
    self.tableView.dataSource  = albumsList;
    self.tableView.delegate =self;
}
-(void)photoCreated:(NSNotification *)notification{
    [manager displayMessage:@"Added Photo"];
    NSLog(@"Photo Added");
}

-(void)albumCreated:(NSNotification *)notification{
    [manager getAlbumsForUser:[manager.ff metaDataForObj:manager.user].guid];    
}
-(void)albumsRetrieved:(NSNotification *)notification{
    albumsList.objects = notification.object;
    [self.tableView reloadData];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (IBAction)selectAlbum:(id)sender {
    
    photoDescriptionAlert = [[UIAlertView alloc]initWithTitle:@"Add Photo" message:@"Add short description of the photo." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Photo" , nil];
    photoDescriptionAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [photoDescriptionAlert show];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeNewAlbum:(UIBarButtonItem *)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Album Name" message:@"Name this album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == photoDescriptionAlert){
            
        if(buttonIndex == 1) {
            NSIndexPath * path = [self.tableView indexPathForSelectedRow];
            if(path){
                int index =path.row;
                if(index >=0){
                    NSString * userGuid = [manager.ff metaDataForObj:manager.user].guid;
                    
                    Album * album = [self.objects objectAtIndex:index];
                    [manager createNewPhotoWithDescription:[alertView textFieldAtIndex:0].text forUser:userGuid forAlbum:[manager getGUID:album] withData:UIImageJPEGRepresentation(self.imageToShare, 0.7)];
                    
                }
            }
 
        
        }
    }
    else{
    if(buttonIndex == 1) {
        self.albumName = [alertView textFieldAtIndex:0].text;
        
        NSLog(@"album name is %@ %d",self.albumName,self.albumName.length );
        
        if(self.albumName.length>0){
            [self createAlbum:self.albumName];
        }
        else{
            NSLog(@"Length is wrong ??? album name is %@ %d",self.albumName,self.albumName.length );
            
            [manager displayMessage:@"Don't forget about album's title."];
        }
    }
  }
}


-(void)createAlbum:(NSString *)name{
    
    if(manager.user){
        [manager createNewAlbumOfName:name forUser:[manager getGUID:manager.user] privacy:YES];
    }
    else{
        [manager displayMessage:@"You need to be logged in to create new album on the cloud."];
    }
}

//delegate methods
-(void)createdAlbum:(Album *)album{
    //    NSLog(@"Album Created: %@", album);
    [self.objects addObject:album];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.objects.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Album * album = (Album *)self.objects[indexPath.row];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //[manager getPhotosForAlbum:[manager getGUID:album]];
    }
    else{
        
    
    }
}




@end

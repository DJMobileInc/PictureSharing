//
//  InternalStoreViewController.m
//  GiftMaker
//
//  Created by Janusz Chudzynski on 11/27/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "InternalStoreViewController.h"
#import "SharedStore.h"
#import "StoreItemsViewController.h"
#import "ContentPack.h"
#import "Content.h"
#define kSectionBackgrounds 0
#define kSectionDecorations 1
@interface InternalStoreViewController()
{

    IBOutlet UITableView *tableView;
SharedStore * store;
NSMutableArray * items;
}



@end



@implementation InternalStoreViewController
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate{
    return YES;
}

- (IBAction)dismissController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        store = [SharedStore sharedStore];
        if(!items){
            items = [store updateItems];
        }
            
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(!store){
        store = [SharedStore sharedStore];
    }
    if(!items){
        items = [store updateItems];
    }
    tableView.backgroundColor = [UIColor clearColor];
    
    NSLog(@"Items %@",items);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    //Either background or decoration dictionary
//    NSDictionary * tempDict = [items objectForKey:[[items allKeys]objectAtIndex:section]];
//
//    int count = [[[tempDict objectForKey:@"Premium"]allKeys]count];
    int count = items.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * kIdentifier = @"kCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
         
    cell.textLabel.text = [[items objectAtIndex:indexPath.row]commonName];
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;// [[items allKeys]count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [[items allKeys] objectAtIndex:section];
//}

//
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    
//    NSLog(@"Push Segue will be executed ");
//    return YES;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreItemsViewController * storeItemsController =[self.storyboard instantiateViewControllerWithIdentifier:@"storeItemsViewControllerStoryboardId"];

//    NSDictionary *images;
//    if(indexPath.section == kSectionBackgrounds){

    ContentPack * cp = [items objectAtIndex:indexPath.row];
    Content * content = cp.premiumContent;
    storeItemsController.images = content;
    storeItemsController.key = [[items objectAtIndex:indexPath.row]key];
    NSLog(@" %@ ", cp.key);
    NSLog(@" %@ ", cp.commonName);
    
    [self.navigationController pushViewController:storeItemsController animated:YES];
    
}




- (IBAction)restorePurchases:(id)sender {
    [store restorePreviousPurchases];
}
@end

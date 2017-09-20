//
//  feedView.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "feedView.h"

#define SMALL 293
#define BIG 458

@interface feedView ()

@end

@implementation feedView

- (void)viewDidLoad {
    currentStyle = UIStatusBarStyleDefault;
    receiptScroll.frame = CGRectMake(0, [References screenHeight], [References screenWidth], receiptScroll.frame.size.height);
    blackOverlay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [blackOverlay setBackgroundColor:[UIColor blackColor]];
    blackOverlay.alpha = 0;
    [self.view addSubview:blackOverlay];
    [self.view bringSubviewToFront:blackOverlay];
    [self.view bringSubviewToFront:receiptScroll];
    [References lightCardShadow:receiptShadow];
    [References cornerRadius:confirmOrder radius:8.0f];
    [References cornerRadius:cancelOrder radius:8.0f];
    [References cornerRadius:receiptCard radius:17.0f];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    statusBar = NO;
    foodItems = [[NSMutableArray alloc] init];
        expandedRow = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Items" predicate:predicate];
    [[CKContainer defaultContainer].publicCloudDatabase performQuery:query
                                                        inZoneWithID:nil
                                                   completionHandler:^(NSArray *results, NSError *error) {
                                                       for (int a = 0; a < results.count; a++) {
                                                           CKRecord *record = results[a];
                                                           CKAsset *imageData = [record objectForKey:@"image"];
                                                           NSNumber *qty = [record valueForKey:@"qty"];
                                                           NSNumber *price = [record valueForKey:@"price"];
                                                           NSNumber *delivers = [record valueForKey:@"delivers"];
                                                           NSNumber *zip = [record valueForKey:@"zip"];
                                                           UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageData.fileURL]];
                                                           foodItem *food = [[foodItem alloc] initWithImage:image andName:[record valueForKey:@"name"] andDescription:[record valueForKey:@"descript"] andItem:[record valueForKey:@"item"] andQty:qty andZip:zip andDelivers:delivers andAllergy:[record valueForKey:@"allergy"] andSeller:[record valueForKey:@"seller"] andPrice:price];
                                                           [foodItems addObject:food];
                                                           [expandedRow addObject:@"SMALL"];
                                                       }
                                                       dispatch_async(dispatch_get_main_queue(), ^(){
                                                           [table reloadData];
                                                       });
                                                   }];
    
    [References tintUIButton:feedButton color:[header.textColor colorWithAlphaComponent:0.7] ];
    [References tintUIButton:postButton color:[header.textColor colorWithAlphaComponent:0.5]];
    [References blurView:backgroundBlur];
    [References blurView:bottomBarBlur];
    [References cornerRadius:userImage radius:userImage.frame.size.height/2];
    [References createLine:bottomBar xPos:0 yPos:0 inFront:YES];
    [super viewDidLoad];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,email,picture.width(200).height(200)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"id"] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"email"] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"\n%@\n%@\n%@\n",[result valueForKey:@"name"],[result valueForKey:@"email"],[result valueForKey:@"id"]);
            NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringOfLoginUser]]];
            [userImage setBackgroundImage:image forState:UIControlStateNormal];
            
        }
    }];
    [userImage
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

-(void)loginButtonClicked {

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Account Management" message:@"More stuff will be here later." preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {\
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"signedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"startView"];
        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:vc animated:YES completion:nil];
        
    }]];


    
  
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"feedCell";

    feedCell *cell = (feedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"feedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    foodItem *food = foodItems[indexPath.row];
    cell.name.text = food.name;
    cell.descript.text = food.descript;
    [cell.image setImage:food.image];
    [References lightCardShadow:cell.shadow];
    [References lightCardShadow:cell.actualShadow2];
    [References lightCardShadow:cell.payShadow];
    [References lightCardShadow:cell.actualShadow3];
    LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
    LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:food.image];
    cell.quantity.delegate = self;
//    CCColorCube *colorCube = [[CCColorCube alloc] init];
//    NSArray *imgColors = [colorCube extractColorsFromImage:food.image flags:CCOnlyDistinctColors avoidColor:[UIColor blackColor]];
    [cell.card setBackgroundColor:[colorScheme backgroundColor]];
    [cell.card2 setBackgroundColor:[colorScheme backgroundColor]];
    [cell.price setBackgroundColor:[colorScheme primaryTextColor]];
    [cell.control setOnTintColor:[colorScheme primaryTextColor]];
    [References cornerRadius:cell.card radius:17.0];
    [References cornerRadius:cell.image radius:17.0];
    [References cornerRadius:cell.topShadow radius:17.0];
    [References cornerRadius:cell.bottomShadow radius:17.0];
    [References cornerRadius:cell.payButton radius:17.0];
    [References cornerRadius:cell.card2 radius:17.0];
    [References cornerRadius:cell.bottomShadow2 radius:17.0];
    [References cornerRadius:cell.price radius:8.0];
    [cell setBackgroundColor:[UIColor clearColor]];
    [References blurView:cell.blur];
    cell.payButton.tag = indexPath.row;
    [cell.payButton
     addTarget:self
     action:@selector(proceedOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.payImage
     addTarget:self
     action:@selector(proceedOrder:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)proceedOrder:(id)sender {
//    UIButton *button = (UIButton*)sender;
//    feedCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
//    foodItem *food = foodItems[button.tag];
//    bool delivery = false;
//    if ([cell.control isOn]) {
//        delivery = true;
//    }
//    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"Orders"];
//    record[@"buyer"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//    record[@"seller"] = food.seller;
//    record[@"item"] = food.item;
//    record[@"delivery"] = [NSNumber numberWithBool:delivery];
//    record[@"qty"] = [NSNumber numberWithInt:cell.quantity.text.intValue];
//    record[@"price"] = [NSNumber numberWithInt:food.price.intValue];
//    [[CKContainer defaultContainer].publicCloudDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error.localizedDescription);
//        }
//    }];
    currentStyle = UIStatusBarStyleLightContent;
    [UIView animateWithDuration:0.4 animations:^(void){
        [self setNeedsStatusBarAppearanceUpdate];
        blackOverlay.alpha = 0.7;
        receiptScroll.frame = CGRectMake(0, receiptScroll.frame.origin.y-receiptScroll.frame.size.height, [References screenWidth], receiptScroll.frame.size.height);
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return currentStyle;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    feedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (int a = 0; a < expandedRow.count; a++) {
        if (a == indexPath.row) {
            if ([expandedRow[a] isEqualToString:@"BIG"]) {
                expandedRow[a] = @"SMALL";
            } else {
            expandedRow[a] = @"BIG";
            }
        } else {
            expandedRow[a] = @"SMALL";
        }
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    int height = 0;
    for (int a = 0; a < expandedRow.count; a++) {
        if ([expandedRow[a] isEqualToString:@"SMALL"]) {
            height = height + SMALL;
        } else {
            height = height + BIG;
        }
        
    }
    [UIView animateWithDuration:0.3 animations:^(void){
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, height);
        scroll.contentSize = CGSizeMake([References screenWidth], table.frame.origin.y+table.frame.size.height+bottomBar.frame.size.height+4);
    }];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int height = 0;
    for (int a = 0; a < expandedRow.count; a++) {
        if ([expandedRow[a] isEqualToString:@"SMALL"]) {
            height = height + SMALL;
        } else {
            height = height + BIG;
        }
    
    }
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, height);
    scroll.contentSize = CGSizeMake([References screenWidth], table.frame.origin.y+table.frame.size.height+bottomBar.frame.size.height+4);
    return foodItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([expandedRow[indexPath.row] isEqualToString:@"SMALL"]) {
        return SMALL;
    } else {
        return BIG;
    }
    
}

-(BOOL)prefersStatusBarHidden{
    return statusBar;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 10) {
        if (statusBar == NO) {
            statusBar = YES;
            [UIView animateWithDuration:0.1 animations:^(void){
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
    } else if (scrollView.contentOffset.y < 10) {
        if (statusBar == YES) {
            statusBar = NO;
            [UIView animateWithDuration:0.1 animations:^(void){
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        [locationManager stopUpdatingLocation];
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           for (CLPlacemark *placemark in placemarks) {
                               NSString *locationString = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
                               locationLabel.text = [locationString uppercaseString];
                               
                           }
                       }];
    }
}
- (IBAction)confirmOrder:(id)sender {
}

- (IBAction)cancelOrder:(id)sender {
    currentStyle = UIStatusBarStyleDefault;
    [UIView animateWithDuration:0.4 animations:^(void){
        [self setNeedsStatusBarAppearanceUpdate];
        blackOverlay.alpha = 0;
        receiptScroll.frame = CGRectMake(0, receiptScroll.frame.origin.y+receiptScroll.frame.size.height, [References screenWidth], receiptScroll.frame.size.height);
    }];
}
@end

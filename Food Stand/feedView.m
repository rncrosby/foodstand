//
//  feedView.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "feedView.h"

@interface feedView ()

@end

@implementation feedView

- (void)viewDidLoad {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    statusBar = NO;
    foodItem *cookie = [[foodItem alloc] initWithImage:[UIImage imageNamed:@"cookies.jpg"] andName:@"Cookies"];
    foodItem *muffin = [[foodItem alloc] initWithImage:[UIImage imageNamed:@"muffin.jpeg"] andName:@"Blueberry Muffins"];
    foodItem *cinnabon = [[foodItem alloc] initWithImage:[UIImage imageNamed:@"cinnabon.jpeg"] andName:@"Cinnamon Rolls"];
    foodItems = [[NSMutableArray alloc] init];
    [foodItems addObject:cookie];
    [foodItems addObject:muffin];
    [foodItems addObject:cinnabon];
    [table reloadData];
    [References tintUIButton:feedButton color:[header.textColor colorWithAlphaComponent:0.7] ];
    [References tintUIButton:postButton color:[header.textColor colorWithAlphaComponent:0.5]];
    [References blurView:backgroundBlur];
    [References blurView:bottomBarBlur];
    [References cornerRadius:userImage radius:userImage.frame.size.height/2];
    [References createLine:bottomBar xPos:0 yPos:0 inFront:YES];
    [super viewDidLoad];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(200).height(200)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            //NSString *nameOfLoginUser = [result valueForKey:@"name"];
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
    [cell.image setImage:food.image];
    [References lightCardShadow:cell.shadow];
    CCColorCube *colorCube = [[CCColorCube alloc] init];
    NSArray *imgColors = [colorCube extractColorsFromImage:food.image flags:CCOnlyDistinctColors avoidColor:[UIColor blackColor]];
    [cell.card setBackgroundColor:imgColors[1]];
    [cell.price setBackgroundColor:imgColors[2]];
    [References cornerRadius:cell.card radius:17.0];
    [References cornerRadius:cell.price radius:8.0];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:cell.image.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(10, 10)
                              ];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = cell.image.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.image.layer.mask = maskLayer;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 294*foodItems.count);
    scroll.contentSize = CGSizeMake([References screenWidth], table.frame.origin.y+table.frame.size.height+bottomBar.frame.size.height+4);
    return foodItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 294;
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
@end

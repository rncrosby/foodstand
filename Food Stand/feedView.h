//
//  feedView.h
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "References.h"
#import "foodItem.h"
#import "feedCell.h"
#import "LEColorPicker.h"


@interface feedView : UIViewController <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *expandedRow;
    bool statusBar;
    NSMutableArray *foodItems;
    __weak IBOutlet UILabel *header;
    __weak IBOutlet UILabel *backgroundBlur;
    __weak IBOutlet UIButton *userImage;
    __weak IBOutlet UIScrollView *bottomBar;
    __weak IBOutlet UILabel *bottomBarBlur;
    __weak IBOutlet UIButton *feedButton;
    __weak IBOutlet UIButton *postButton;
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UITableView *table;
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *animationSquare;
    
    
}

@end

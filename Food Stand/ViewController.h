//
//  ViewController.h
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

@interface ViewController : UIViewController <CLLocationManagerDelegate,UNUserNotificationCenterDelegate> {
     CLLocationManager *locationManager;
    int currentStage;
    __weak IBOutlet UIImageView *logo;
    __weak IBOutlet UILabel *backgroundBlur;
    __weak IBOutlet UILabel *header;
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UIButton *facebookButton;
    __weak IBOutlet UILabel *instructionText;
    __weak IBOutlet UILabel *instructionDetail;
}


@end


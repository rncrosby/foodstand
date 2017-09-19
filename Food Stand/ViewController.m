//
//  ViewController.m
//  Food Stand
//
//  Created by Robert Crosby on 9/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [References cornerRadius:facebookButton radius:10.0f];
    [facebookButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    currentStage = 0;
    [References blurView:backgroundBlur];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loginButtonClicked
{
    if (currentStage == 0) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 currentStage = 1;
                 [References fadeLabelText:instructionText newText:@"Next Food Stand needs your location"];
                 [References fadeButtonText:facebookButton text:@"Allow Current Location"];
                 [References fadeLabelText:instructionDetail newText:@"Location is used only when the app is open to find food close to you"];
                 NSLog(@"Logged in");
             }
         }];
    } else if (currentStage == 1) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    } else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                    [References justMoveOffScreen:facebookButton where:@"BOTTOM"];
                    [References justMoveOffScreen:instructionText where:@"BOTTOM"];
                    [References justMoveOffScreen:instructionDetail where:@"BOTTOM"];
                    [UIView animateWithDuration:.3 animations:^{
                        logo.frame = CGRectMake(logo.frame.origin.x, logo.frame.origin.y+170, logo.frame.size.width, logo.frame.size.height);
                        header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y+170, header.frame.size.width, header.frame.size.height);
                    } completion:^(bool finished){
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"signedIn"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"feedView"];
                        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];

                });
                
            }
        }];
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
        currentStage = 2;
        [References fadeLabelText:instructionText newText:@"Next Food Stand wants to use Push Notifications"];
        [References fadeButtonText:facebookButton text:@"Allow Push Notifications"];
        [References fadeLabelText:instructionDetail newText:@"Push Notifications will only be sent when you order food and the status changes as well as when someone orders your food."];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

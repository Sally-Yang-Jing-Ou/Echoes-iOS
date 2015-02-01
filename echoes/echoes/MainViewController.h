//
//  ViewController.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SendMessageViewController.h"

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, SendMessageDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;

@end


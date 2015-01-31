//
//  SendMessageViewController.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#ifndef echoes_SendMessageViewController_h
#define echoes_SendMessageViewController_h


#endif

@interface SendMessageViewController : UIViewController <CLLocationManagerDelegate, NSURLSessionDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;


@end

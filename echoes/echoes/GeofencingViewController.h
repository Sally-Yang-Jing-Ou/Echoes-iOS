//
//  GeofencingViewController.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#ifndef echoes_GeofencingViewController_h
#define echoes_GeofencingViewController_h


#endif

@interface GeofencingViewController : UIViewController <CLLocationManagerDelegate>

@property NSArray *locationDic;
@property (strong, nonatomic) CLLocationManager *locationManager;

-(instancetype)initWithLocationDic:(NSArray*) locationDic;

@end
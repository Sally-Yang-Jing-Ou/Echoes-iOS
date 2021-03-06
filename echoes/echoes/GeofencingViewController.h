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

@protocol  GeoFencingDelegate;

@interface GeofencingViewController : UIViewController <CLLocationManagerDelegate>

@property (weak)id<GeoFencingDelegate> delegate;
@property NSArray *locationDic;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property NSMutableArray* regions;
@property CLLocationCoordinate2D personCenter;
@property NSMutableDictionary* messages;

-(instancetype)initWithLocationDic:(NSArray*) locationDic;

@end

@protocol GeoFencingDelegate <NSObject>

-(void)dataFinishedLoading;
-(void)personLocationUpdated;
-(void)geoFencingHit:(CLCircularRegion*)region;

@end
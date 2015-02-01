//
//  GeofencingViewController.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeofencingViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "CustomCircularRegion.h"

@implementation GeofencingViewController{
    BOOL run;
}

-(instancetype)initWithLocationDic:(NSArray *)locationDic{
    self = [super init];
    if(self){
        _locationDic = locationDic;
        run = YES;
    }
    return self;
}


-(void)didMoveToParentViewController:(UIViewController *)parent{
    [super didMoveToParentViewController:parent];
    if(![CLLocationManager locationServicesEnabled]){
        return;
    }
    _messages = @{}.mutableCopy;
    _regions = @[].mutableCopy;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _personCenter = CLLocationCoordinate2DMake(0, 0);
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLCircularRegion *)region{
    [_delegate geoFencingHit:region];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //NSLog(@"update");
    CLLocation* l = [locations lastObject];
    _personCenter = l.coordinate;
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager GET:@"https://echoes-ios.herokuapp.com/messages" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        //remove monitored regions
        NSSet* set = [_locationManager monitoredRegions];
        for (CLCircularRegion* regions in set) {
           // NSLog(@"%f, %f", regions.center.latitude, regions.center.longitude);
            //NSLog(@"%f", regions.radius);
            [_messages removeObjectForKey:regions.identifier];
            [_locationManager stopMonitoringForRegion:regions];
        }
        [_regions removeAllObjects];
        NSString* message;
        int ident;
        NSString* identifier;
        CLLocationDegrees latitude;
        CLLocationDegrees longitude;
        CLLocationDistance radius;
        //parser
        for (NSDictionary* dictionary in responseObject){
            message = [dictionary objectForKey:@"body"];
            latitude = [[dictionary objectForKey:@"latitude"] floatValue];
            ident = [[dictionary objectForKey:@"id"] intValue];
            identifier = [NSString stringWithFormat:@"%d", ident];
            longitude = [[dictionary objectForKey:@"longitude"] floatValue];
            radius = 1000;//[[dictionary objectForKey:@"radius"] intValue];
            CLLocationCoordinate2D center = (CLLocationCoordinate2D){latitude, longitude};
            CLCircularRegion *region = [[CustomCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
            [_messages setObject:message forKey:identifier];
            [_regions addObject:region];
            [_locationManager startMonitoringForRegion: region];
        }
        if(run){
            [_delegate dataFinishedLoading];
            run = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [_delegate personLocationUpdated];
   
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
@end
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
}

-(instancetype)initWithLocationDic:(NSArray *)locationDic{
    self = [super init];
    if(self){
        _locationDic = locationDic;
    }
    return self;
}

-(void)viewDidLoad{
    if(![CLLocationManager locationServicesEnabled]){
        return;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    _locationManager.distanceFilter = 500;
    [_locationManager startUpdatingLocation];
    for(NSDictionary* dic in _locationDic){
        NSString *titleName = [dic valueForKey:@"data"];
        CLLocationDegrees lat = [[dic valueForKey:@"latitude"] floatValue];
        CLLocationDegrees lon = [[dic valueForKey:@"longitude"] floatValue];
        CLLocationCoordinate2D center = (CLLocationCoordinate2D){lat, lon};
        CLLocationDistance radius = [[dic valueForKey:@"radius"] integerValue];
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:titleName];
        [_locationManager startMonitoringForRegion:region];
        //[_locationManager requestStateForRegion:region];
    }
    //CustomCircularRegion *r = [[CustomCircularRegion alloc]initWithCenter:(CLLocationCoordinate2D){10,10} radius:1000 identifier:@"1" message:@"ddd"];
    //[_locationManager startMonitoringForRegion:r];
    
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLCircularRegion *)region{
    CLLocationCoordinate2D c = region.center;
    CLRegionState s = state;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CustomCircularRegion *)region{
    NSString *message = [NSString stringWithFormat:@"Entered region: %f, %f",region.center.latitude, region.center.longitude];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert" message:message delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"update");
    //CLLocation *location = locations[0];
    //NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager GET:@"https://echoes-ios.herokuapp.com/messages" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        //remove monitored regions
        NSSet* set = [_locationManager monitoredRegions];
        for (CLCircularRegion* regions in set) {
            NSLog(@"%f, %f", regions.center.latitude, regions.center.longitude);
            NSLog(@"%f", regions.radius);
            [_locationManager stopMonitoringForRegion:regions];
        }
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
            CustomCircularRegion *region = [[CustomCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier message:message];
            [_locationManager startMonitoringForRegion: region];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
   
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"%@",error);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
@end
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
    NSString *m = [_messages valueForKey:region.identifier];
    if(m.length < 100000){
        NSString *message = [NSString stringWithFormat:@"Entered region: %f, %f, %@",region.center.latitude, region.center.longitude, m];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert" message:message delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [alert show];
    }else{
        NSData *data = [[NSData alloc]initWithBase64EncodedString:m options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage* image = [UIImage imageWithData:data];
        UIViewController* v = [[UIViewController alloc]init];
        v.view = [[UIImageView alloc]initWithImage:image];
        //UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self];
        [self presentViewController:v animated:YES completion:^{
            
        }];
    }
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
        [_delegate dataFinishedLoading];
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
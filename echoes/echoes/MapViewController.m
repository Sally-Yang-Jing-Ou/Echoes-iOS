//
//  MapViewController.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CustomAnnotationView.h"

@implementation MapViewController{
    GeofencingViewController* geo;
    NSMutableDictionary* viewDics;
}

-(instancetype)initWithFrame:(CGRect)frame Regions:(NSMutableArray *)regions PersonCenter:(CLLocationCoordinate2D)center Messages:(NSMutableDictionary *)messages{
    self = [super init];
    if(self){
        _frame = frame;
        viewDics = @{}.mutableCopy;
    }
    return self;
}

-(void)loadView{
    _mapView = [[MKMapView alloc]initWithFrame:_frame];
    _mapView.delegate = self;
    _mapView.centerCoordinate =geo.personCenter;
    //[_mapView regionThatFits:(MKCoordinateRegion){_personCenter, 400, 400}];
    self.view = _mapView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    geo = [[GeofencingViewController alloc]initWithLocationDic:nil];
    geo.delegate = self;
    [self addChildViewController:geo];
    [geo didMoveToParentViewController:self];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    CustomAnnotationView* pinView;
    //CustomAnnotationView *pinView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    //if (!pinView)
    //{
        // If an existing pin view was not available, create one.
        pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        //pinView.image = [UIImage imageNamed:@"the-cloud.png"];
        //pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.calloutOffset = CGPointMake(0, 32);
        pinView.pinColor = MKPinAnnotationColorRed;
   // } else {
    //    pinView.annotation = annotation;
   // }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

#pragma mark - GeoFencing Delegate

-(void)dataFinishedLoading{
    [_mapView removeAnnotations:_mapView.annotations];
    [viewDics removeAllObjects];
    for(CLCircularRegion* r in geo.regions){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = r.center;
        [_mapView addAnnotation:annotation];
        [viewDics setObject:annotation forKey:r.identifier];
    }
}

-(void)personLocationUpdated{
    _mapView.centerCoordinate = geo.personCenter;
}

-(void)geoFencingHit:(CLCircularRegion *)region{
    MKPointAnnotation *ann = [viewDics objectForKey:region.identifier];
    CustomAnnotationView *annV = (CustomAnnotationView*)[_mapView viewForAnnotation:ann];
    NSString *m = [geo.messages objectForKey:region.identifier];
    if(m.length > 100000){
        NSData *data = [[NSData alloc]initWithBase64EncodedString:m options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage* image = [UIImage imageWithData:data];
        UIImageView* view = [[UIImageView alloc]initWithImage:image];
        view.frame = (CGRect){-50,-65,100,70};
        [annV addSubview:view];
    }else{
        //ann.title = m;
        // [annV.text setText:m];
        UILabel *l = [[UILabel alloc]initWithFrame:(CGRect){-60,-60,200,50}];
        [l setText:m];
        l.textAlignment = NSTextAlignmentCenter;
        [l setFont:[UIFont fontWithName:@"Default" size:8]];
        //        [l.layer setBorderWidth:2];
        //        [l.layer setBorderColor:[UIColor blackColor].CGColor];
        [annV addSubview:l];
    }
}
@end
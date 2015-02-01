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

@implementation MapViewController

-(instancetype)initWithFrame:(CGRect)frame Regions:(NSMutableArray *)regions PersonCenter:(CLLocationCoordinate2D)center{
    self = [super init];
    if(self){
        _frame = frame;
        _regions = regions;
        _personCenter = center;
    }
    return self;
}

-(void)loadView{
    _mapView = [[MKMapView alloc]initWithFrame:_frame];
    _mapView.delegate = self;
    _mapView.centerCoordinate =_personCenter;
    for(CLCircularRegion* r in _regions){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = r.center;
        [_mapView addAnnotation:annotation];
    }
    self.view = _mapView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
    if (!pinView)
    {
        // If an existing pin view was not available, create one.
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        //pinView.animatesDrop = YES;
        //pinView.canShowCallout = YES;
        //pinView.image = [UIImage imageNamed:@"the-cloud.png"];
        //pinView.calloutOffset = CGPointMake(0, 32);
        pinView.pinColor = MKPinAnnotationColorRed;
    } else {
        pinView.annotation = annotation;
    }
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
         
@end
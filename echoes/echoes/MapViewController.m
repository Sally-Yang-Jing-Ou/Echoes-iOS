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

@implementation MapViewController{
    GeofencingViewController* geo;
}

-(instancetype)initWithFrame:(CGRect)frame Regions:(NSMutableArray *)regions PersonCenter:(CLLocationCoordinate2D)center Messages:(NSMutableDictionary *)messages{
    self = [super init];
    if(self){
        _frame = frame;
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

#pragma mark - GeoFencing Delegate

-(void)dataFinishedLoading{
    [_mapView removeAnnotations:_mapView.annotations];
    for(CLCircularRegion* r in geo.regions){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = r.center;
        [_mapView addAnnotation:annotation];
    }
}

-(void)personLocationUpdated{
    _mapView.centerCoordinate = geo.personCenter;
}
@end
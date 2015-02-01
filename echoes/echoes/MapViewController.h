//
//  MapViewController.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#ifndef echoes_MapViewController_h
#define echoes_MapViewController_h


#endif

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeofencingViewController.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, GeoFencingDelegate>

-(instancetype)initWithFrame:(CGRect)frame Regions:(NSMutableArray*)regions PersonCenter:(CLLocationCoordinate2D)center Messages:(NSMutableDictionary*) messages;

@property MKMapView* mapView;
@property CGRect frame;

@end
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


@interface MapViewController : UIViewController <MKMapViewDelegate, MKAnnotation>

-(instancetype)initWithFrame:(CGRect)frame Regions:(NSMutableArray*)regions PersonCenter:(CLLocationCoordinate2D)center;

@property MKMapView* mapView;
@property CGRect frame;
@property NSMutableArray* regions;
@property CLLocationCoordinate2D personCenter;

@end
//
//  CustomCircularRegion.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#ifndef echoes_CustomCircularRegion_h
#define echoes_CustomCircularRegion_h

#endif

@interface CustomCircularRegion : CLCircularRegion
@property NSString* message;

- (instancetype)initWithCenter:(CLLocationCoordinate2D)center
                        radius:(CLLocationDistance)radius
                    identifier:(NSString *)identifier
                       message:(NSString *) message;

-(NSString*) getMessage;

@end

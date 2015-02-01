//
//  CustomCircularRegion.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCircularRegion.h"

@implementation CustomCircularRegion


- (instancetype)initWithCenter:(CLLocationCoordinate2D)center
                        radius:(CLLocationDistance)radius
                    identifier:(NSString *)identifier
                       message:(NSString *) message {
    self = [super initWithCenter:center radius:radius identifier:identifier];
    if (self) {
        _message = message;
    }
    return self;
}

-(NSString*)getMessage{
    return _message;
}
@end


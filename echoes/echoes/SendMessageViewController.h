//
//  SendMessageViewController.h
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#ifndef echoes_SendMessageViewController_h
#define echoes_SendMessageViewController_h


#endif

@protocol SendMessageDelegate;

@interface SendMessageViewController : UIViewController <CLLocationManagerDelegate, NSURLSessionDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak) id<SendMessageDelegate> delegate;


@end

@protocol SendMessageDelegate <NSObject>

-(void)messageFinishedSendingWithMessage:(NSString*)message;

@end

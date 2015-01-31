//
//  SendMessageViewController.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendMessageViewController.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SendMessageViewController{
    UITextField *text;
    UIButton* sendButton;
    
    NSString *message;
    double lat;
    double lon;
    int radius;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    text = [[UITextField alloc]initWithFrame:(CGRect){100,200,200,50}];
    [text becomeFirstResponder];
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = (CGRect){100,300,200,50};
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessagePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];
    [self.view addSubview:sendButton];
}

-(void)sendMessagePressed{
    message = text.text;
    _locationManager = [[CLLocationManager alloc]init];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

#pragma mark - LocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    lat = location.coordinate.latitude;
    lon = location.coordinate.longitude;
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    //httpManager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"body": message,
                                 @"latitude": [NSString stringWithFormat:@"%f",lat],
                                 @"longitude": [NSString stringWithFormat:@"%f",lon],
                                 @"radius": [NSString stringWithFormat:@"%d",1000]};
    NSDictionary *p = @{@"message" : parameters};
    [httpManager POST:@"https://echoes-ios.herokuapp.com/messages" parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    radius = 1000;
}

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"issending");
}
@end
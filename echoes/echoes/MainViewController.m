//
//  ViewController.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import "MainViewController.h"
#import "GeofencingViewController.h"
#import "SendMessageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MapViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    UIButton *wantToSendButton;
    UIButton *takeImageButton;
    UIButton *mapButton;
    
    NSString* putMessage;
    GeofencingViewController* geo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    wantToSendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wantToSendButton.frame = (CGRect){100,200,200,50};
    [wantToSendButton setTitle:@"Send Message" forState:UIControlStateNormal];
    [wantToSendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [wantToSendButton addTarget:self action:@selector(wantToSendButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    takeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takeImageButton.frame = (CGRect){100,300,200,50};
    [takeImageButton setTitle:@"Send Image" forState:UIControlStateNormal];
    [takeImageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [takeImageButton addTarget:self action:@selector(takeImageButtonPressed) forControlEvents:UIControlEventTouchUpInside];


    mapButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    mapButton.frame = (CGRect){100,400,200,50};
    [mapButton setTitle:@"Send Video" forState:UIControlStateNormal];
    [mapButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview: wantToSendButton];
    [self.view addSubview: takeImageButton];
    [self.view addSubview: mapButton];
    
    geo = [[GeofencingViewController alloc]initWithLocationDic:nil];
    [self addChildViewController:geo];
    [geo didMoveToParentViewController:self];
    
    [self loadNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wantToSendButtonPressed {
    SendMessageViewController *sendMessageVC = [[SendMessageViewController alloc]init];
    sendMessageVC.delegate = self;
    [self.navigationController pushViewController:sendMessageVC animated:YES];
}

-(void)takeImageButtonPressed{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)mapButtonPressed{
    MapViewController *mapViewController = [[MapViewController alloc]initWithFrame:(CGRect){0,50,self.view.frame.size.width, self.view.frame.size.height - 50} Regions: geo.regions PersonCenter:geo.personCenter];
    [self.navigationController presentViewController:mapViewController animated:YES completion:^{
        
    }];
}

#pragma mark - SendMessageController Delegate

-(void)messageFinishedSendingWithMessage:(NSString *)message{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc]init];
    }
    _locationManager.delegate = self;
    putMessage = message;
    [_locationManager startUpdatingLocation];
}

#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData* data = UIImagePNGRepresentation(image);
    NSString* imageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc]init];
    }
    _locationManager.delegate = self;
    putMessage = imageString;
    [picker.navigationController popViewControllerAnimated:YES];
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    float lat = location.coordinate.latitude;
    float lon = location.coordinate.longitude;
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"body": putMessage,
                                 @"latitude": [NSString stringWithFormat:@"%f",lat],
                                 @"longitude": [NSString stringWithFormat:@"%f",lon],
                                 @"radius": [NSString stringWithFormat:@"%d",1000]};
    NSDictionary *p = @{@"message" : parameters};
    [httpManager POST:@"https://echoes-ios.herokuapp.com/messages" parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



-(void)loadNavbar{
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){0,10,100,50}];
    label.center = (CGPoint){self.navigationController.view.center.x,42};
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:@"Echoes"];
    [self.navigationController.view addSubview:label];
}

@end

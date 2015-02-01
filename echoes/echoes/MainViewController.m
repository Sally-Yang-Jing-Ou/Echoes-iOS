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
    UIImagePickerController *imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    wantToSendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wantToSendButton.frame = (CGRect){100,200,200,80};
    [wantToSendButton setTitle:@"Send Message" forState:UIControlStateNormal];
    [wantToSendButton setTitleColor:[UIColor colorWithRed:71.0/255 green:62.0/255 blue:63.0/255 alpha:1] forState:UIControlStateNormal];
    wantToSendButton.layer.cornerRadius = 10; // this value vary as per your desire
    wantToSendButton.clipsToBounds = YES;
    wantToSendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [wantToSendButton addTarget:self action:@selector(wantToSendButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    takeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takeImageButton.frame = (CGRect){100,300,200,80};
    [takeImageButton setTitle:@"Send Image" forState:UIControlStateNormal];
    [takeImageButton setTitleColor: [UIColor colorWithRed:71.0/255 green:62.0/255 blue:63.0/255 alpha:1]  forState:UIControlStateNormal];
    takeImageButton.layer.cornerRadius = 10; // this value vary as per your desire
    takeImageButton.clipsToBounds = YES;
    takeImageButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [takeImageButton addTarget:self action:@selector(takeImageButtonPressed) forControlEvents:UIControlEventTouchUpInside];


    mapButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    mapButton.frame = (CGRect){100,400,200,80};
    [mapButton setTitle:@"Show Map" forState:UIControlStateNormal];
    [mapButton setTitleColor: [UIColor colorWithRed:71.0/255 green:62.0/255 blue:63.0/255 alpha:1]  forState:UIControlStateNormal];
    mapButton.layer.cornerRadius = 10; // this value vary as per your desire
    mapButton.clipsToBounds = YES;
    mapButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [mapButton addTarget:self action:@selector(mapButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview: wantToSendButton];
    [self.view addSubview: takeImageButton];
    [self.view addSubview: mapButton];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:33.0/255 green:140.0/255 blue:141.0/255 alpha:1]];
    [wantToSendButton setBackgroundColor:[UIColor colorWithRed:249.0/255 green:229.0/255 blue:89.0/255 alpha:1]];
    [takeImageButton setBackgroundColor:[UIColor colorWithRed:239.0/255 green:113.0/255 blue:38.0/255 alpha:1]];
    [mapButton setBackgroundColor:[UIColor colorWithRed:142.0/255 green:220.0/255 blue:157.0/255 alpha:1]];
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
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

-(void)mapButtonPressed{
    MapViewController *mapViewController = [[MapViewController alloc]initWithFrame:(CGRect){0,50,self.view.frame.size.width, self.view.frame.size.height - 50} Regions: geo.regions PersonCenter:geo.personCenter Messages:geo.messages];
    [self.navigationController pushViewController: mapViewController animated:YES];
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
        //NSLog(@"JSON: %@", responseObject);
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
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

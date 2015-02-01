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

@interface MainViewController ()

@end

@implementation MainViewController{
    UIButton *wantToSendButton;
    UIButton *takeImageButton;
    UIButton *takeVideoButton;
    
    NSString* putMessage;
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


    takeVideoButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    takeVideoButton.frame = (CGRect){100,400,200,50};
    [takeVideoButton setTitle:@"Send Video" forState:UIControlStateNormal];
    [takeVideoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [takeVideoButton addTarget:self action:@selector(takeVideoButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview: wantToSendButton];
    [self.view addSubview: takeImageButton];
    [self.view addSubview: takeVideoButton];
    
    GeofencingViewController *geo = [[GeofencingViewController alloc]initWithLocationDic:nil];
    [self addChildViewController:geo];
    [geo didMoveToParentViewController:self];
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

-(void)takeVideoButtonPressed{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
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
@end

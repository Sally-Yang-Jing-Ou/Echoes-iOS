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

@interface MainViewController ()

@end

@implementation MainViewController{
    UIButton *wantToSendButton;
    UIButton *takeImageButton;
    UIButton *takeVideoButton;
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

    [self.view addSubview wantToSendButton];
    [self.view addSubview takeImageButton];
    [self.view addSubview takeVideoButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wantToSendButtonPressed {
    SendMessageViewController *sendMessageVC = [[SendMessageViewController alloc]init];
    //GeofencingViewController *geo = [[GeofencingViewController alloc]initWithLocationDic:nil];
    [self.navigationController pushViewController:sendMessageVC animated:YES];
}

-(void)takeImageButtonPressed{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]initWithRootViewController: self];
    [self presentViewController:imagePicker animated:YES completion:{

    }];
}

-(void)takeVideoButtonPressed{

}
@end

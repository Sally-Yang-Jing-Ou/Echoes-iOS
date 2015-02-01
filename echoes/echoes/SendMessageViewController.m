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

}


-(void)viewDidLoad{
    [super viewDidLoad];
    text = [[UITextField alloc]initWithFrame:(CGRect){100,275,200,50}];
    [text setBackgroundColor:[UIColor colorWithRed:13.0/255 green:120.0/255 blue:121.0/255 alpha:1]];
    text.layer.cornerRadius = 10;
    text.clipsToBounds = YES;
    [text becomeFirstResponder];
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = (CGRect){100,375,200,80};
    [sendButton setTitle:@"Send Message" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:71.0/255 green:62.0/255 blue:63.0/255 alpha:1] forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 10; // this value vary as per your desire
    sendButton.clipsToBounds = YES;
    sendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [sendButton setBackgroundColor:[UIColor colorWithRed:249.0/255 green:229.0/255 blue:89.0/255 alpha:1]];
    [sendButton addTarget:self action:@selector(sendMessagePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];
    [self.view addSubview:sendButton];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:33.0/255 green:140.0/255 blue:141.0/255 alpha:1]];
}

-(void)sendMessagePressed{
    [_delegate messageFinishedSendingWithMessage:text.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
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
    [_delegate messageFinishedSendingWithMessage:text.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
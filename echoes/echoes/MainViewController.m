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
}

-(void)loadView{
    //UIView* v = [[UIView alloc]initWithFrame:(CGRect){10,10,300,300}];
    //v.backgroundColor = [UIColor redColor];
    //self.view = v;
    //
    //[super loadView];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor redColor];
    wantToSendButton = [[UIButton alloc]initWithFrame:(CGRect){100, 400, 200, 50}];
    [wantToSendButton setTitle:@"Send Message" forState:UIControlStateNormal];
    [wantToSendButton addTarget:self action:@selector(wantToSendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:wantToSendButton];
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *dic = @[@{@"data" : @"Hello",
                        @"latitude" :@51,
                        @"longitude" : @-0.1,
                        @"radius" : @1000}];
    //GeofencingViewController *geo = [[GeofencingViewController alloc] initWithLocationDic:dic];
    //[self.navigationController pushViewController:geo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) wantToSendButtonPressed {
    //SendMessageViewController *sendMessageVC = [[SendMessageViewController alloc]init];
    GeofencingViewController *geo = [[GeofencingViewController alloc]initWithLocationDic:nil];
    [self.navigationController pushViewController:geo animated:YES];
}
@end

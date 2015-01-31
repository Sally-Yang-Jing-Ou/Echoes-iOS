//
//  ViewController.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-01-31.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import "MainViewController.h"
#import "GeofencingViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    UIButton *navButton;
}

-(void)loadView{
    UIView* v = [[UIView alloc]initWithFrame:(CGRect){10,10,300,300}];
    v.backgroundColor = [UIColor redColor];
    self.view = v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *dic = @[@{@"data" : @"Hello",
                        @"latitude" :@51,
                        @"longitude" : @-0.1,
                        @"radius" : @1000}];
    GeofencingViewController *geo = [[GeofencingViewController alloc] initWithLocationDic:dic];
    [self.navigationController pushViewController:geo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

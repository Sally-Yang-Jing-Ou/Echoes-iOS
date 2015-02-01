//
//  CustomAnnotationView.m
//  echoes
//
//  Created by Sally Yang Jing Ou on 2015-02-01.
//  Copyright (c) 2015 Sally Yang Jing Ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _text = [[UILabel alloc]initWithFrame:(CGRect){0,-100,200,50}];
        _showImage = [[UIImageView alloc]initWithFrame:(CGRect){0,0,0,0}];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    //[super drawRect:rect];
    [self addSubview:_text];
    [self addSubview:_showImage];
    [self setBackgroundColor:[UIColor redColor]];
}

@end
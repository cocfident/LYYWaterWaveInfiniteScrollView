//
//  ViewController.m
//  YY_baidu外面水纹轮播
//
//  Created by Xiaoyue on 16/5/17.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import "ViewController.h"
#import "YYScrollView.h"
@interface ViewController ()<scrollViewClick>

@property (nonatomic, strong) YYScrollView *scroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSArray *dic = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    _scroll = [YYScrollView initWithImages:dic];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];

}

-(void)imageClickWithIndex:(NSInteger)index
{
    NSLog(@"点击的是第%ld张图片",index+1);
}



@end

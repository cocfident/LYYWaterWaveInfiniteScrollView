//
//  YYScrollView.h
//  lianxi
//
//  Created by Xiaoyue on 16/3/30.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollViewClick <NSObject>
/**
 *  图片点击的代理
 *
 *  @param index 图片的下标
 */
-(void)imageClickWithIndex:(NSInteger)index;

@end

@interface YYScrollView : UIView

@property (nonatomic, assign)id <scrollViewClick> delegate;
/**
 *  初始化方法
 *
 *  @param images 图片
 *
 *  @return 
 */
+(YYScrollView *)initWithImages:(NSArray *)images;



@end

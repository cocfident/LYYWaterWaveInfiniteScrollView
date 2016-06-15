//
//  YYScrollView.m
//  lianxi
//
//  Created by Xiaoyue on 16/3/30.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import "YYScrollView.h"
#import "Water.h"
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define WIDTH    [UIScreen mainScreen].bounds.size.width
#define HEIGHT   200

#define IMAGEVIEW_COUNT 3


@interface YYScrollView ()<UIScrollViewDelegate>
{
    UIScrollView    *_scrollView;
    UIImageView     *_leftImageView;     //左边的视图
    UIImageView     *_centerImageView;   //当前正在显示的视图
    UIImageView     *_rightImageView;    //即将显示的视图
    UIPageControl   *_pageControl;    //小圆点
    NSInteger       _currentImageIndex;//当前图片索引
    NSInteger       _imageCount;//图片总数
    NSArray         *allPics;
    NSTimer         *timer;
    UIView          *barView;
    Water           *waterWave;
    BOOL             isDraging;
}


@end


@implementation YYScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 20, SCREEN_WIDTH-80, (SCREEN_WIDTH-80)*1.5);
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
       // self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}


+(YYScrollView *)initWithImages:(NSArray *)images
{
    YYScrollView *yyScroll = [[YYScrollView alloc] initWithFrame:CGRectZero];
    
        //添加滚动控件
        [yyScroll addScrollView];
        [yyScroll setImages:images];
        //添加图片控件
        [yyScroll addImageViews];
        //添加分页控件
       // [yyScroll addPageControl];
        //加载默认图片
        [yyScroll setDefaultImage];
         //添加定时器
        [yyScroll addTimer];
    
        return yyScroll;

    
}

#pragma mark -- 添加定时器
-(void)addTimer
{
    timer =  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateWithTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)updateWithTimer:(NSTimer *)timer
{
    if (isDraging) return;
        
        
        [UIView animateWithDuration:1.5
                     animations:^{
                         CGPoint offSet = _scrollView.contentOffset;
                     
                         offSet.x +=WIDTH;
                         _scrollView.contentOffset = offSet;
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [self reloadImage];
                         
                         [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
                         //设置分页
                         _pageControl.currentPage=_currentImageIndex;
                     }];

}

#pragma mark -- 添加scrollView
-(void)addScrollView
{
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self  addSubview:_scrollView];
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake(IMAGEVIEW_COUNT*WIDTH, HEIGHT);
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    //设置分页
    _scrollView.pagingEnabled=YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    waterWave = [[Water alloc]initWithFrame:CGRectMake(0, HEIGHT-30, WIDTH, 30)];
    [self addSubview:waterWave];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    [_scrollView addGestureRecognizer:tap];
    
}


-(void)setImages:(NSArray *)images;
{
    _imageCount = images.count;
    allPics = images;
}

#pragma mark -- 图片点击的代理方法
-(void)imageClick:(UITapGestureRecognizer *)sender
{
    
    [_delegate imageClickWithIndex:_currentImageIndex];
    

}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    //_leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    //_centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*WIDTH, 0, WIDTH, HEIGHT)];
    //_rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
    
}
#pragma mark -- 设置默认显示图片
-(void)setDefaultImage
{
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",_imageCount-1]];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",0]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",1]];
    _currentImageIndex=0;
    //设置当前页
    _pageControl.currentPage=_currentImageIndex;
   
    
}

#pragma -- mark 添加分页控件

-(void)addPageControl
{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(WIDTH/2, HEIGHT-30);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    
    [self addSubview:_pageControl];
}




#pragma mark -- 核心代码 - scrollView 代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    isDraging = YES;
    [waterWave startAnmition];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDraging = NO;
    [waterWave stopAnmition];
}
#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>WIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<WIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",(long)_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(int)(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(int)(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",rightImageIndex]];
}






@end

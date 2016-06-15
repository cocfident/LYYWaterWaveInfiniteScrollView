//
//  Water.m
//  贝塞尔曲线
//
//  Created by Xiaoyue on 16/5/17.
//  Copyright © 2016年 李运洋. All rights reserved.
//

#import "Water.h"


@interface Water ()
{
    UIColor *_currentWaterColor;
    UIImageView *backImage;
    NSTimer *timer;
    
    float _currentLinePointY;
    float a;
    float b;
    
    BOOL isChange;
    BOOL isPlaying;
}


@end
@implementation Water



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        a = 0;
        b = 0;
        isChange = NO;
        isPlaying = NO;
        self.backgroundColor = [UIColor clearColor];
        _currentWaterColor = [UIColor whiteColor];
        _currentLinePointY = 10;

    }
    return self;
}

-(void)startAnmition
{
    
    if (isPlaying) return;
    a = 1.5;
    b = 0;
     timer =   [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode: UITrackingRunLoopMode];
    
    isPlaying = YES;
}


-(void)stopAnmition
{
    
    [timer invalidate];
    
    timer =   [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(stopTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode: UITrackingRunLoopMode];
    [self setNeedsDisplay];
}

-(void)animateWave
{
    if (isChange) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    if (a<=1) {
        
        isChange = YES;
    }
    
    if (a>=1.5) {
        isChange = NO;
    }
    
    b+=0.1;
    
    [self setNeedsDisplay];
}


-(void)stopTime
{
     a -= 0.01;
     b+=0.1;
    
       
    if ( a<=0) {
        
        isPlaying = NO;
        [timer invalidate];
    }
    
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    
    for(float x=0;x<=self.bounds.size.width;x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.bounds.size.width, _currentLinePointY+20);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY+20);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);

    
}



@end

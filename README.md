# LYYWaterWaveInfiniteScrollView

仿百度外卖轮播图,在拖动的时候会出现水纹效果,拖动停止,水纹慢慢听着




<br>- (void)viewDidLoad {
   <br> [super viewDidLoad];
 
    NSArray *dic = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    _scroll = [YYScrollView initWithImages:dic];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];

}

-(void)imageClickWithIndex:(NSInteger)index
<br>{
  <br>  NSLog(@"点击的是第%ld张图片",index+1);
<br>}









![image](https://github.com/cocfident/LYYWaterWaveInfiniteScrollView/blob/master/pic/water.gif)

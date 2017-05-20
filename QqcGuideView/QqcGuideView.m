//
//  QqcGuideView.m
//  QqcWidgetsFramework
//
//  Created by mahailin on 15/9/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "QqcGuideView.h"

static NSInteger kCloseViewTag = 100;

@interface QqcGuideView ()<UIScrollViewDelegate>

/**
 *  scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  引导图数组
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 *  当前页
 */
@property (nonatomic, assign) NSInteger currentPageIndex;

@end

@implementation QqcGuideView

#pragma mark -
#pragma mark ==== 系统方法 ====
#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.currentPageIndex = 0;
        [self addSubview:self.scrollView];
        //[self addSubview:self.exitButton];
    }
    
    return self;
}

#pragma mark -
#pragma mark ==== 外部使用方法 ====
#pragma mark -

/**
 *  初始化引导图view
 *
 *  @param frame     引导图view的frame
 *  @param imageArray 要显示的图片数组
 *
 *  @return 返回QqcGuideView实例
 */
- (instancetype) initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        self.imageArray = imageArray;
        CGFloat xPoint = 0.0;
        
        for (int i = 0; i < self.imageArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, 0.0, self.width, self.height)];
            imageView.image = self.imageArray[i];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self.scrollView addSubview:imageView];
            xPoint += self.width;
        }
        
        if (self.swipToExit)
        {
            [self addCloseView];
        }
        else
        {
            self.scrollView.contentSize = CGSizeMake(xPoint, self.height);
        }
    }
    
    return self;
}

/**
 *  用于显示引导图view
 *
 *  @param view            要显示引导图的view
 *  @param animateDuration 动画时间
 */
- (void)showInView:(UIView *)view animateDuration:(CGFloat)animateDuration
{
    self.alpha = 0;
    self.scrollView.contentOffset = CGPointZero;
    [view addSubview:self];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 1;
    } completion:nil];
}

#pragma mark -
#pragma mark ==== 内部使用方法 ====
#pragma mark -

/**
 *  添加关闭view
 */
- (void)addCloseView
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(self.imageArray.count * self.width, 0, self.width, self.height)];
    closeView.tag = kCloseViewTag;
    [self.scrollView addSubview:closeView];
    self.scrollView.contentSize = CGSizeMake(self.width * (self.imageArray.count + 1), self.height);
}

/**
 *  移除关闭view
 */
- (void)removeCloseView
{
    UIView *closeView = [self.scrollView viewWithTag:kCloseViewTag];
    [closeView removeFromSuperview];
    self.scrollView.contentSize = CGSizeMake(self.width * self.imageArray.count, self.height);
}

/**
 *  处理点击退出按钮事件
 *
 *  @param sender 按钮
 */
- (void)exitButtonClick:(id)sender
{
    [self swipGuideViewDidFinsh];
}

/**
 *  检查index
 */
- (void)checkIndexForScrollView
{
    NSInteger newPageIndex = (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width / 2) / self.scrollView.frame.size.width;
    
    if (newPageIndex == self.imageArray.count)
    {
        [self swipGuideViewDidFinsh];
    }
}

/**
 *  滑动结束
 */
- (void)swipGuideViewDidFinsh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipGuideViewDidFinsh:)])
    {
        [self.delegate swipGuideViewDidFinsh:self];
    }
    
    self.alpha = 0.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark -
#pragma mark ==== UIScrollViewDelegate ====
#pragma mark -

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self checkIndexForScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkIndexForScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / self.scrollView.frame.size.width);
    self.currentPageIndex = page;
    
    if (self.showExitButtonOnlyInLastPage)
    {
        self.exitButton.hidden = !(self.currentPageIndex == self.imageArray.count - 1);
    }
    else
    {
        self.exitButton.hidden = YES;
    }
    
    if (page == self.imageArray.count - 1 && self.swipToExit)
    {
        self.alpha = ((self.scrollView.frame.size.width * self.imageArray.count) - self.scrollView.contentOffset.x) / self.scrollView.frame.size.width;
        
        if (fmodf(scrollView.contentOffset.x, self.scrollView.frame.size.width) > 40)
        {
            self.exitButton.hidden = YES;
        }
    }
}

#pragma mark -
#pragma mark ==== 数据初始化 ====
#pragma mark -

/**
 *  初始化scrollView
 *
 *  @return 返回UIScrollView实例
 */
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    return _scrollView;
}

/**
 *  初始化退出按钮
 *
 *  @return 返回UIButton实例
 */
- (UIButton *)exitButton
{
    if (!_exitButton)
    {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitButton.frame = CGRectMake(self.width / 3, self.height - (self.width / 3 + 50) , self.width / 3, 40);
        [_exitButton setTitle:@"" forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [_exitButton setBackgroundColor:[UIColor redColor]];
    }
    
    return _exitButton;
}

/**
 *  设置是否滑动退出引导图
 *
 *  @param swipToExit yes-退出，no-不退出
 */
- (void)setSwipToExit:(BOOL)swipToExit
{
    if (swipToExit != _swipToExit)
    {
        _swipToExit = swipToExit;
        
        if (swipToExit)
        {
            [self addCloseView];
        }
        else
        {
            [self removeCloseView];
        }
    }
}

/**
 *  设置是否只有最后一页才显示退出按钮
 *
 *  @param showExitButtonOnlyInLastPage yes-是，no-否
 */
- (void)setShowExitButtonOnlyInLastPage:(BOOL)showExitButtonOnlyInLastPage
{
    _showExitButtonOnlyInLastPage = showExitButtonOnlyInLastPage;
    self.exitButton.hidden = YES;
    
    if (showExitButtonOnlyInLastPage)
    {
        self.exitButton.hidden = !(self.currentPageIndex == self.imageArray.count - 1);
    }
    else
    {
        self.exitButton.hidden = NO;
    }
}

@end

//
//  QqcGuideView.h
//  QqcWidgetsFramework
//
//  Created by mahailin on 15/9/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QqcGuideView;

@protocol QqcGuideViewDelegate <NSObject>

@optional

/**
 *  滑动guideView结束的回调
 *
 *  @param guideView QqcGuideView实例
 */
- (void)swipGuideViewDidFinsh:(QqcGuideView *)guideView;

@end

/**
 *  引导图view
 */
@interface QqcGuideView : UIView

/**
 *  委托
 */
@property (nonatomic, weak) id<QqcGuideViewDelegate> delegate;

/**
 *  退出按钮
 */
@property (nonatomic, strong) UIButton *exitButton;

/**
 *  是否滑动退出
 */
@property (nonatomic, assign) BOOL swipToExit;

/**
 *  是否只有最后一页才显示退出按钮
 */
@property (nonatomic, assign) BOOL showExitButtonOnlyInLastPage;

/**
 *  初始化引导图view
 *
 *  @param frame     引导图view的frame
 *  @param imageArray 要显示的图片数组
 *
 *  @return 返回QqcGuideView实例
 */
- (instancetype) initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

/**
 *  用于显示引导图view
 *
 *  @param view            要显示引导图的view
 *  @param animateDuration 动画时间
 */
- (void)showInView:(UIView *)view animateDuration:(CGFloat)animateDuration;

@end

//
//  WJGlowLayer.h
//  WJGlow
//
//  Created by wangjin on 16/7/14.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface WJGlowLayer : CALayer

//发光的透明度
@property(nonatomic,strong) NSNumber *glowOpacity;
//发光阴影半径
@property(nonatomic,strong) NSNumber *glowRadius;
//发光时间
@property(nonatomic,strong) NSNumber *glowDuration;
//不发光时间
@property(nonatomic,strong) NSNumber *hideDuration;
//发光变化时间
@property(nonatomic,strong) NSNumber *glowAnimationDuration;



/** 在原始的View上创建出辉光layer */
- (void)createGlowLayer:(UIView *)view glowColor:(UIColor *)glowColor;

/** 显示辉光 */
-(void)showGLowLayer;

/** 隐藏辉光 */
-(void)hideGlowLayer;

/** 开始循环辉光动画 */
-(void)startGlowAnimation;

/** 暂停辉光动画 */
-(void)pauseGlowAnimation;

/** 重启辉光动画 */
-(void)reStartGlowAnimation;

@end


@interface UIView (GlowViews)

/** WJGlowLayer */
@property (nonatomic,strong)WJGlowLayer *glowLayer;


/** 创建GlowLayer，默认辉光颜色为红色 */
-(void)addGlowLayer;
/** 创建GlowLayer，需要设置辉光颜色 */
-(void)addGlowLayerWithGlowColor:(UIColor*)glowColor;

/** 插入辉光 */
-(void)insertGlowLayerToSuperlayer;

/** 完全移除GLowLayer */
-(void)removeGlowLayerFromSuperlayer;


@end

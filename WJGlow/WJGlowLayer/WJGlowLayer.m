//
//  WJGlowLayer.m
//  WJGlow
//
//  Created by wangjin on 16/7/14.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "WJGlowLayer.h"
@interface WJGlowLayer ()

@property(nonatomic,strong) UIColor *glowColor;

@property(nonatomic,weak) UIView *addView;

@property (nonatomic,strong)dispatch_source_t timer;

@end

@implementation WJGlowLayer

- (void)createGlowLayer:(UIView *)view glowColor:(UIColor *)glowColor{

    self.glowColor = glowColor;
    
    //.1创建设置图形上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
   
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    
    [self.glowColor setFill];
    
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1];
    
    
    //2.设置self自己的状态
    self.frame = view.bounds;
   
    self.contents = (__bridge id _Nullable)(UIGraphicsGetImageFromCurrentImageContext().CGImage);
   
    self.opacity = 0.0f;
  
    self.shadowOpacity = 1.0f;
    
    self.shadowOffset = CGSizeMake(0, 0);
    
    UIGraphicsEndPDFContext();
    
    self.addView = view;
}

#pragma mark --显示/隐藏

- (void)showGLowLayer{

    self.shadowColor = self.glowColor.CGColor;
    self.shadowRadius = self.glowRadius.floatValue;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0);
    animation.toValue = self.glowOpacity;
    animation.duration = self.glowAnimationDuration.floatValue;
    
    self.opacity = self.glowOpacity.floatValue;
    
    [self addAnimation:animation forKey:nil];
    
}

- (void)hideGlowLayer{

    self.shadowColor = self.glowColor.CGColor;
    self.shadowRadius = self.glowRadius.floatValue;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = self.glowOpacity;
    animation.toValue = @(0);
    animation.duration = self.glowAnimationDuration.floatValue;
    
    self.opacity = 0;
    [self addAnimation:animation forKey:nil];
}


#pragma mark --循环显示和隐藏发光

//开始循环发光动画
- (void)startGlowAnimation{

    CGFloat cycleTime = self.glowAnimationDuration.floatValue *2
    + self.glowDuration.floatValue + self.hideDuration.floatValue;
    
    CGFloat delayTime = self.glowAnimationDuration.floatValue + self.glowDuration.floatValue;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, cycleTime * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        [self showGLowLayer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideGlowLayer];
        });
    });
    dispatch_resume(_timer);
}


//暂停发光动画
- (void)pauseGlowAnimation{

    [self removeFromSuperlayer];
}

//重启发光动画

- (void)reStartGlowAnimation{

    [self.addView.layer addSublayer:self];
    [self startGlowAnimation];
}

#pragma mark -- set/get

- (UIColor *)glowColor{
    
    if(!_glowColor){
        _glowColor = [UIColor yellowColor];
    }
    return _glowColor;
}

- (NSNumber *)glowRadius{

    if (!_glowRadius || _glowRadius.floatValue<=0) {
        _glowRadius = @(2.0f);
    }
    return _glowRadius;
}

- (NSNumber *)glowOpacity{

    if (!_glowOpacity || _glowOpacity.floatValue<=0) {
        _glowOpacity = @(0.8);
    }
    return _glowOpacity;
}


- (NSNumber *)glowDuration{

    if (!_glowDuration || _glowDuration.floatValue<0) {
        
        _glowDuration = @(0.5f);
    }
    return _glowDuration;
}

- (NSNumber *)hideDuration{

    if (!_hideDuration || _hideDuration.floatValue<0) {
        
        _hideDuration = @(0.5f);
    }
    return _hideDuration;
}

- (NSNumber *)glowAnimationDuration{

    if (!_glowAnimationDuration || _glowAnimationDuration.floatValue <0) {
        
        _glowAnimationDuration = @(1.0f);
    }
    return _glowAnimationDuration;
}

@end

#import <objc/runtime.h>

@implementation UIView (GlowViews)

/** 创建GlowLayer，默认辉光颜色为红色 */
-(void)addGlowLayer{
    [self addGlowLayerWithGlowColor:nil];
}
/** 创建GlowLayer，需要设置辉光颜色 */
-(void)addGlowLayerWithGlowColor:(UIColor*)glowColor{
    if (self.glowLayer == nil) {
        self.glowLayer = [[WJGlowLayer alloc] init];
    }
    [self.glowLayer createGlowLayer:self glowColor:glowColor];
    [self insertGlowLayerToSuperlayer];
}
#pragma mark - 插入和移除辉光

/** 插入辉光 */
-(void)insertGlowLayerToSuperlayer{
    if (self.glowLayer == nil) {
        self.glowLayer = [[WJGlowLayer alloc] init];
    }
    [self.layer addSublayer:self.glowLayer];
}


/** 移除辉光 */
-(void)removeGlowLayerFromSuperlayer{
    [self.glowLayer removeFromSuperlayer];
    self.glowLayer = nil;
}

#pragma mark - Runtime动态添加属性
NSString * const _recognizerGlowLayer = @"_recognizerGlowLayer";
-(void)setGlowLayer:(WJGlowLayer *)glowLayer{
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer), glowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(WJGlowLayer *)glowLayer{
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer));
}

@end


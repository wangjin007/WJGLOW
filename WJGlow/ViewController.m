//
//  ViewController.m
//  WJGlow
//
//  Created by wangjin on 16/7/14.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "ViewController.h"
#import "WJGlowLayer.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor blackColor];
     _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*0.5)];
    
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:30];
    _nameLabel.text = @"I LOVE YOU";
    _nameLabel.textAlignment = 1;
    
    _nameLabel.font = font;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.glowLayer.glowRadius = @(3.f);
    
    [self.view addSubview:_nameLabel];
    
    [_nameLabel addGlowLayerWithGlowColor:[UIColor redColor]];
    
    [_nameLabel.glowLayer startGlowAnimation];
    
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.5-SCREENWIDTH*0.9*0.5, CGRectGetMaxY(_nameLabel.frame), SCREENWIDTH*0.9, SCREENWIDTH*0.8)];
    
    _imageView.image = [UIImage imageNamed:@"heart"];
    
    [self.view addSubview:_imageView];
    
    [_imageView addGlowLayerWithGlowColor:[UIColor redColor]];
    
    [_imageView.glowLayer startGlowAnimation];
}


@end

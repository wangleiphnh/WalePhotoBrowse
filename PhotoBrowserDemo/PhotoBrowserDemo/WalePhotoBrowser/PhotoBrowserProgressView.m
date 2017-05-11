//
//  PhotoBrowserProgressView.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/17.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "PhotoBrowserProgressView.h"

@interface PhotoBrowserProgressView ()

@property(nonatomic,strong)CAShapeLayer *circleLayer;
@property(nonatomic,strong)CAShapeLayer *fanshapedLayer;

@end


@implementation PhotoBrowserProgressView


- (instancetype)init
{
    self = [super init];
    if (self) {
        _progress = 0;
        if (self.frame.size.height == 0 && self.frame.size.width == 0) {
            self.bounds =CGRectMake(0, 0, 50, 50);
        }
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.backgroundColor = [UIColor clearColor];
    UIColor *strokeColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.circleLayer = [[CAShapeLayer alloc] init];
    self.circleLayer.strokeColor = strokeColor.CGColor;
    self.circleLayer.path = [self makeCirclePath].CGPath;
    [self.layer addSublayer:self.circleLayer];
    
    self.fanshapedLayer = [[CAShapeLayer alloc] init];
    self.fanshapedLayer.fillColor = strokeColor.CGColor;
    [self.layer addSublayer:self.fanshapedLayer];
    self.progress = 0;
}
-(UIBezierPath *)makeCirclePath
{
    CGPoint arcCenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:25 startAngle:0 endAngle:M_PI*2 clockwise:true];
    path.lineWidth = 2;
    return path;
}

-(UIBezierPath *)makeProgressPath:(CGFloat)progress{
    CGPoint arcCenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    CGFloat radius = self.bounds.size.height/2.0 - 2.5;
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:arcCenter];
    [path addLineToPoint:CGPointMake(self.bounds.size.width/2.0, arcCenter.y- radius)];
    [path addArcWithCenter:arcCenter radius:radius startAngle:-M_PI_2 endAngle:(-M_PI_2) + M_PI_2 * 2 * progress clockwise:true];
    [path closePath];
    path.lineWidth = 1;
    return  path;
}
-(void)setProgress:(CGFloat)progress{
    self.fanshapedLayer.path = [self makeProgressPath:progress].CGPath;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

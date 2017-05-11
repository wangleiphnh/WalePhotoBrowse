//
//  ScaleAnimator.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/18.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "ScaleAnimator.h"

@implementation ScaleAnimator


- (instancetype )initWith:(UIView *)startView :(UIView *)endView :(UIView *)scaleView
{
    self = [super init];
    if (self) {
        self.startView = startView;
        self.endView = endView;
        self.scaleView = scaleView;
    }
    return self;
}

- (instancetype)init
{
    return [self initWith:nil :nil :nil];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    NSLog(@"%@",fromVC);
    
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (fromVC&&toVC) {
        BOOL presentation = (toVC.presentingViewController == fromVC);
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        if (!presentation&&presentedView) {
            presentedView.hidden = YES;
        }
        // 取转场中介容器
        UIView *containerView = transitionContext.containerView;
        UIView *startView = self.startView;
        UIView *endView = self.endView;
        UIView *scaleView = self.scaleView;
        if (!(startView&&endView&&scaleView)) {
            return;
        }
        CGRect startFrame = [startView.superview convertRect:startView.frame toView:containerView];
        CGRect endFrame = [endView.superview convertRect:endView.frame toView:containerView];
        scaleView.frame = startFrame;

        [containerView addSubview:scaleView];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            scaleView.frame = endFrame;
            
        } completion:^(BOOL finished) {
            UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
            if (presentation && presentedView) {
                [containerView addSubview:presentedView];
            }
            [scaleView removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            
        }];
        
    }else{
        return;
    }
}


@end

//
//  PhotoBrowserCell.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/17.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "PhotoBrowserProgressView.h"
#import <UIImageView+WebCache.h>


@interface PhotoBrowserCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)PhotoBrowserProgressView *progressView;
@property(nonatomic,assign)CGRect beganFrame;
@property(nonatomic,assign)CGPoint beganTouch;
@end

@implementation PhotoBrowserCell
-(CGPoint )centerOfContentSize{
    CGFloat deltaWidth = self.bounds.size.width - self.scrollView.contentSize.width;
    CGFloat offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0;
    CGFloat deltaHeight = self.bounds.size.height - self.scrollView.contentSize.height;
    CGFloat offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0;
    return CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}
-(CGSize)fitSize{
    if (self.imageView.image) {
        CGFloat width = _scrollView.bounds.size.width;
        CGFloat scale = self.imageView.image.size.height / self.imageView.image.size.width;
        return CGSizeMake(width, width*scale);
    }else{
        return CGSizeZero;
    }
}
-(CGRect )fitFrame{
    CGSize  size = [self fitSize];
    CGFloat y = (self.scrollView.bounds.size.height - size.height) > 0 ? (self.scrollView.bounds.size.height - size.height) * 0.5 : 0;
    return CGRectMake(0, y, size.width, size.height);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]init];
        [self.contentView addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _imageView = [[UIImageView alloc]init];
        [_scrollView addSubview:_imageView];
        _imageView.clipsToBounds = YES;
        
        _progressView = [[PhotoBrowserProgressView alloc]init];
        [self.contentView  addSubview:_progressView];
        _progressView.hidden = YES;
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPress:)];
        [_imageView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubletap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubletap];
        
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        [self addGestureRecognizer:singleTap];
   
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
        pan.delegate = self;
        [_imageView addGestureRecognizer:pan];
     
        [singleTap requireGestureRecognizerToFail:doubletap];
        
    }
    return self;
}
-(void)doLayout{
    _scrollView.frame = self.contentView.bounds;
    [_scrollView setZoomScale:1.0 animated:NO];
    _imageView.frame = [self fitFrame];
    [_scrollView setZoomScale:1.0 animated:NO];
    _progressView.center = CGPointMake(self.contentView.bounds.size.width/2.0, self.contentView.bounds.size.height/2.0);
}
-(void)setImage:(UIImage *)image Url:(NSString *)url
{
    
    if (url !=nil ) {
        self.progressView.hidden = NO;
        __weak typeof(self) _self = self;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if (expectedSize > 0) {
                _self.progressView.progress = (receivedSize/1.0) /expectedSize;
            }
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _self.progressView.hidden = YES;
            [_self doLayout];
        }];
        [self doLayout];
    }else{
        self.imageView.image = image;
        [self doLayout];
        return;
    }
}
-(void)onSingleTap:(UITapGestureRecognizer *)tap
{
    if (_delegate) {
        [_delegate photoBrowserCellDidSingleTap:self];
    }
}

-(void)onDoubleTap:(UITapGestureRecognizer *)tap
{
    CGFloat scale = self.scrollView.maximumZoomScale;
    if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
        scale = 1.0;
    }
    [_scrollView setZoomScale:scale animated:YES];
}
-(void)onPan:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _beganFrame = self.imageView.frame;
            _beganTouch = [pan locationInView:pan.view.superview];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:self];
            CGPoint currentTouch = [pan locationInView:pan.view.superview];
            // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
            CGFloat scale = MIN(1.0, MAX(0.3, 1 - translation.y / self.bounds.size.height));
            CGSize theFitSize = [self fitSize];
            CGFloat width = theFitSize.width * scale;
            CGFloat height = theFitSize.height * scale;
            
            // 计算x和y。保持手指在图片上的相对位置不变。
            // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
            CGFloat xRate = (_beganTouch.x - _beganFrame.origin.x) / _beganFrame.size.width;
            CGFloat currentTouchDeltaX = xRate * width;
            CGFloat x = currentTouch.x - currentTouchDeltaX;
            
            CGFloat yRate = (_beganTouch.y - _beganFrame.origin.y) / _beganFrame.size.height;
            CGFloat currentTouchDeltaY = yRate * height;
            CGFloat y = currentTouch.y - currentTouchDeltaY;
            
            _imageView.frame = CGRectMake(x, y, width, height);

            // 通知代理，发生了缩放。代理可依scale值改变背景蒙板alpha值
            if (_delegate) {
                [_delegate photoBrowserCellDidDrag:self Scale:scale];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if ([pan velocityInView:self].y>0) {
                [self onSingleTap:nil];
            }else{
                [self endPan];
            }
            
        }
            break;
        default:
            [self endPan];
            break;
    }
}
-(void)endPan{
    if (_delegate) {
        [_delegate photoBrowserCellDidDrag:self Scale:1.0];
    }
    // 如果图片当前显示的size小于原size，则重置为原size
    CGSize size = [self fitSize];
    BOOL needResetSize = _imageView.bounds.size.width < size.width
    || _imageView.bounds.size.height < size.height;
    __weak typeof(self) _self = self;
    [UIView animateWithDuration:0.25 animations:^{
        _self.imageView.center = [self centerOfContentSize];
        if (needResetSize) {
            self.imageView.bounds = CGRectMake(0, 0, size.width, size.height);
        }
    }];
 
}
-(void)onLongPress:(UILongPressGestureRecognizer *)GestureRecognizer
{
    if (GestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (_delegate&&_imageView.image) {
            [_delegate photoBrowserCellLogPress:self image:_imageView.image];
        }
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imageView.center = [self centerOfContentSize];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [pan velocityInView:self];
        // 向上滑动时，不响应手势
        if (velocity.y < 0) {
            return NO;
        }
        // 横向滑动时，不响应pan手势
        if (abs((int)velocity.x) > (int)(velocity.y)) {
            return NO;
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if (_scrollView.contentOffset.y > 0) {
            return NO;
        }
        return YES;
        
    }else{
        return YES;
    }
    
    
}
-(void)dealloc
{
//    NSLog(@"cell go die");
}
@end

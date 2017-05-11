//
//  WalePhotoBrowser.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/14.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "WalePhotoBrowser.h"
#import "PhotoBorwsetLayout.h"
#import "PhotoBrowserCell.h"
#import "ScaleAnimatorCoordinator.h"
#import "ScaleAnimator.h"


@interface WalePhotoBrowser ()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PhotoBrowserCellDelegate>

@property(nonatomic,weak)ScaleAnimatorCoordinator *animatorCoordinator;
@property(nonatomic,weak)ScaleAnimator *presentationAnimator;
@property(nonatomic,strong)UIView *relatedView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIViewController *presentingVC;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)PhotoBorwsetLayout *flowLayout;


@end

@implementation WalePhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)configUI
{
    self.flowLayout.minimumLineSpacing = self.photoSapceing;
    self.flowLayout.itemSize = self.view.bounds.size;
    
    self.collectionView.frame = self.view.bounds;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:@"PhotoBrowserCell"];
    [self.view addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc]init];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = [self.deleagte numberOfPhotos:self];
    self.pageControl.currentPage = self.currentIndex;
    self.pageControl.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height-40);
    self.pageControl.hidden = !_isShowPageControl;
    [self.pageControl sizeToFit];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.collectionView layoutIfNeeded];
    
    PhotoBrowserCell *cell = (PhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
    if (cell) {
        self.presentationAnimator.endView = cell.imageView;
        UIImageView *imageView = [UIImageView new];
        imageView.frame = cell.frame;
        imageView.image = cell.imageView.image;
        imageView.contentMode = self.imageScaleMode;
        imageView.clipsToBounds = YES;
        self.presentationAnimator.scaleView = imageView;
    }
    
                                
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.pageControl.hidden = !self.isShowPageControl;
    self.pageControl.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height-40);
}
-(BOOL)shouldAutorotate
{
    return NO;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark init
-(instancetype )initWithpreresentVc:(UIViewController *)vc delegate:(id<PhotoBrowserDelegate>)delegate{
    self = [super init];
    if (self) {
        _isShowPageControl = YES;
        _photoSapceing = 30;
        self.imageScaleMode = UIViewContentModeScaleAspectFill;
        self.presentingVC = vc;
        self.deleagte = delegate;
        self.flowLayout = [[PhotoBorwsetLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(1, @"init(coder:) has not been implemented");
    }
    return self;
}
#pragma mark func
-(void)showWith:(NSInteger )index
{
    
    self.pageControl.numberOfPages = [self.deleagte numberOfPhotos:self];
    self.currentIndex = index;
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [self.presentingVC presentViewController:self animated:YES completion:nil];
}
-(void)simpleShowWithpreresentVc:(UIViewController *)vc delegate:(id<PhotoBrowserDelegate>)delegate WithIndex:(NSInteger)index
{
    WalePhotoBrowser *browser= [self initWithpreresentVc:vc delegate:delegate];
    [browser showWith:index];
}


#pragma mark Setter丶Getter
-(UIView *)relatedView
{
    if (_deleagte) {
       return  [_deleagte photoBrowserView:self WithThumbnailImageForIndex:self.currentIndex];
    }
    return nil;
}
-(void)setIsShowPageControl:(BOOL)isShowPageControl
{
    _isShowPageControl = isShowPageControl;
    _pageControl.hidden = !isShowPageControl;
    
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    
    [self.animatorCoordinator updateCurrentHiddenView:self.relatedView];
    self.flowLayout.lastPage = currentIndex;
    if (_isShowPageControl) {
        self.pageControl.currentPage = currentIndex;
    }
    _currentIndex = currentIndex;
    
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"%ld",[self.deleagte numberOfPhotos:self]);
    
    return [self.deleagte numberOfPhotos:self];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowserCell" forIndexPath:indexPath];
    cell.imageView.contentMode = self.imageScaleMode;
    cell.delegate = self;
    if ([[self imageFor:indexPath.row] isKindOfClass:[NSString class]]) {
        
        [cell setImage:[self.deleagte photoBrowserImage:self WithThumbnailImageForIndex:indexPath.row] Url:[self imageFor:indexPath.row]];
        
    }else{
        //NSLog(@"%@",[self imageFor:indexPath.row]);
        [cell setImage:[self imageFor:indexPath.row] Url:nil];
    }
    
    return cell;
}
-(id )imageFor:(NSInteger )index;
{
    if ([self.deleagte respondsToSelector:@selector(photoBrowserHighImage:WithThumbnailImageForIndex:)]) {
        if ([self.deleagte photoBrowserHighImage:self WithThumbnailImageForIndex:index]) {
            return [self.deleagte photoBrowserHighImage:self WithThumbnailImageForIndex:index];
        }
    }
    if ([self.deleagte respondsToSelector:@selector(photoBrowserUrl:WithThumbnailImageForIndex:)]) {
        NSString *url;
        url = [self.deleagte photoBrowserUrl:self WithThumbnailImageForIndex:index];
        if (url) {
            return url;
        }
    }
    UIImage *thumbnailImage = [self.deleagte photoBrowserImage:self WithThumbnailImageForIndex:index];
    //NSLog(@"1%@",[self.deleagte photoBrowserImage:self WithThumbnailImageForIndex:index]);
    
    return thumbnailImage;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width + self.photoSapceing;
    self.currentIndex = (int)(offsetX/width);
    
}
#pragma mark UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    ScaleAnimator *animator = [[ScaleAnimator alloc]initWith:self.relatedView :nil :nil ];
    NSLog(@"%@",self.relatedView);
    
    
    self.presentationAnimator = animator;
    
    return animator;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    
    
    PhotoBrowserCell *cell = [self.collectionView.visibleCells firstObject];
    if (cell) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = cell.imageView.image;
        imageView.contentMode = self.imageScaleMode;
        imageView.clipsToBounds = YES;
        return [[ScaleAnimator alloc]initWith:cell.imageView :self.relatedView :imageView];
    }else{
        return nil;
    }
  
}
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0)
{
    ScaleAnimatorCoordinator *coordinator = [[ScaleAnimatorCoordinator alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    coordinator.currentHiddenView = self.relatedView;
    self.animatorCoordinator = coordinator;
    return coordinator;
}
#pragma mark PhotoBrowserCellDelegate
-(void)photoBrowserCellDidSingleTap:(PhotoBrowserCell *)cell
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)photoBrowserCellDidDrag:(PhotoBrowserCell *)cell Scale:(CGFloat)scale
{
    NSLog(@"%f",scale*scale);
    self.animatorCoordinator.maskView.alpha = scale * scale;
}
-(void)photoBrowserCellLogPress:(PhotoBrowserCell *)cell image:(UIImage *)image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:-1];
    indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.section>0) {
        [self.deleagte photoBrowserLongPress:self WithThumbnailImageForIndex:indexPath.row Withimage:image];
    }
}
-(void)dealloc
{
    //NSLog(@"vc go die");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

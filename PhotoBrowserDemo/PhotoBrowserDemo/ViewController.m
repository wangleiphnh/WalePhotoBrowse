//
//  ViewController.m
//  PhotoBrowserDemo
//
//  Created by wale1994 on 2017/4/18.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "ViewController.h"
#import "WalePhotoBrowser.h"

@interface ViewController ()<PhotoBrowserDelegate>

@property(nonatomic,strong)NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    _array = [NSMutableArray new];
    for (NSInteger i=0; i<9; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(200+(i%3)*40, 200+(i/3)*40, 30, 30);
        imageView.backgroundColor = [UIColor yellowColor];
        imageView.tag = 1000+i;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"photo%ld",i+1]];
        [_array addObject:imageView];
        [self.view addSubview:imageView];
    }
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)tap:(UIGestureRecognizer *)tap
{
    
    
    WalePhotoBrowser *photoBrowser = [[WalePhotoBrowser alloc]initWithpreresentVc:self delegate:self];
    
    [photoBrowser showWith:tap.view.tag-1000];
//    NSLog(@"%ld",tap.view.tag);
}
/// 实现本方法以返回图片数量
-(NSInteger) numberOfPhotos:(WalePhotoBrowser *)photoBrowser
{
    return 9;
}
/// 实现本方法以返回默认图片，缩略图或占位图
-(UIImage *) photoBrowserImage:(WalePhotoBrowser *)photoBrowser
    WithThumbnailImageForIndex:(NSInteger )index{
    
//    NSLog(@"%ld",index);
   // NSLog(@"%@",[NSString stringWithFormat:@"photo%ld",index+1]);
    //NSLog(@"%@",[UIImage imageNamed:[NSString stringWithFormat:@"photo%ld",index+1]]);
    return [UIImage imageNamed:[NSString stringWithFormat:@"photo%ld",index+1]];
}
-(UIView *) photoBrowserView:(WalePhotoBrowser *)photoBrowser
  WithThumbnailImageForIndex:(NSInteger )index{
    
     
     NSLog(@"%@",_array[index]);
     NSLog(@"%ld",_array.count);
     return _array[index];
     
}
-(NSString *) photoBrowserUrl:(WalePhotoBrowser *)photoBrowser
   WithThumbnailImageForIndex:(NSInteger )index{
    
    return @[@"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
            @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
            @"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
            @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
            @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
            @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
            @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
            @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
             @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7usmc8j20i543zngx.jpg"][index];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  WaleTableView.m
//  PhotoBrowserDemo
//
//  Created by wale1994 on 2017/5/10.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "WaleTableView.h"

@interface WaleTableView ()

@property(nonatomic,copy)BasicForCell BasicForCellBlock;
@property(nonatomic,copy)CellForIndexPath cellReturnBlock;
@property(nonatomic,copy)DiDSelectCellIndexPath cellClickBlock;

@end

@implementation WaleTableView


-(instancetype)initWithFrame:(CGRect)frame
                    WithBasicBlock:(BasicForCell)BasicForCellBlock
                    WithCellForIndexPath:(CellForIndexPath)cellReturnBlock
                    WithCellClickBlock:(DiDSelectCellIndexPath)cellClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}

-(void)configUI
{
//    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    NSArray *cellArray = []
    
}



@end

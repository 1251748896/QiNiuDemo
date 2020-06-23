//
//  BaseTableViewController.h
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/3/14.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UITableViewController
@property (nonatomic, strong) UITableViewCell* cell;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) int page, pageSize;

- (void)initializeDataSource;
- (void)loadSuccess;
- (void)loadFailure;

@end

NS_ASSUME_NONNULL_END

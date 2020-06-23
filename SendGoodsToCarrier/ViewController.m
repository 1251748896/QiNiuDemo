//
//  ViewController.m
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/1/25.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import "ViewController.h"
#import "NetWork.h"
#import "QiNiuSdkTools.h"
#import "ProductListVc.h"
#import "WebViewController.h"
#import "FileUploadDemoViewController.h"
#import "ExcelReaderViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendCarrierStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *netStatusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) NSMutableArray *goodsSourceOrderArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _goodsSourceOrderArray = [NSMutableArray arrayWithCapacity:10];
    [_goodsSourceOrderArray addObjectsFromArray:@[@"1",@"1",@"1",@"1",@"1",@"1",@"1"]];
    
}
- (IBAction)webBtnEvent:(id)sender {
//    WebViewController *vc = [[WebViewController alloc] init];
    ExcelReaderViewController *vc = [[ExcelReaderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)qiniuEvent:(id)sender {
    NSString * url = [[NSBundle mainBundle] pathForResource:@"etongda_video" ofType:@"mp4"];
    NSURL *URLL = [NSURL URLWithString:url];
    [QiNiuSdkTools putVideoMp4Url:URLL complete:^(NSString *videoUrl) {
        NSLog(@"回调videoUrl = %@", videoUrl);
    } failure:^{
        NSLog(@"失败");
    }];
    NSLog(@"iii = %@",url);
}

- (IBAction)loginEvent:(id)sender {
    NSString *url = @"api/services/Auth/Login/PostLogin";
    NSDictionary *param = @{@"mobileNo":@"13333333333",@"password":@"000000"};
    
    [NetWork POST:url parameters:param finish:^(id  _Nonnull obj) {
        NSLog(@"token = %@",obj);
        NSString *token = @"";
        if (obj[@"result"]) {
            token = obj[@"result"][@"tokenValue"];
        }
        if (token) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}
- (IBAction)sendGoodsButtonEvent:(id)sender {
    NSString *url = @"";
    
}
- (IBAction)sendToCarrierEvent:(id)sender {
    ProductListVc *vc = [[ProductListVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)refreshListEvent:(id)sender {
    NSString *temp = @"api/services/Bill/SourceOrder/GetSourceOrderList";  // 货源列表
    NSDictionary *param =@{@"SkipCount":@"0", @"MaxResultCount":@"5"};
    [NetWork GET:temp parameters:param finish:^(id  _Nonnull obj) {
        NSLog(@"货源 = %@",obj);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"订单号: %ld",indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsSourceOrderArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FileUploadDemoViewController *vc = [[FileUploadDemoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end


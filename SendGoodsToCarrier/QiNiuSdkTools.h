//
//  QiNiuSdkTools.h
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/2/14.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
@interface QiNiuSdkTools : NSObject
+ (void)putVideoMp4Url:(NSURL *)mp4URL complete:(void(^)(NSString *videoUrl))complete failure:(void (^)(void))failure;
@end

//
//  NetWork.h
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/1/25.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWork : NSObject
+ (void)post:(NSString *)url param:(NSDictionary *)dict finish:(void(^)(id obj))finish;
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic finish:(void(^)(id obj))finish;
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic finish:(void(^)(id obj))finish;
@end

NS_ASSUME_NONNULL_END

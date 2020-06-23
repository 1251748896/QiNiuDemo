//
//  NetWork.m
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/1/25.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import "NetWork.h"
#import "AFHTTPSessionManager.h"

static NSString *HTTPRootPath = @"http://192.168.1.3:8000/";

@implementation NetWork
+ (void)post:(NSString *)url param:(NSDictionary *)dict finish:(void(^)(id obj))finish {
    NSString *urll = [NSString stringWithFormat:@"%@%@",HTTPRootPath,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/png",@"text/plain", nil];
     [manager.requestSerializer setTimeoutInterval:10.0f];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",dict[@"token"]];
    if (!dict[@"token"]) {
        token = @"Bearer ";
    }
    NSDictionary *header = @{
                             @"Accept":@"application/json",
                             @"Content-Type":@"application/json",
//                             @"Authorization":token
                             };
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//     [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSLog(@"dict = %@",dict);
    NSLog(@"url = %@",urll);
    [manager POST:urll parameters:dict headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        //当前进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finish) {
            finish(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            finish(@{});
        }
        NSLog(@"error = %@",error);
    }];
}

+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic finish:(void(^)(id obj))finish {
    //创建配置信息
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求超时时间：5秒
    configuration.timeoutIntervalForRequest = 10;
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPRootPath,URL]]];
    //设置请求方式：POST
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
        token = [NSString stringWithFormat:@"Bearer %@",token];
        [request setValue:token forHTTPHeaderField:@"Authorization"];
    }
    NSLog(@"request.allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
    //data的字典形式转化为data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            finish(responseObject);
        }else{
            NSLog(@"error = %@",error);
            finish(error);
        }
    }];
    [dataTask resume];
}
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic finish:(void(^)(id obj))finish {
    //创建配置信息
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求超时时间：5秒
    configuration.timeoutIntervalForRequest = 10;
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPRootPath,URL]]];
    //设置请求方式：POST
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
    
    //data的字典形式转化为data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (responseObject) {
                NSLog(@"response = %@",response);
            }
            finish(responseObject);
        }else{
            NSLog(@"%@",error);
            finish(error);
        }
    }];
    [dataTask resume];
}
@end

//
//  QiNiuSdkTools.m
//  SendGoodsToCarrier
//
//  Created by HaoHuoBan on 2019/2/14.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import "QiNiuSdkTools.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation QiNiuSdkTools
#pragma mark - 七牛

+ (NSString *)qiNiuAccessKey {
    return @"NZlLyOxLse5jgT1Rm7NyVYDCc_NYyMxbybsDw3VS";
}

+ (NSString *)qiNiuSecretKey {
    return @"fY42Y9NX6S00AcNA5ncLanVF3MOgjf3kJbWtleC-";
}

+ (NSString *)qiNiuBucket {
    return @"myvideosw";
}
// http://pmw9rzs19.bkt.clouddn.com/4891_etongda_video.mp4

+ (NSString *)qiNiuDomain {
    return @"q0uijx3z0.bkt.clouddn.com";
}

+ (NSString *)getImageFileName {
    NSString *timeStempString = [self getTimeInterValStringWithDate:[NSDate date]];
    NSString *randomString = [self getRandomStr];
    NSString *fileName = [NSString stringWithFormat:@"image_%@%@.png",timeStempString,randomString];
    return fileName;
}
+ (NSString *)getTimeInterValStringWithDate:(NSDate *)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
+ (NSString *)getRandomStr {
    int a = arc4random()%10;
    int b = arc4random()%10;
    int c = arc4random()%10;
    int d = arc4random()%10;
    NSString *s = [NSString stringWithFormat:@"%d%d%d%d",a,b,c,d];
    return s;
}
// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}
/*
 
 1.拼接token
 AK+SK+文件名+七牛的空间名字 + 有效时间  ====>> 一系列的算法 ====>> token
 (1).SK               :      需要遵循UTF8
 (2).上传的配置信息      :     json格式的字符串 = {"scope":"空间名:文件名","deadline":"当前时间的时间戳+3600"}
 (3).配置信息UTF8
 (4).配置信息--->二进制流
 (5).二进制流 --->base64
 (6).base64之后的字符串 再来一次UTF8
 (7).利用oc的 “HMAC“ 散列函数 处理：第一步、第6步 得到的string
 (8).把处理之后的结果 再次 利用base64函数处理一次
 (9).AK+第8步得到的string+第5步得到的string = token
 
 2.上传图片、视频
 3.url = http:// + 空间域名 + 文件名
 
 */

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey bucket:(NSString *)bucket key:(NSString *)key {
    const char *secretKeyStr = [secretKey UTF8String];
    NSString *policy = [self marshal: bucket key:key];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    // ******************************************
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    // *******************************************
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    return token;//得到了token
}

+ (NSString *)marshal:(NSString *)bucket key:(NSString *)key {
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += 3600; // +3600秒,即默认token保存1小时.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //images是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传images:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    NSString *value = [NSString stringWithFormat:@"%@:%@", bucket, key];
    [dic setObject:value forKey:@"scope"];//根据
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSString *json = [self convertToJsonData:dic];
    return json;
}

+ (NSString *)makeTokenKey:(NSString *)key {
    
    if (key == nil) {
        key = [self getImageFileName];
    }
    
    NSString *accessKey = [self qiNiuAccessKey];
    NSString *secretKey = [self qiNiuSecretKey];
    NSString *bucket = [self qiNiuBucket];
    
    const char *secretKeyStr = [secretKey UTF8String];
    NSString *policy = [self marshal: bucket key:key];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    // ******************************************
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    // *******************************************
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    return token;//得到了token
}
+ (void)putVideoMp4Url:(NSURL *)mp4URL complete:(void(^)(NSString *videoUrl))complete failure:(void (^)(void))failure {
    NSLog(@"mp4URL = %@",mp4URL);
    NSData *videoData = [NSData dataWithContentsOfFile:mp4URL.absoluteString];
    NSString *tempsoluteStr = mp4URL.absoluteString;
    NSArray *soluteArr = [tempsoluteStr componentsSeparatedByString:@"/"];
    NSString *fileName = @"";
    
    NSString *randomStr = [self getRandomStr];
    
    fileName = [NSString stringWithFormat:@"%@_%@",randomStr,[soluteArr lastObject]];
    
    NSString *token = [self makeTokenKey:fileName];
    NSString *domain = [self qiNiuDomain];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSLog(@"开始上传");
    [upManager putData:videoData key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"上传完成");
        NSLog(@"info = %@",info);
        NSLog(@"resp = %@",resp);
        /*
         
         resp :
         
         {
         hash = "FuE692ndToHXkz4vECYOva-hpzaG";
         key = "5172_video1514952116ios_9851.mp4";
         }
         
         */
        
        if (resp) {
            NSString *vdourl = [NSString stringWithFormat:@"http://%@/%@",domain,fileName];
            
            if (complete) {
                complete(vdourl);
            }
            
        } else {
            if (failure) {
                failure();
            }
            NSLog(@"请检查网路连接，或重新上传");
        }
    } option:nil];
    
}


@end

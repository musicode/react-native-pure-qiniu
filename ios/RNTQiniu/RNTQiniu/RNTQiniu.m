
#import "RNTQiniu.h"
#import <QiniuSDK.h>

@implementation RNTQiniu

RCT_EXPORT_MODULE(RNTQiniu);

RCT_EXPORT_METHOD(upload:(NSDictionary*)options
                  onSuccess:(RCTResponseSenderBlock)onSuccess
                  onFailure:(RCTResponseSenderBlock)onFailure
                  onProgress:(RCTResponseSenderBlock)onProgress) {

    NSString *path = [RCTConvert NSString:options[@"path"]];
    NSString *key = [RCTConvert NSString:options[@"key"]];
    NSString *zone = [RCTConvert NSString:options[@"zone"]];
    NSString *token = [RCTConvert NSString:options[@"token"]];
    NSString *mimeType = [RCTConvert NSString:options[@"mimeType"]];
    NSDictionary *params = [RCTConvert NSDictionary:options[@"params"]];
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        
        builder.useHttps = YES;
        
        if ([zone isEqual: @"huadong"]) {
            builder.zone = [QNFixedZone zone0];
        }
        else if ([zone isEqual: @"huabei"]) {
            builder.zone = [QNFixedZone zone1];
        }
        else if ([zone isEqual: @"huanan"]) {
            builder.zone = [QNFixedZone zone2];
        }
        else if ([zone isEqual: @"beimei"]) {
            builder.zone = [QNFixedZone zoneNa0];
        }
        
    }];
    
    QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:config];

    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:mimeType
                                                progressHandler:^(NSString *key, float percent) {
                                                    onProgress(@[@{
                                                         @"progress": @(percent),
                                                    }]);
                                                }
                                                params:params
                                                checkCrc:NO
                                                cancellationSignal:nil];
    
    [uploadManager putFile:path key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            onSuccess(@[@{
                 @"success": @(YES),
            }]);
        }
        else {
            // 如果失败，这里可以把 info 信息上报自己的服务器，便于后面分析上传错误原因
            onFailure(@[@{
                 @"success": @(NO),
            }]);
        }
    }
    option:uploadOption];

}

@end

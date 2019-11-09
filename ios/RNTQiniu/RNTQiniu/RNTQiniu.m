
#import "RNTQiniu.h"
#import <QiniuSDK.h>

@implementation RNTQiniu

RCT_EXPORT_MODULE(RNTQiniu);

- (NSArray<NSString *> *)supportedEvents {
  return @[@"progress"];
}

RCT_EXPORT_METHOD(upload:(NSDictionary*)options
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

    int index = [RCTConvert int:options[@"index"]];
    
    NSString *path = [RCTConvert NSString:options[@"path"]];
    NSString *key = [RCTConvert NSString:options[@"key"]];
    NSString *zone = [RCTConvert NSString:options[@"zone"]];
    NSString *token = [RCTConvert NSString:options[@"token"]];
    NSString *mimeType = [RCTConvert NSString:options[@"mimeType"]];
    
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
            
                                                    if (index > 0) {
                                                        [self sendEventWithName:@"progress" body:@{
                                                            @"index": @(index),
                                                            @"progress": @(percent),
                                                        }];
                                                    }
        
                                                }
                                                params:nil
                                                checkCrc:NO
                                                cancellationSignal:nil];
    
    [uploadManager putFile:path key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            resolve(resp);
        }
        else {
            reject([NSString stringWithFormat:@"%d", info.statusCode], info.error.localizedDescription, nil);
        }
    }
    option:uploadOption];

}

@end

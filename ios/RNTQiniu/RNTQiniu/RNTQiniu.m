
#import <React/RCTRootView.h>

#import "RNTQiniu.h"

@implementation RNTQiniu

RCT_EXPORT_MODULE(RNTQiniu);

RCT_EXPORT_METHOD(getStatusBarHeight:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

    dispatch_async(dispatch_get_main_queue(), ^{

        resolve(@{
          @"height": @(RCTSharedApplication().statusBarFrame.size.height),
        });

    });

}

RCT_EXPORT_METHOD(getNavigationBarInfo:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

    dispatch_async(dispatch_get_main_queue(), ^{

        resolve(@{
          @"height": @(0),
          @"visible": @(FALSE),
        });

    });

}

RCT_EXPORT_METHOD(getScreenSize:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

    dispatch_async(dispatch_get_main_queue(), ^{

        CGRect bounds = UIScreen.mainScreen.bounds;

        resolve(@{
          @"width": @(bounds.size.width),
          @"height": @(bounds.size.height),
        });

    });

}

@end

//
//  FTUWebJSBridgeGetDataObject.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebJSBridgeGetDataObject.h"

@implementation FTUWebJSBridgeGetDataObject

{
    FTUWebJSBridgeObjectActionBlock _action;
    id _data;
    NSString *type;
}

- (NSString *)name {
    return @"getData";
}


- (FTUWebJSBridgeObjectActionBlock)action {
    if (_action == nil) {
        __block __weak id weakData = _data;
        _action = ^(NSString *name, id data) {
            weakData = data;
            JROJSBridgeModel *model = [[JROJSBridgeModel alloc] initWithJSON:data];
            type = model.type ?: @"";
        };
    }
    return [_action copy];
}

- (id)responseData {
    return [self callbackinJson];
}

-(NSString *)callbackinJson{
    //用户信息
    if ([type isEqualToString:@"userInfo"]) {
//        if ([JJCSuDaiUser currentUser].userId.length && [JJCSuDaiUser currentUser].phoneNumber.length && [JJCSuDaiUser currentUser].token.length) {
//            NSDictionary *userinfoDic =@{
//                                         @"user_id":[JJCSuDaiUser currentUser].userId ?: @"",
//                                         @"phone":[JJCSuDaiUser currentUser].phoneNumber ?: @"",
//                                         @"token":[JJCSuDaiUser currentUser].token ?: @""
//                                         };
//            return [self callbackJSONWithStatus:@"1" code:@"10101" message:@"get userInfo success" data:userinfoDic];
//        }else{
            return [self callbackJSONWithStatus:@"0" code:@"00101" message:@"get userInfo failed" data:nil];
//        }
    //卡管家用户信息
    //版本包名
    }else if([type isEqualToString:@"version"]) {
        NSDictionary *versionDic = @{
                                    @"plat_type":@"2",
                                    @"plat_version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                    @"package_name":[NSString stringWithFormat:@"iOS_%@", [[NSBundle mainBundle] bundleIdentifier]],
                                    @"source_id":@"iOS",
                                    @"channel_id":@"",
                                    @"terminal_id":[JROUUID getUUID],
                                    };
        return [self callbackJSONWithStatus:@"1" code:@"10103" message:@"get version success" data:versionDic];
    //设备相关信息(暂无)
    } else if ([type isEqualToString:@"device"]){
        CGSize size = [UIScreen mainScreen].bounds.size;
        NSDictionary *deviceDic = @{
                                    @"dev_num" : [UIDevice currentDevice].UUIDString,
                                    @"uuid" : [UIDevice currentDevice].UUIDString,
                                    @"dev_no" : [[UIDevice currentDevice] deviceModelName],
                                    @"net_info" : [[UIDevice currentDevice] networkType],
                                    @"app_name" : [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"],
                                    @"dev_sys" : [[UIDevice currentDevice] deviceSystemInfomation],
                                    @"plat_version" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                    @"plat_type" : @"2",
                                    @"package_name" : [NSString stringWithFormat:@"iOS_%@", [[NSBundle mainBundle] bundleIdentifier]],
                                    @"source_id" : JJC_SOURCE_ID,
                                    @"app_union_name" : JRO_APP_UNION_NAME,
                                    @"idfa" : [UIDevice currentDevice].identifierForIdentifier,
                                    @"idfv" : [[UIDevice currentDevice].identifierForVendor UUIDString],
                                    @"screenSize" : [NSString stringWithFormat:@"%.0lf*%.0lf", size.width, size.height],
                                    @"mobileOperators" : [UIDevice currentDevice].carrierName,
                                    @"countryCode" : [UIDevice currentDevice].localeCountryString,
                                    @"languageCode" : [UIDevice currentDevice].languageString,
                                    @"capcitySize" : [NSString stringWithFormat:@"%.2lf GB", [UIDevice currentDevice].getTotalDiskSize / 1024.0 / 1024.0 / 1024.0],
                                    @"dev_brand" : @"Apple",
                                    @"model" : [UIDevice currentDevice].deviceModelName
                                    //                                    @"lng":[NSString stringWithFormat:@"%lf", locationModel.longitude],
                                    //                                    @"lat":[NSString stringWithFormat:@"%lf", locationModel.latitude],
                                    };
        return [self callbackJSONWithStatus:@"1" code:@"10104" message:@"get device success" data:deviceDic];
    } else {
        return [self callbackJSONWithStatus:@"0" code:@"00100" message:@"no type match" data:nil];
    }
}


@end

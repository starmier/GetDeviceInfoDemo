//
//  GetDevInfoUtil.m
//  MobileOffice
//
//  Created by gdcn on 15-3-16.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "GetDevInfoUtil.h"
#import <sys/utsname.h>
#import <dlfcn.h>
#import <sys/socket.h>
#import <net/if_dl.h>
#import <net/if.h>
#include <sys/sysctl.h>



#define	CTL_NET		4		/* network, see socket.h */

@implementation GetDevInfoUtil

//<MEID/>          移动终端设备标识码//重装后会发生变化
+(NSString *)getMEIDCode{
    NSString *ieidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    return ieidString;
}
//<CORPORATION/>   生产厂商/品牌商（即供应商）
+(NSString *)getCorporation{
    return @"苹果公司";
}
//<MOBILE_TYPE/>   设备类型
+ (NSString *)getSystemName
{
    return [[UIDevice currentDevice] model];
}
//<MODEL/>     移动终端型号
+ (NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
//<OS/>       操作系统
+ (NSString *)getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//<MAC/> 获取MAC码
//ios7以后获取到的mac码都为02:00:00:00:00:00
//ios7之前可以获取的到：例如FC:25:3F:33:25:75
+ (NSString *)getMacCode

{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

//<IMSI/>      IMSI码  私有api appstore申请上线会被拒
+(NSString *)getIMSICode{
    const char *imsiPath = NULL;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version < 5.0) {
        
        imsiPath = "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony";
        
    } else {
        
        imsiPath = "/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony";
        
//        imsiPath = "/Applications/Xcode5.1.1.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony";
        
    }
    
    void *kit = dlopen(imsiPath,RTLD_LAZY);
    
    int (*CTSIMSupportCopyMobileSubscriberIdentity)() = dlsym(kit, "CTSIMSupportCopyMobileSubscriberIdentity");
    
    NSString* imsiString = [NSString stringWithFormat:@"%d",CTSIMSupportCopyMobileSubscriberIdentity(nil)];
    
    dlclose(kit);
    
    return imsiString;
}
@end

//
//  GetDevInfoUtil.h
//  MobileOffice
//
//  Created by gdcn on 15-3-16.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDevInfoUtil : NSObject

//<MEID/>          移动终端设备标识码
+(NSString *)getMEIDCode;

//<CORPORATION/>   生产厂商/品牌商（即供应商）
+(NSString *)getCorporation;

//<MOBILE_TYPE/>   设备类型
+ (NSString *)getSystemName;

//<MODEL/>     移动终端型号
+ (NSString *)getDeviceType;

//<OS/>       操作系统
+ (NSString *)getSystemVersion;

//<MAC/> 获取MAC码
+ (NSString *)getMacCode;


//<IMSI/>      IMSI码
+(NSString *)getIMSICode;

@end

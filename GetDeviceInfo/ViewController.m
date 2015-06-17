//
//  ViewController.m
//  GetDeviceInfo
//
//  Created by gdcn on 15-3-16.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "ViewController.h"
#import "GetDevInfoUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *identifierForVendorStr = [[UIDevice currentDevice] identifierForVendor];//重装后会发生变化
//    NSString *advertisingIdentifierStr = [[UIDevice currentDevice] advertisingIdentifier];//重装后不会发生变化
    
    
//    <MEID/>          移动终端设备标识码
//    MEID移动设备识别码(Mobile Equipment Identifier)是CDMA手机的身份识别码，也是每台手机有唯一的识别码。通过这个识别码，网络端可以对该手机进行跟踪和监管。用于CDMA制式的手机。MEID的数字范围是十六进制的，和IMEI的格式类似。
    NSString *meidStr = [GetDevInfoUtil getMEIDCode];
//	<CORPORATION/>   生产厂商/品牌商（即供应商）
    NSString *corporationStr = [GetDevInfoUtil getCorporation];
//	<MODEL/>     移动终端型号
    NSString *typeStr = [GetDevInfoUtil getDeviceType];
//  <MOBILE_TYPE/>   设备类型
    NSString *deviceStr = [GetDevInfoUtil getSystemName];
//	<OS/>       操作系统
    NSString *osStr = [GetDevInfoUtil getSystemVersion];
//	<MAC/>      MAC码
    NSString *macStr = [GetDevInfoUtil getMacCode];
    
//	<IMSI/>      IMSI码
    NSString *imsiStr = [GetDevInfoUtil getIMSICode];
    
    NSString *log  = [NSString stringWithFormat:@"meidStr:%@\ncorporationStr:%@\ntypeStr:%@\ndeviceStr:%@\nosStr:%@\nmacStr:%@\nimsiStr:%@",meidStr,corporationStr,typeStr,deviceStr,osStr,macStr,imsiStr];
    NSLog(@"info-----%@",log);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

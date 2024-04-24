//
//  FLYMacros.h
//  Elevator
//
//  Created by fly on 2018/11/8.
//  Copyright © 2018年 fly. All rights reserved.
//

#ifndef FLYMacros_h
#define FLYMacros_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


#ifdef DEBUG
#define FLYLog(...) NSLog(__VA_ARGS__)
#else
#define FLYLog(...)
#endif

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

#define RGB(r,g,b,a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:a]

//随机颜色
#define RGB_ARC4 RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1);

//状态栏高度
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

//导航栏高度
#define NAVBAR_HEIGHT [[UINavigationController alloc] init].navigationBar.frame.size.height

//状态栏高度+导航栏高度
#define STATUSADDNAV_HEIGHT (STATUSBAR_HEIGHT + NAVBAR_HEIGHT)

//tabber高度
#define TABBER_HEIGHT self.tabBarController.tabBar.frame.size.height

//安全距离底部的高度
#define SAFE_BOTTOM [FLYTools safeAreaInsets].bottom


#define IMAGENAME(name) [UIImage imageNamed:name]
#define COLORHEX(hex) [UIColor colorWithHexString:hex]


//获取APP名称
#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

//获取Bundle Identifier
#define APP_BUNDLEIDENTIFIER ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])

//项目版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//项目的build版本号
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])


#define FONT_R(font) [UIFont fontWithName:PFSCR size:font]
#define FONT_M(font) [UIFont fontWithName:PFSCM size:font]
#define FONT_S(font) [UIFont fontWithName:PFSCS size:font]
#define FONT_L(font) [UIFont fontWithName:PFSCL size:font]
#define FONT_U(font) [UIFont fontWithName:PFSCU size:font]
#define FONT_T(font) [UIFont fontWithName:PFSCT size:font]


//苹方-简 常规体
#define PFSCR @"PingFangSC-Regular"
//苹方-简 中黑体
#define PFSCM @"PingFangSC-Medium"
//苹方-简 中粗体
#define PFSCS @"PingFangSC-Semibold"
//苹方-简 细体
#define PFSCL @"PingFangSC-Light"
//苹方-简 极细体
#define PFSCU @"PingFangSC-Ultralight"
//苹方-简 纤细体
#define PFSCT @"PingFangSC-Thin"



//正确返回码
#define CODE_CORRECT @"200"
//服务器状态码字段
#define SERVER_STATUS @"code"
//服务器消息字段
#define SERVER_MSG @"message"
//服务器数据字段
#define SERVER_DATA @"content"



#pragma mark - 加密解密

#define AES_KEY  @"1234567890abcdef"

// RSA公钥
#define RSA_PUBLIC_KEY @"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArSiS/J4eXAEp/T5WpFmRhx2gg5jlyNW1WDqkvrTxVsX8h1CtejtDHhpcx8LFPhqAnYpGKiuYfKuGqpuN7onEBAQF/GEyQCq8rLiTKfIck1FLj/y01c+75X+iosY2As+8tY10aOTigXaOYCjPFUJ5d0UV/cNRgZJ1ea40rgChoMFdheSqOd0dfKQt2ayAXJ/+CyWuSY6ryolCBsndPUJgxZYm+UBt7hqf95bo45NV7/8a0PINFtQ3MftKGSG8yjcmXfCkGXcOPwgFyePPmmVjy4oMpUwMJG2jTITQ6HXQ/ZNTUn1Pq5LvLmneEQ3bsgSpVbMkmxuT5XhuHHIhIy7CIwIDAQAB\n-----END PUBLIC KEY-----"

// RSA私钥
#define RSA_PRIVATE_KEY @"-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCtKJL8nh5cASn9PlakWZGHHaCDmOXI1bVYOqS+tPFWxfyHUK16O0MeGlzHwsU+GoCdikYqK5h8q4aqm43uicQEBAX8YTJAKrysuJMp8hyTUUuP/LTVz7vlf6KixjYCz7y1jXRo5OKBdo5gKM8VQnl3RRX9w1GBknV5rjSuAKGgwV2F5Ko53R18pC3ZrIBcn/4LJa5JjqvKiUIGyd09QmDFlib5QG3uGp/3lujjk1Xv/xrQ8g0W1Dcx+0oZIbzKNyZd8KQZdw4/CAXJ48+aZWPLigylTAwkbaNMhNDoddD9k1NSfU+rku8uad4RDduyBKlVsySbG5PleG4cciEjLsIjAgMBAAECggEAXcnRO2TFWt4CiTk/ooslCMMiUsT5CPu/2ocA/o5w/agFLKGlJMR+iQqMYGJ9hTLDoRDpCiRM1pHtQfE5Qg96jRZEy7s1hY3gXcknZJvPoHdy7w1YQUrgIeEtDO9BB+rO8qMofzwh9y9o1GqmJ4S218Qisi0ds4nJeVvDCtAquy+8KQ86fU4TPgjLIY2YHJLnD6ZsSueVYNHeJaRS/XWrprOs7bvqtpDQOHo2BcZFMbnRSiqOttUC19zpWdY2/2xyiR/81TwvHfequnLV9xwlVd+0BisIqNKkQfs/0EquI7dYD+wjfpINNFFLVC87KIZxtCxu0uaix6XnWmphj2V3YQKBgQDi7tQKmQGGybj7jVT4wDprd+iIDkLXOQn0RLV4an5rjI01xk8WagmLcvHq5nIG+QgAIx1MBHLLkX8BO1Jy3FHFFln5eI7TpXp6NclGB7WnECm0myMwuLCK5w9u3k+ZrrpnKltiDgstPcpkTI0gFApKkx+Oap26buOpLI9oNuLrEwKBgQDDVnj5txwLYuNmNPD8iS8pXUL9ytIXgY6odybuV0docbt7aWLll/XivVsH3oGhaTGvqX9yHQUh4uic2b7Pkz8pNAMA7nTSaKLlAx6Fx6oD10WH5+VC7T9TqLZ8bmQMLZjcaUwv0LWEwG/Sdof+Jf8zUYeDlmvDrmkZ8seOLgoesQKBgQDYD2WJNYYzi8n4juZw86xrd73IFDPlcCQfEm/o1xPIWAh2Q3o3L/wobecQrBmys9W/M6+IGdAmKz/Nr2pfe47K4+4ETJlHvwyuYJlieKKmDgh3MSG/GIjVpwqVl0oYWziUUsqwwAg6KdORzSSsfwgRWqQ31yCXSU6uWoOrSF6iSwKBgQDCEKkDvo2YKlitdC9vVYOLXuJtbhEn1Uk7yZTd+cwx0bxnsZ3VaBGbgHBt8vtqty3rzUOWxYoRznM3UYUmiK2Za9kIFd/uIpKjX2P1mRYp1rd3fEXjJf1iSh1ypeGzz6EsaViNsJaGGwF9YNFfB7Tw8TDm5IyPzjkQ1Ii5krfvIQKBgQDMERgoNuQFbvBEWWFLKCIsl182nwczm61ao+k1ZM8GDPbM7u26PblOs9Ggfu6fH1rxfzYxI2FWHNlvryShHvjeD929VnVsin1THSrcuU/CCFLmUi1mZdp21m5ZFUNmDSYGh7yMtvm4QYLnv97JEwHQAW7c7U/VDnbUXLZ0/nU0Wg==\n-----END PRIVATE KEY-----"



#pragma mark - 探鸽相关

//探鸽baseUrl
#define TGBASE_API @"http://device.plt.tange365.com/openapi"
//探鸽AppId
#define TGAPPID @"2517919"
//探鸽AccessKey
#define TGACCESSKEY @"fv8fkiwxo84fn2nl"
//探鸽SecretKey
#define TGSECRETKEY @"85nu2j2hkduyfb9r9kmia2eqs9o4y1hr"



#endif


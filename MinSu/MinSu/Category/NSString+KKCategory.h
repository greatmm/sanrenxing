//
//  NSString+KKCategory.h
//  EasyToWork
//
//  Created by GKK on 2017/12/19.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KKCategory)
- (CGFloat)getHeightWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize;//计算文字高度
- (CGFloat)getWidthWithFontSize:(CGFloat)fontSize;//计算宽度
- (BOOL)isPhoneNumber;//是否是手机号
- (BOOL)isIdNumber;//是否是身份证号
- (BOOL)isPwd;//6-16位
- (BOOL)isAuthCode;//是否是验证码
- (NSString *)md5String;//MD5加密
- (BOOL)isEmail;//邮箱格式是否正确
@end

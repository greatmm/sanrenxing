//
//  KKAlert.m
//  EasyToWork
//
//  Created by GKK on 2017/12/28.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKAlert.h"


@interface KKAlert()

@end
@implementation KKAlert
+ (void)showAnimateWithStauts:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];

//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"ff5a0f"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showWithStatus:status];
//   [SVProgressHUD showImage:[UIImage imageNamed:@"loading.gif"] status:status];
}
+ (void)dismiss
{
    [SVProgressHUD dismiss];
}
+ (void)showErrorHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showErrorWithStatus:hint];
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"ff5a0f"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD dismissWithDelay:1.5];
}
+ (void)showSuccessHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"ff5a0f"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showSuccessWithStatus:hint];
    [SVProgressHUD dismissWithDelay:1.5];
}
+ (void)showHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"ff5a0f"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showWithStatus:hint];
    [SVProgressHUD dismissWithDelay:1.5];
}
@end

//
//  KKAlert.h
//  EasyToWork
//
//  Created by GKK on 2017/12/28.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKAlert : NSObject
+ (void)showAnimateWithStauts:(NSString *)status;
+ (void)dismiss;
+ (void)showErrorHint:(NSString *)hint;
+ (void)showSuccessHint:(NSString *)hint;
@end

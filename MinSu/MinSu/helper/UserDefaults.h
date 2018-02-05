//
//  UserDefaults.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/25.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject
+ (void)saveToken:(NSString *)token;
+ (NSString *)token;
+ (void)saveRCToken:(NSString *)rcToken;
+ (NSString *)rcToken;
+ (void)saveCityName:(NSString *)cityName;
+ (NSString *)cityName;
+ (void)saveUserInfoUpdate:(BOOL)update;
+ (BOOL)userInfoUpdate;
+ (void)saveAddressUpdate:(BOOL)update;
+ (BOOL)addressUpdate;
+ (void)saveCollectUpdate:(BOOL)update;
+ (BOOL)collectUpdate;
+ (void)saveIsHouse:(BOOL)isHouse;
+ (BOOL)isHouse;
+ (void)saveAddLK:(BOOL)isLK;
+ (BOOL)isLK;
+ (void)clearCache;

@end

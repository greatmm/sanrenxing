//
//  UserDefaults.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/25.
//

#import "UserDefaults.h"

@implementation UserDefaults
+ (void)saveToken:(NSString *)token
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:userToken];
    [defaults synchronize];
}
+ (NSString *)token
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:userToken];
}
+ (void)saveRCToken:(NSString *)rcToken
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setValue:rcToken forKey:@"rcToken"];
    [defaults synchronize];
}
+ (NSString *)rcToken
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"rcToken"];
}
+ (void)saveCityName:(NSString *)cityName
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setValue:cityName forKey:localCity];
    [defaults synchronize];
}
+ (NSString *)cityName
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:localCity];
}
+ (void)saveUserInfoUpdate:(BOOL)update
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:update forKey:userInfoUpdate];
    [defaults synchronize];
}
+ (BOOL)userInfoUpdate
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:userInfoUpdate];
}
+ (void)saveAddressUpdate:(BOOL)update
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:update forKey:addressUpdate];
    [defaults synchronize];
}
+ (BOOL)addressUpdate
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:addressUpdate];
}
+ (void)saveCollectUpdate:(BOOL)update
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:update forKey:collectUpdate];
    [defaults synchronize];
}
+ (BOOL)collectUpdate
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:collectUpdate];
}
+ (void)saveIsHouse:(BOOL)isHouse
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:isHouse forKey:@"isHouse"];
    [defaults synchronize];
}
+ (BOOL)isHouse
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isHouse"];
}
+ (void)saveAddLK:(BOOL)isLK
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:isLK forKey:addLK];
    [defaults synchronize];
}
+ (BOOL)isLK
{
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:addLK];
}
+ (void)clearCache
{
    [self saveToken:nil];
    [self saveUserInfoUpdate:NO];
    [self saveCollectUpdate:NO];
    [self saveAddressUpdate:NO];
    [self saveIsHouse:NO];
    [self saveAddLK:NO];
    [self saveRCToken:nil];
}
@end

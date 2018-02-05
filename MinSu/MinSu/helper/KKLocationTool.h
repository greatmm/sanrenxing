//
//  KKLocationTool.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import <Foundation/Foundation.h>

@interface KKLocationTool : NSObject
-(void)startLocation;
@property(nonatomic,strong)void(^getCityBlock)(void);
@end

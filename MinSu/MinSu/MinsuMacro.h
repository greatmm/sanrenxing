//
//  MinsuMacro.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#ifndef MinsuMacro_h
#define MinsuMacro_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabbarColor [UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1]
#define k153Color [UIColor colorWithWhite:153/225.0 alpha:1]
#define k102Color [UIColor colorWithWhite:102/225.0 alpha:1]
#define k40Color [UIColor colorWithWhite:40/225.0 alpha:1]
#define kYellowColor [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0/255.0 alpha:1]
#define isIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define kkWeakSelf __weak typeof(self) weakSelf = self;
#endif /* MinsuMacro_h */

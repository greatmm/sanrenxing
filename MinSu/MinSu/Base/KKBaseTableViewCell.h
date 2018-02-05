//
//  KKBaseTableViewCell.h
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBaseTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPath;

@end

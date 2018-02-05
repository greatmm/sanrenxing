//
//  DetailTableViewCellValue1.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import "KKBaseTableViewCell.h"

@interface DetailTableViewCellValue1 : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *pingjiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;

@end

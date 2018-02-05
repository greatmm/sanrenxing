//
//  PingjiaHuifuViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "PingjiaHuifuViewController.h"
#import "CMInputView.h"
#import "PingjiaHuifuTableViewCell.h"
@interface PingjiaHuifuViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;//底部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBotttomCon;//距离底部的距离
@property (weak, nonatomic) IBOutlet CMInputView *inputView;
@property(nonatomic,strong) NSArray * dataArr;
@property(nonatomic,strong) NSDictionary * commentDic;
@end

@implementation PingjiaHuifuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.inputView.placeholder = @"回复";
    self.title = @"评论回复";
    self.inputView.maxNumberOfLines = 5;
    kkWeakSelf
    self.inputView.textChangedBlock = ^(NSString *text, CGFloat textHeight) {
        if (textHeight <= 30) {
            weakSelf.inputHeight.constant = 50;
        } else {
            weakSelf.inputHeight.constant = textHeight - 30 + 50;
        }
        [weakSelf.view layoutIfNeeded];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getData];
}
- (void)getData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getPingjiahuifuListWithParm:@{@"token":[UserDefaults token],@"comment_id":self.comment_id} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * dict = dic[@"data1"];
            if (dict) {
                self.commentDic = dict;
            }
            NSArray * data = dic[@"data2"];
            if (data) {
                self.dataArr = data;
            }
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    self.toBotttomCon.constant = keyboardHeight;
    [self.view layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.toBotttomCon.constant = 0;
    [self.view layoutIfNeeded];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self commitHuifu];
        return NO;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PingjiaHuifuTableViewCell * cell = [PingjiaHuifuTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dict;
    if (indexPath.section == 0) {
        dict = self.commentDic;
        if (dict) {
            NSNumber * isZan = dict[@"u_coll"];
            kkWeakSelf
            NSDictionary * parm = @{@"token":[UserDefaults token],@"comment_id":dict[@"comment_id"]};
            cell.clickZanbtnBlock = ^{
                if (isZan.integerValue == 1) {
                    [weakSelf cancelZanWithPram:parm];
                } else {
                    [weakSelf zanWithParm:parm];
                }
            };
        }
        cell.zanBtn.hidden = NO;
    } else {
        cell.zanBtn.hidden = YES;
        dict = self.dataArr[indexPath.row];
        cell.clickZanbtnBlock = nil;
    }
    if (dict) {
        [cell assignWithDic:dict];
    }
    return cell;
}
- (void)zanWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"点赞中"];
    [KKNetWork zanHuifuWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self getData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"点赞失败"];
    }];
}
- (void)cancelZanWithPram:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"取消点赞中"];
    [KKNetWork cancelZanHuifuWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self getData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"取消点赞失败"];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        if (self.dataArr) {
            return self.dataArr.count;
        }
        return 0;
    }
    return 1;
}
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict;
    if (indexPath.section == 0) {
        dict = self.commentDic;
    } else {
        dict = self.dataArr[indexPath.row];
    }
    NSString * content = @"  ";
    if (dict[@"content"]) {
        content = dict[@"content"];
    }
    CGFloat h = [content getHeightWithWidth:ScreenWidth - 90 fontSize:14];
    return 70 + h;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
       UIView * header = [UIView new];
       header.frame = CGRectMake(0, 0, ScreenWidth, 40);
       header.backgroundColor =  [UIColor whiteColor];
       UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 40)];
       label.text = @"全部评论";
       label.font = [UIFont systemFontOfSize:14];
       label.textColor = k102Color;
       [header addSubview:label];
       return header;
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 40;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)commitHuifu
{
    NSString * content = self.inputView.text;
    if (content.length == 0) {
        [KKAlert showErrorHint:@"请输入您的回复"];
        return;
    }
    [KKAlert showAnimateWithStauts:@"回复提交中"];
    [KKNetWork pingjiaHuifuWithParm:@{@"token":[UserDefaults token],@"content":content,@"comment_id":self.commentDic[@"comment_id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self.view endEditing:YES];
            [self.inputView clearText];
            [self getData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"回复提交失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

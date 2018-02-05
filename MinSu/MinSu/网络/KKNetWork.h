//
//  KKNetWork.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/21.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface KKNetWork : NSObject

#pragma mark - 登录注册发送验证码
+ (void)sendVerifyWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//发送验证码
+ (void)dynamicLoginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//动态登录
+ (void)loginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//账号密码登录
+ (void)thirdLoginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//三方登录
+ (void)newPwdWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//忘记密码
+ (void)editPwdWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//修改密码
#pragma mark - 签到
+ (void)getSignInInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取签到信息
+ (void)signInWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//签到

#pragma mark - 个人信息
+ (void)indexInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取个人中心信息
+ (void)getUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取个人信息
+ (void)getAboutUsWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//关于我们
+ (void)uploadAvatarWithPara:(NSDictionary *)para img:(UIImage *)img fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//上传头像
+ (void)updateNickNameWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//修改昵称
+ (void)updateEmailWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//修改邮箱
+ (void)updateSexWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//修改性别

+ (void)updateBirthdayWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//修改生日
+(void)addNameUserWithParm:(NSDictionary *)para imgS:(NSDictionary *)imgDic SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提交实名认证
+ (void)addHoustUserWithParm:(NSDictionary *)para imgS:(NSDictionary *)imgDic SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提交房东认证
+ (void)getNameUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取提交的实名认证信息
+ (void)getHoustUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房东认证信息

+ (void)getFdYueWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房东账户余额
+ (void)getFdTixianInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房东提现页面信息
+ (void)submitTixianWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提现
+ (void)getBankcardListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取银行卡列表
+ (void)addBankCardWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//添加银行卡
+ (void)getFDShouzhiWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房东收支记录
#pragma mark - 收货地址
+ (void)getAddressListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取收货地址
+ (void)addAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//添加收货地址
+ (void)setDefaultAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//设置默认地址
+ (void)deleteAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//删除收货地址
+ (void)editAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//编辑收货地址
+ (void)feedBackWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提交意见反馈

#pragma mark - 房东
+ (void)addHoustInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取添加房源信息
+ (void)getCityWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取城市
+ (void)getAreaWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取区县
+ (void)getStreetWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取街道
+ (void)addHouseWithParm:(NSDictionary *)parm imageArr:(NSArray *)imageArr SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//上传房源
+ (void)getFdHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东获取自己的房屋列表
#pragma mark - 首页
+ (void)getHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取首页房屋列表
+ (void)getHouseDetailWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房屋详情
+ (void)addCollectWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//收藏
+ (void)delCollectWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//取消收藏
+ (void)getCollectListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//我的收藏列表
+ (void)getSearchHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房屋搜索
+ (void)getCityListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//城市列表
+ (void)searchCityWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//城市搜索
#pragma mark - 优惠券
+ (void)getCouponListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//优惠券列表
+ (void)getCouponWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//领取优惠券
+ (void)getMyCouponWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取我的优惠券

#pragma mark - 消息
+ (void)getSystemMsgWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取消息列表
+ (void)getOrderMsgWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取订单信息
+ (void)getRTokenWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取融云token
+ (void)addChatWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//添加聊天列表
+ (void)getChatListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//历史聊天列表
#pragma mark - 订单
+ (void)addOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提交订单
+ (void)getOrderPayInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取支付页面数据
+ (void)paySuccessWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//支付成功之后调用的接口
+ (void)getOrderListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//全部订单
+ (void)getCheckInOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取入住中订单
+ (void)getWaitToCheckInOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取待入住订单
+ (void)getQuitedOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取已退房订单
+ (void)getCanceledOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取已取消订单
+ (void)cancelOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//取消订单
+ (void)deleteOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//删除订单
+ (void)getTuikuanInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//申请退款信息
+ (void)applyTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//申请退款
+ (void)applyTuifangInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提前退房页面信息
+ (void)appleyTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//提前退房提交
+ (void)fdAgreeTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东是否同意退款
+ (void)fdAgreeTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东是否同意退房
+ (void)getHouseOrderListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东全部订单
+ (void)getHouseOrderDairuzhuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东待入住订单
+ (void)getHouseOrderRuzhuzhongWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东入住中订单
+ (void)getHouseOrderShenQingTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东申请退款订单
+ (void)getHouseOrderrTiqianTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东提前退房订单
+ (void)fdEnsureTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东确认退房
+ (void)getHouseOrderYiTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房东已退房订单
+ (void)fdEnsureRuzhuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//确认入住
+ (void)fdEnsureTiqianTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//确认提前退房
#pragma mark - 房屋评价

+ (void)pingjiaHouseWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//评价房源
+ (void)getHousePingjiaListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房源评价
+ (void)getPingjiahuifuListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取房源评价回复
+ (void)pingjiaHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//房源评价回复
+ (void)zanHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//回复点赞
+ (void)cancelZanHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//取消点赞
#pragma mark - 常用旅客
+ (void)getLkListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取旅客列表
+ (void)addLKWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//添加旅客
+ (void)delLKWithWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//删除旅客
+ (void)editLKWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//编辑旅客
+ (void)lkInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//旅客信息
#pragma mark - 支付
+ (void)getAlipayOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取支付宝订单
+ (void)getWxpayOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//获取微信支付订单
#pragma mark - 发布文章

+ (void)postSingImageArticleWithPara:(NSDictionary *)para img:(UIImage *)img fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//发表单图文章

+ (void)postImagesArticleWithParm:(NSDictionary *)parm imageArr:(NSArray *)imageArr SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//发表多图文章
+ (void)postVideoArticleWithParm:(NSDictionary *)parm videoPath:(NSString *)videoPath SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;//发表视频文章
@end

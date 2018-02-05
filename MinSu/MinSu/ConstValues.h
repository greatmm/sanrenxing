//
//  ConstValues.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const baseUrl;

#pragma mark - 登录注册
UIKIT_EXTERN NSString * const authCodeSendUrl;//发送验证码
UIKIT_EXTERN NSString * const authCodeLoginUrl;//验证码登录
UIKIT_EXTERN NSString * const loginUrl;//账号密码登录
UIKIT_EXTERN NSString * const thirdLoginUrl;//三方登录
UIKIT_EXTERN NSString * const forgetPwdUrl;//忘记密码
UIKIT_EXTERN NSString * const editPwdUrl;//修改密码

#pragma mark - 签到
UIKIT_EXTERN NSString * const signInInfoUrl;//获取签到信息
UIKIT_EXTERN NSString * const signInUrl;//签到

#pragma mark - 个人中心
UIKIT_EXTERN NSString * const userIndex;//用户信息
UIKIT_EXTERN NSString * const aboutUsUrl;//关于我们
UIKIT_EXTERN NSString * const feedBackUrl;//反馈
UIKIT_EXTERN NSString * const userInfoUrl;//获取个人信息
UIKIT_EXTERN NSString * const uploadHeaderPicUrl;//上传头像
UIKIT_EXTERN NSString * const updateNickNameUrl;//更新用户名
UIKIT_EXTERN NSString * const updateEmailUrl;//更新邮箱
UIKIT_EXTERN NSString * const updateSexUrl;//更新性别
UIKIT_EXTERN NSString * const updateBirthdayUrl;//更新生日
UIKIT_EXTERN NSString * const addNameUserUrl;//提交实名认证
UIKIT_EXTERN NSString * const nameUserUrl;//实名认证
UIKIT_EXTERN NSString * const houseUserUrl;//房东认证
UIKIT_EXTERN NSString * const addHouseUserUrl;//提交房东认证

//收货地址
UIKIT_EXTERN NSString * const addressListUrl;//收货地址列表
UIKIT_EXTERN NSString * const addAddressUrl;//添加收货地址
UIKIT_EXTERN NSString * const setDefaultAddressUrl;//设为默认地址
UIKIT_EXTERN NSString * const delAddressUrl;//删除地址
UIKIT_EXTERN NSString * const editAddressUrl;//编辑收货地址
#pragma mark - 优惠券
UIKIT_EXTERN NSString * const couponListUrl;//优惠券列表
UIKIT_EXTERN NSString * const getCouponUrl;//优惠券领取
UIKIT_EXTERN NSString * const myCouponUrl;//我的优惠券
//房东
UIKIT_EXTERN NSString * const fdAddHouseInfoUrl;//获取添加房源信心
UIKIT_EXTERN NSString * const getCityUrl;//根据省获取市
UIKIT_EXTERN NSString * const getAreaUrl;//根据市获取区县
UIKIT_EXTERN NSString * const getStreetUrl;//根据区县获取乡/街道
UIKIT_EXTERN NSString * const fdAddHouseUrl;//添加房源url
UIKIT_EXTERN NSString * const fdHouseListUrl;//房源列表

#pragma mark - 首页
UIKIT_EXTERN NSString * const houseListUrl;
UIKIT_EXTERN NSString * const houseDetailUrl;//房屋详情
UIKIT_EXTERN NSString * const addCollectUrl;//添加收藏
UIKIT_EXTERN NSString * const delCollectUrl;//取消收藏
UIKIT_EXTERN NSString * const  collectListUrl;//收藏列表
UIKIT_EXTERN NSString * const serarchHouseListUrl;//获取搜索房屋列表接口
UIKIT_EXTERN NSString * const cityListUrl;//获取城市列表
UIKIT_EXTERN NSString * const searchCityUrl;//根据文字搜索城市

#pragma mark - 订单接口
UIKIT_EXTERN NSString * const addOrderUrl;//提交订单
UIKIT_EXTERN NSString * const orderPayinfoUrl;//订单支付页面信息
UIKIT_EXTERN NSString * const paySuccessUrl;//支付成功后调用
UIKIT_EXTERN NSString * const orderListUrl;//全部订单
UIKIT_EXTERN NSString * const checkInUrl;//入住中的订单
UIKIT_EXTERN NSString * const quitHouseUrl;//已退房的订单
UIKIT_EXTERN NSString * const canceledOrderUrl;//已取消的订单
UIKIT_EXTERN NSString * const waitToCheckInUrl;//待入住的订单
UIKIT_EXTERN NSString * const cancelOrderUrl;//取消订单
UIKIT_EXTERN NSString * const deleteOrderUrl;//删除订单
UIKIT_EXTERN NSString * const applyTuikuanUrl;//申请退款
UIKIT_EXTERN NSString * const applyBackMoneyUrl;//退钱接口
UIKIT_EXTERN NSString * const applyTuifangInfoUrl;//提前退房页面信息
UIKIT_EXTERN NSString * const applyTuifangUrl;//提前退房
UIKIT_EXTERN NSString * const fdTuifangUrl;//房东是否同意提前退房
UIKIT_EXTERN NSString * const fdTuikuanUrl;//房东是否同意退款

UIKIT_EXTERN NSString * const fdOrderListUrl;//房东全部房源
UIKIT_EXTERN NSString * const fdOrderDairuzhuUrl;//房东待入住订单
UIKIT_EXTERN NSString * const fdOrderRuzhuzhongUrl;//房东入住中订单
UIKIT_EXTERN NSString * const fdOrderShenQingTuikuanUrl;//房东申请退款
UIKIT_EXTERN NSString * const fdOrderTiqianTuikuanUrl;//房东提前退房
UIKIT_EXTERN NSString * const fdOrderYiTuifangUrl;//房东已退房
UIKIT_EXTERN NSString * const fdEnsureEnterHouseUrl;//确认入住
UIKIT_EXTERN NSString * const fdEnsureQuitHouseUrl;//确认退房
UIKIT_EXTERN NSString * const fdEnsureTiqianTuifangUrl;//确认提前退房
UIKIT_EXTERN NSString * const pingjiaHouseUrl;//评价房源
#pragma mark - 消息
UIKIT_EXTERN NSString * const systemMsgUrl;//系统消息
UIKIT_EXTERN NSString * const orderMsgUrl;//订单提示
UIKIT_EXTERN NSString * const rcTokenUrl;//获取融云token
UIKIT_EXTERN NSString * const addChatUrl;//添加聊天列表
UIKIT_EXTERN NSString * const chatListUrl;//聊天列表
#pragma mark - 我的余额
UIKIT_EXTERN NSString * const fdYueUrl;//房东余额
UIKIT_EXTERN NSString * const fdTixianInfoUrl;//提现页面信息
UIKIT_EXTERN NSString * const fdSubTixianUrl;//提现
UIKIT_EXTERN NSString * const fdBankCardListUrl;//银行卡
UIKIT_EXTERN NSString * const fdAddBankCardUrl;//添加银行卡
UIKIT_EXTERN NSString * const fdShouzhiUrl;//房东收支记录
#pragma mark - 房屋评价
UIKIT_EXTERN NSString * const fwPingJiaListUrl;//房屋评价列表
UIKIT_EXTERN NSString * const pingjiahuifuInfoUrl;//评价回复信息页
UIKIT_EXTERN NSString * const pingjiahuifuUrl;//提交回复
UIKIT_EXTERN NSString * const zanHuiFuiUrl;//回复点赞
UIKIT_EXTERN NSString * const cancelZanHuifuUrl;//取消点赞

#pragma mark -- 常用旅客
UIKIT_EXTERN NSString * const lkListUrl;//旅客列表
UIKIT_EXTERN NSString * const addLkUrl;//添加旅客
UIKIT_EXTERN NSString * const editLkUrl;//编辑旅客
UIKIT_EXTERN NSString * const delLkUrl;//删除旅客
UIKIT_EXTERN NSString * const lkInfoUrl;//旅客信息

#pragma mark - 支付接口
UIKIT_EXTERN NSString * const alipayUrl;//支付宝支付订单
UIKIT_EXTERN NSString * const wxPayUrl;//微信支付订单
#pragma mark - 发布文章
UIKIT_EXTERN NSString * const publishArticle;//发布文章


UIKIT_EXTERN NSString * const guider_key;
UIKIT_EXTERN NSString * const userToken;
UIKIT_EXTERN NSString * const localCity;
UIKIT_EXTERN NSString * const userInfoUpdate;//用户是否修改了个人资料
UIKIT_EXTERN NSString * const addressUpdate;//地址是否修改
UIKIT_EXTERN NSString * const collectUpdate;//收藏是否修改
UIKIT_EXTERN NSString * const addLK;//添加旅客

UIKIT_EXTERN NSString * const UMAppKey;
UIKIT_EXTERN NSString * const rcAppKey;
UIKIT_EXTERN NSString * const rcAppSecret;

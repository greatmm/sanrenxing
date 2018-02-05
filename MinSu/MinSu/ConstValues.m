//
//  ConstValues.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/19.
//

#import "ConstValues.h"

NSString * const baseUrl  = @"http://minsu.zyeo.net";

NSString * const authCodeSendUrl = @"/api/user/MobileVerify";

NSString * const authCodeLoginUrl = @"/api/user/register";

NSString * const loginUrl = @"/api/user/logo1";

NSString * const thirdLoginUrl = @"/api/user/logo2";
NSString * const forgetPwdUrl = @"/api/user/wj_pwd";
NSString * const editPwdUrl = @"/api/user/edit_pwd";

NSString * const signInInfoUrl = @"/api/user/sign_html";
NSString * const signInUrl  = @"/api/user/sign";
NSString * const userIndex  = @"/api/user/index";
NSString * const userInfoUrl = @"/api/user/user_info";
NSString * const uploadHeaderPicUrl = @"/api/user/user_head_pic";
NSString * const updateNickNameUrl = @"/api/user/user_nickname";
NSString * const updateEmailUrl = @"/api/user/user_email";
NSString * const updateSexUrl = @"/api/user/user_sex";
NSString * const updateBirthdayUrl = @"/api/user/user_birthday";
NSString * const addNameUserUrl = @"/api/user/add_name_user";
NSString * const nameUserUrl  = @"/api/user/name_user";
NSString * const houseUserUrl = @"/api/user/house_user";
NSString * const addHouseUserUrl = @"/api/user/add_house_user";

NSString * const addressListUrl = @"/api/user/address_list";
NSString * const addAddressUrl  = @"/api/user/add_address";
NSString * const setDefaultAddressUrl = @"/api/user/set_default";
NSString * const delAddressUrl = @"/api/user/del_address";
NSString * const editAddressUrl = @"/api/user/edit_cz_address";
NSString * const aboutUsUrl = @"/api/user/guanyu";
NSString * const feedBackUrl = @"/api/user/user_fankui";

NSString * const fdAddHouseInfoUrl = @"/api/Fangdong/add_house";
NSString * const getCityUrl = @"/api/fangdong/city";
NSString * const getAreaUrl = @"/api/fangdong/district";
NSString * const getStreetUrl = @"/api/fangdong/twon";
NSString * const fdAddHouseUrl = @"/api/Fangdong/add_house_cz";
NSString * const fdHouseListUrl = @"/api/Fangdong/my_house";

NSString * const houseListUrl  = @"/api/index/index";

NSString * const systemMsgUrl = @"/api/Message/system_msg";
NSString * const orderMsgUrl = @"/api/Message/order_msg";
NSString * const houseDetailUrl = @"/api/House/house_detail";
NSString * const addCollectUrl = @"/api/user/add_collect";
NSString * const delCollectUrl = @"/api/user/qx_collect";
NSString * const collectListUrl = @"/api/user/mycollect";
NSString * const couponListUrl = @"/api/quan/quan_list";
NSString * const getCouponUrl  = @"/api/quan/get_quan";
NSString * const myCouponUrl = @"/api/quan/my_quan";
NSString * const serarchHouseListUrl = @"/api/House/index";
NSString * const cityListUrl = @"/api/index/chengshi";
NSString * const searchCityUrl = @"/api/index/cs_sousuo";
NSString * const addOrderUrl = @"/api/order/order_sub";
NSString * const orderPayinfoUrl = @"/api/order/order_zhifu";
NSString * const paySuccessUrl = @"/api/order/zhifu_cg";
NSString * const orderListUrl = @"/api/order/my_order";
NSString * const checkInUrl = @"/api/order/order_rzz";
NSString * const quitHouseUrl = @"/api/order/order_ytf";
NSString * const canceledOrderUrl = @"/api/order/order_yqx";
NSString * const waitToCheckInUrl = @"/api/order/order_drz";
NSString * const cancelOrderUrl = @"/api/order/qx_order";
NSString * const deleteOrderUrl = @"/api/order/del_order";
NSString * const applyTuikuanUrl = @"/api/order/tuikuan_html";
NSString * const applyBackMoneyUrl = @"/api/order/tuikuan_cz";
NSString * const applyTuifangInfoUrl = @"/api/order/tuifang_html";
NSString * const applyTuifangUrl = @"/api/order/tuifang_cz";
NSString * const fdTuifangUrl = @"/api/Fangdong/sub_tqtf";
NSString * const fdTuikuanUrl = @"/api/Fangdong/sub_tuikuan";
NSString * const fdOrderListUrl = @"/api/Fangdong/fd_order";
NSString * const fdOrderDairuzhuUrl = @"/api/Fangdong/fd_order_drz";
NSString * const fdOrderRuzhuzhongUrl = @"/api/Fangdong/fd_order_rzz";
NSString * const fdOrderShenQingTuikuanUrl = @"/api/Fangdong/fd_order_tksq";
NSString * const fdOrderTiqianTuikuanUrl = @"/api/Fangdong/fd_order_tqtf";
NSString * const fdOrderYiTuifangUrl = @"/api/Fangdong/fd_order_ytf";
NSString * const fdEnsureEnterHouseUrl = @"/api/Fangdong/sub_ruzhu";
NSString * const fdEnsureQuitHouseUrl = @"/api/Fangdong/sub_tuifang";
NSString * const fdEnsureTiqianTuifangUrl = @"/api/Fangdong/sub_tqtf";
NSString * const pingjiaHouseUrl = @"/api/order/order_com";
NSString * const addChatUrl = @"/api/Message/add_chat";
NSString * const rcTokenUrl = @"/api/message/get_token";
NSString * const chatListUrl = @"/api/message/chat_msg";
NSString * const fdYueUrl = @"/api/fangdong/my_yue";
NSString * const fdTixianInfoUrl = @"/api/fangdong/tx_html";
NSString * const fdSubTixianUrl = @"/api/fangdong/tx_sub";
NSString * const fdBankCardListUrl = @"/api/fangdong/my_bank";
NSString * const fdAddBankCardUrl = @"/api/fangdong/add_bank";
NSString * const fdShouzhiUrl = @"/api/fangdong/shouzhi";
NSString * const fwPingJiaListUrl = @"/api/house/com_list";
NSString * const pingjiahuifuInfoUrl  = @"/api/house/com_hf_list";
NSString * const pingjiahuifuUrl = @"/api/order/order_com_hf";
NSString * const zanHuiFuiUrl = @"/api/House/house_com_nice";
NSString * const cancelZanHuifuUrl = @"/api/House/house_com_qx_nice";
NSString * const lkListUrl = @"/api/user/lk_list";//旅客列表
NSString * const addLkUrl = @"/api/user/add_lk";//添加旅客
NSString * const editLkUrl  = @"/api/user/edit_lk";//编辑旅客
NSString * const delLkUrl = @"/api/user/del_lk";//删除旅客
NSString * const lkInfoUrl = @"/api/user/edit_lk_html";//旅客信息
NSString * const alipayUrl = @"/api/payment/alipay_payment";
NSString * const wxPayUrl = @"/api/payment/weixin_payment";
NSString * const publishArticle = @"/api/Article/add_article";

NSString * const  localCity  = @"cityName";
NSString * const guider_key = @"guider";
NSString * const userToken = @"token";
NSString * const userInfoUpdate = @"userInfoUpdate";
NSString * const addressUpdate = @"addressUpdate";
NSString * const collectUpdate = @"collect";
NSString * const addLK = @"addLK";

NSString * const UMAppKey = @"5a4f1218b27b0a46d900011e";
//5a4f1218b27b0a46d900011e
NSString * const rcAppKey = @"0vnjpoad0g9vz";
NSString * const rcAppSecret = @"FXZwzOR0jQA";

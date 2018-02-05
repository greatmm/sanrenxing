//
//  KKNetWork.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/21.
//

#import "KKNetWork.h"

@implementation KKNetWork
+ (void)postVideoArticleWithParm:(NSDictionary *)parm videoPath:(NSString *)videoPath SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath]];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/plain",@"text/plain",@"text/javascript",@"text/xml"]];
    
    [manger POST:[NSString stringWithFormat:@"%@%@",baseUrl,publishArticle] parameters:parm constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"article_view.mp4" mimeType:@"mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
+ (void)postImagesArticleWithParm:(NSDictionary *)parm imageArr:(NSArray *)imageArr SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",baseUrl,publishArticle] parameters:parm constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSInteger count = imageArr.count;
        for (int i = 0; i < count; i ++) {
            UIImage * image = imageArr[i];
            NSData *data = UIImagePNGRepresentation(image);
            
            [formData appendPartWithFileData:data name:@"file[]" fileName:[NSString stringWithFormat:@"article_img_%d.png",i + 1] mimeType:@"image/jpg/png/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"上传成功");
        NSLog(@"%@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
+ (void)getWxpayOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,wxPayUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getAlipayOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,alipayUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getLkListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,lkListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addLKWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addLkUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)delLKWithWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,delLkUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)editLKWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,editLkUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)lkInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,lkInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)zanHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,zanHuiFuiUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)cancelZanHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,cancelZanHuifuUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)pingjiaHuifuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,pingjiahuifuUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getPingjiahuifuListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,pingjiahuifuInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHousePingjiaListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fwPingJiaListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getFDShouzhiWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdShouzhiUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addBankCardWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdAddBankCardUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getBankcardListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdBankCardListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getFdTixianInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdTixianInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)submitTixianWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdSubTixianUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getFdYueWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdYueUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getChatListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,chatListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addChatWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addChatUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getRTokenWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,rcTokenUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)pingjiaHouseWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,pingjiaHouseUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)fdAgreeTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdTuifangUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)fdAgreeTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdTuikuanUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)appleyTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,applyTuifangUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)fdEnsureRuzhuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdEnsureEnterHouseUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)fdEnsureTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdEnsureQuitHouseUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)fdEnsureTiqianTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdEnsureTiqianTuifangUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseOrderDairuzhuWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderDairuzhuUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseOrderRuzhuzhongWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderRuzhuzhongUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseOrderShenQingTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderShenQingTuikuanUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseOrderrTiqianTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderTiqianTuikuanUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getHouseOrderYiTuifangWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderYiTuifangUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseOrderListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdOrderListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)applyTuikuanWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,applyBackMoneyUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getTuikuanInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,applyTuikuanUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)applyTuifangInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,applyTuifangInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)deleteOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,deleteOrderUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)cancelOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,cancelOrderUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCanceledOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,canceledOrderUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getQuitedOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,quitHouseUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getWaitToCheckInOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,waitToCheckInUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCheckInOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,checkInUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getOrderListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,orderListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)paySuccessWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,paySuccessUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getOrderPayInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,orderPayinfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addOrderWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addOrderUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)searchCityWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,searchCityUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getCityListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,cityListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getSearchHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,serarchHouseListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)newPwdWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,forgetPwdUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)editPwdWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,editPwdUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getMyCouponWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,myCouponUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCouponWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,getCouponUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCouponListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,couponListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCollectListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,collectListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addCollectWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addCollectUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)delCollectWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,delCollectUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)thirdLoginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,thirdLoginUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHouseDetailWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,houseDetailUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getOrderMsgWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,orderMsgUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getSystemMsgWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,systemMsgUrl] para:nil SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,houseListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getFdHouseListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdHouseListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addHouseWithParm:(NSDictionary *)parm imageArr:(NSArray *)imageArr SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",baseUrl,fdAddHouseUrl] parameters:parm constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSInteger count = imageArr.count;
        for (int i = 0; i < count; i ++) {
            UIImage * image = imageArr[i];
            NSData *data = UIImagePNGRepresentation(image);
           
            [formData appendPartWithFileData:data name:@"house_img[]" fileName:[NSString stringWithFormat:@"house_img_%d.png",i + 1] mimeType:@"image/jpg/png/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"上传成功");
        NSLog(@"%@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}


+ (void)getAreaWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,getAreaUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getStreetWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,getStreetUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getCityWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,getCityUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addHoustInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,fdAddHouseInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getHoustUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,houseUserUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getNameUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,nameUserUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+(void)addNameUserWithParm:(NSDictionary *)para imgS:(NSDictionary *)imgDic SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImagesWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,addNameUserUrl] para:para imgS:imgDic SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addHoustUserWithParm:(NSDictionary *)para imgS:(NSDictionary *)imgDic SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImagesWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,addHouseUserUrl] para:para imgS:imgDic SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)updateBirthdayWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,updateBirthdayUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)updateSexWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,updateSexUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)updateEmailWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,updateEmailUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)updateNickNameWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,updateNickNameUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)feedBackWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,feedBackUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}


+ (void)getAboutUsWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,aboutUsUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)editAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,editAddressUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)deleteAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,delAddressUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)setDefaultAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,setDefaultAddressUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)addAddressWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addAddressUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}



+ (void)getAddressListWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,addressListUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)indexInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,userIndex] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)getUserInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,userInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)signInWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,signInUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}

+ (void)getSignInInfoWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,signInInfoUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            if (successBlock) {
                successBlock(dic);
            }
        }
    } erreorBlock:^(NSError *error) {
        
    } progressBlock:nil];
}

+ (void)loginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,loginUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * data = dic[@"data"];
//            NSString * nickName = data[@"nickname"];
            NSString * token = data[@"token"];
            [UserDefaults saveToken:token];
            
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)sendVerifyWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,authCodeSendUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)dynamicLoginWithParm:(NSDictionary *)parm SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self post:[NSString stringWithFormat:@"%@%@",baseUrl,authCodeLoginUrl] para:parm SuccessBlock:^(NSDictionary *dic) {
        NSString * code = dic[@"code"];
        if (successBlock) {
            successBlock(dic);
        }
        if ((code.integerValue == 200) || (code.integerValue == 210)) {
            NSDictionary * data = dic[@"data"];
//            NSString * nickName = data[@"nickname"];
            NSString * token = data[@"token"];
            [UserDefaults saveToken:token];
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:nil];
}
+ (void)postSingImageArticleWithPara:(NSDictionary *)para img:(UIImage *)img fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImageWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,publishArticle] para:para img:img fileName:fileName SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:^(NSProgress * _Nonnull uploadProgress) {
        
    }];
}
+ (void)uploadAvatarWithPara:(NSDictionary *)para img:(UIImage *)img fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [self postImageWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,uploadHeaderPicUrl] para:para img:img fileName:fileName SuccessBlock:^(NSDictionary *dic) {
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    } progressBlock:^(NSProgress * _Nonnull uploadProgress) {
        
    }];
}
+(void)postImagesWithUrl:(NSString *)url para:(NSDictionary *)para imgS:(NSDictionary *)imgDic SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        for (NSString * imageName in imgDic.allKeys) {
            UIImage * image = imgDic[imageName];
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:imageName fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount];
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"上传成功");
        NSLog(@"%@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
//上传图片
+(void)postImageWithUrl:(NSString *)url para:(NSDictionary *)para img:(UIImage *)img fileName:(NSString *)fileName SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(img);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:uploadProgress.completedUnitCount * 1.0/uploadProgress.totalUnitCount status:@"上传中"];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败%@",error);
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
+ (void)post:(NSString *)url para:(NSDictionary *)para SuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock progressBlock:(void (^)(NSProgress * _Nonnull uploadProgress))progressBlock
{
    url=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", nil];
    NSLog(@"请求的url==%@",url);
    NSLog(@"请求的参数==%@",para);
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求的结果%@",responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
        NSLog(@"%@",error);
    }];
}
@end

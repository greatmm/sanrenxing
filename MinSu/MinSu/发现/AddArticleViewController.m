//
//  AddArticleViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/31.
//

#import "AddArticleViewController.h"
#import "CMInputView.h"
#import "HouseAddImageCollectionViewCell.h"
#import "AddArticleCollectionViewCell.h"
#import "ZLPhotoActionSheet.h"
#import <AVFoundation/AVFoundation.h>
@interface AddArticleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *publishTypeLabel;//发布类型
@property (weak, nonatomic) IBOutlet UILabel *atrTypeLabel;//文章类型
@property (weak, nonatomic) IBOutlet CMInputView *inputView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (nonatomic,assign) NSInteger publishType;
@property (nonatomic,assign) NSInteger atrType;
@property (nonatomic,strong) NSMutableArray * imageArr;
@property (nonatomic,strong) NSString * videoUrl;
@end

@implementation AddArticleViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.inputView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布文章";
    self.inputView.placeholder = @"文章内容...";
    self.inputView.maxNumberOfLines = 4;
    self.imageArr = [NSMutableArray new];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HouseAddImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HouseAddImageCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AddArticleCollectionViewCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishArt)];
    self.navigationItem.rightBarButtonItem.tintColor = k40Color;
}
- (void)publishArt
{
    NSString * atrTitle = self.titleTextField.text;
    if (atrTitle.length == 0) {
        [KKAlert showErrorHint:@"请输入文章标题"];
        return;
    }
    NSMutableDictionary * parm = [NSMutableDictionary new];
    parm[@"token"] = [UserDefaults token];
    parm[@"title"] = atrTitle;
    parm[@"article_type"] = [NSNumber numberWithInteger:self.publishType + 1];
    if (self.atrType == 1) {
        parm[@"img_type"] = @3;
        [self publishVideoWithDic:parm];
    } else {
        if (self.inputView.text.length == 0) {
            [KKAlert showErrorHint:@"请输入文章内容"];
            return;
        }
        parm[@"content"] = self.inputView.text;
        if (self.imageArr.count == 0) {
            [KKAlert showErrorHint:@"请选择图片"];
            return;
        }
        if (self.imageArr.count == 1) {
            parm[@"img_type"] = @1;
            [self pushlishSingleImageWithDic:parm];
        } else {
            parm[@"img_type"] = @2;
            [self publishImagesWithDic:parm];
        }
    }
    KKLog(@"%@",parm);
//    token        是    用户token
//    article_type    int    是    1发现 2游记 3攻略
//    title        是    文章标题
//    content        是    文章内容
//    article_img        是    文章图片
//    article_view        是    视频
//    img_type    int    是    1单图 2多图 3视频
}
- (void)publishVideoWithDic:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"文章发布中"];
    [KKNetWork postVideoArticleWithParm:parm videoPath:[self videoPath] SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"文章发布成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPublish" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"文章发布失败"];
    }];
}
- (void)pushlishSingleImageWithDic:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"文章发布中"];
    [KKNetWork postSingImageArticleWithPara:parm img:self.imageArr.firstObject fileName:@"article_img.png" SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"文章发布成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPublish" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"文章发布失败"];
    }];
}
- (void)publishImagesWithDic:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"文章发布中"];
    [KKNetWork postImagesArticleWithParm:parm imageArr:self.imageArr SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"文章发布成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPublish" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"文章发布失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectPublishType:(id)sender {
    [self.view endEditing:YES];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"选择发布类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * fabuAction = [UIAlertAction actionWithTitle:@"发现" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.publishType == 0) {
            return;
        }
        self.publishType = 0;
        self.publishTypeLabel.text = @"发现";
    }];
    UIAlertAction * youjiAction = [UIAlertAction actionWithTitle:@"游记" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.publishType == 1) {
            return;
        }
        self.publishType = 1;
        self.publishTypeLabel.text = @"游记";
    }];
    UIAlertAction * gonglueAction = [UIAlertAction actionWithTitle:@"攻略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.publishType == 2) {
            return;
        }
        self.publishType = 2;
        self.publishTypeLabel.text = @"攻略";
    }];
    [alertVC addAction:fabuAction];
    [alertVC addAction:youjiAction];
    [alertVC addAction:gonglueAction];
    [alertVC addAction:cancel];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}
- (IBAction)selectArcType:(id)sender {
    [self.view endEditing:YES];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"选择文章类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * tuwenAction = [UIAlertAction actionWithTitle:@"图文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.atrType == 0) {
            return;
        }
        self.atrType = 0;
        self.atrTypeLabel.text = @"图文";
        self.inputView.hidden = NO;
        self.topCons.constant = 10;
        [self.view layoutIfNeeded];
        [self.collectionView reloadData];
    }];
    UIAlertAction * videoAction = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.atrType == 1) {
            return;
        }
        self.atrType = 1;
        self.atrTypeLabel.text = @"视频";
        self.inputView.hidden = YES;
        self.topCons.constant = -90;
        [self.view layoutIfNeeded];
        [self.collectionView reloadData];
    }];
    
    [alertVC addAction:tuwenAction];
    [alertVC addAction:videoAction];
    [alertVC addAction:cancel];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.atrType == 1) {
        return 1;
    }
    if (self.imageArr.count) {
        return self.imageArr.count;
    }
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.atrType == 1) {
        if ([self isVideoExists]) {
            AddArticleCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"AddArticleCollectionViewCell" forIndexPath:indexPath];
            cell.imageView.image = [self getThumbnailImage:[self videoPath]];
            kkWeakSelf
            cell.delBlock = ^{
                [weakSelf removeVieo];
                [weakSelf.collectionView reloadData];
            };
            return cell;
        }
        HouseAddImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseAddImageCollectionViewCell" forIndexPath:indexPath];
        cell.hintLabel.hidden = YES;
        return cell;
    }
    
    if (self.imageArr.count) {
        AddArticleCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"AddArticleCollectionViewCell" forIndexPath:indexPath];
        cell.imageView.image = self.imageArr[indexPath.row];
        kkWeakSelf
        cell.delBlock = ^{
            [weakSelf.imageArr removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        return cell;
    }
    HouseAddImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseAddImageCollectionViewCell" forIndexPath:indexPath];
    cell.hintLabel.hidden = YES;
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth * 1.0/3, ScreenWidth * 1.0/3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (self.atrType == 1) {
        [self selectVieo];
        return;
    }
    if (self.imageArr.count > 9) {
        [KKAlert showErrorHint:@"最多只能添加9张图片"];
        return;
    }
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 9 - self.imageArr.count;
    ac.configuration.maxPreviewCount = 50;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    kkWeakSelf
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf.imageArr addObjectsFromArray:images];
        [weakSelf.collectionView reloadData];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
}
- (void)selectVieo
{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    
    picker.delegate=self;
    picker.allowsEditing=NO;
    picker.videoMaximumDuration = 1.0;//视频最长长度
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
    
    //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
    //这里只选择展示视频
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
    
    picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        [self changeToMp4WithUrl:url outPath:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)changeToMp4WithUrl:(NSURL *)videoUrl outPath:(NSString *)outPath
{
    if ([self isVideoExists]) {
        [self removeVieo];
    }
    [KKAlert showAnimateWithStauts:@"视频读取中"];
    AVURLAsset * urlAsset = [AVURLAsset assetWithURL:videoUrl];
    AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.outputURL = [NSURL fileURLWithPath:[self videoPath]];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
     AVAssetExportSessionStatus status = exportSession.status;
        switch (status){
            
            case AVAssetExportSessionStatusCompleted:
            {
                [KKAlert dismiss];
                [self.collectionView reloadData];
            }
                break;
            default:
            {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"读取视频失败"];
            }
                break;
        }
    }];
}
- (NSString *)videoPath
{
   NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   NSString *filePath = [documentPath stringByAppendingPathComponent:@"upload.mp4"];
    return filePath;
}
- (BOOL)isVideoExists
{
    NSFileManager* manager =[NSFileManager defaultManager];
    return [manager fileExistsAtPath:[self videoPath]];
}
-(UIImage *)getThumbnailImage:(NSString *)videoPath {
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:videoPath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
//    if (videoPath) {
//        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoPath] options:nil];
//        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//        // 设定缩略图的方向
//        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
//        gen.appliesPreferredTrackTransform = YES;
//        // 设置图片的最大size(分辨率)
//        gen.maximumSize = CGSizeMake(300, 169);
//        CMTime time = CMTimeMakeWithSeconds(5.0, 600); //取第5秒，一秒钟600帧
//        NSError *error = nil;
//        CMTime actualTime;
//        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//        if (error) {
//            return nil;
//        }
//        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
//        CGImageRelease(image);
//        return thumb;
//    } else {
//        return nil;
//    }
}
- (void)removeVieo
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self videoPath] error:nil];
}
- (void)dealloc
{
    if ([self isVideoExists]) {
        [self removeVieo];
    }
}
@end

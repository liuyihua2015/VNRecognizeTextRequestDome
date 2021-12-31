//
//  DSFaceViewController.m
//  VisionLearn
//
//  Created by dasen on 2017/7/6.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "DSFaceViewController.h"
#import "DSViewTool.h"
#import "DSDetectData.h"
#import "ResultsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DSFaceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) DSDetectionType detectionType;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *showImageView;
//@property (nonatomic, strong) UIImagePickerController *pickerVc;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DSFaceViewController



- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type
{
    if (self = [super init]) {
        _detectionType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showImageView];
    [self.view addSubview:self.textView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (_detectionType == DSDetectionTypeTextRectangles) {
        
//
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始扫描" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
        
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithTitle:@"开始扫描" style:UIBarButtonItemStylePlain target:self action:@selector(start)],[[UIBarButtonItem alloc]initWithTitle:@"扫描结果" style:UIBarButtonItemStylePlain target:self action:@selector(result)]];
        
    }
    

}


-(void)start {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self p_takePhotoFromPhotoLibrary];
    }];
    
    [alert addAction:action1];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self p_takePhotoFromCamera];

        
    }];
    
    [alert addAction:action2];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action3];
    
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
     

    
    
    
}

-(void)result {
    
    if (self.dataArray.count > 0) {
        ResultsViewController * vc = [[ResultsViewController alloc]init];
        vc.dataArray = self.dataArray;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self start];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
   
    [self detectFace:image];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)detectFace:(UIImage *)image{
    
    UIImage *localImage = [image scaleImage:SCREEN_WIDTH];
    [self.showImageView setImage:localImage];
    self.showImageView.size = localImage.size;
    
    [DSVisionTool detectImageWithType:self.detectionType image:localImage complete:^(DSDetectData * _Nullable detectData, NSArray * _Nullable texts) {
        
        switch (self.detectionType) {
            case DSDetectionTypeFace:
                for (NSValue *rectValue in detectData.faceAllRect) {
                    [self.showImageView addSubview: [DSViewTool getRectViewWithFrame:rectValue.CGRectValue]];
                }
                break;
            case DSDetectionTypeLandmark:
                
                for (DSDetectFaceData *faceData in detectData.facePoints) {
                  self.showImageView.image = [DSViewTool drawImage:self.showImageView.image observation:faceData.observation pointArray:faceData.allPoints];
                }
                break;
            case DSDetectionTypeTextRectangles:
            {
                for (NSValue *rectValue in detectData.textAllRect) {
                    [self.showImageView addSubview: [DSViewTool getRectViewWithFrame:rectValue.CGRectValue]];
                }
                self.dataArray = texts;
                
                NSString * content = [self.dataArray componentsJoinedByString:@"\n"];
                
                self.textView.text = content;
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self result];
//                });
                
            }
                break;
            default:
                break;
        }
        
    }];
}

#pragma mark 懒加载控件
- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, (SCREEN_SIZE.height-64)*0.5)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = [UIColor orangeColor];
    }
    return _showImageView;
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showImageView.frame),SCREEN_SIZE.width, (SCREEN_SIZE.height-64)*0.5)];
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}


- (void)p_takePhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.title  = @"拍照";
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
 
        [self presentViewController:imagePicker animated:YES completion:^{
            imagePicker.delegate = self;
        }];
    }
}

- (void)p_takePhotoFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.title  = @"选择照片";
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePicker animated:YES completion:^{
            imagePicker.delegate = self;
        }];
    }
}

@end

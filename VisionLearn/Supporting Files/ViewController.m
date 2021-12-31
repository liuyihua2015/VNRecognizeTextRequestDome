//
//  ViewController.m
//  VisionLearn
//
//  Created by dasen on 2017/6/16.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "ViewController.h"
#import "VisionViewController.h"
#import "DSFaceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)enterDemo{
    
//    VisionViewController *vc = [[VisionViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    DSFaceViewController *vc = [[DSFaceViewController alloc]initWithDetectionType:DSDetectionTypeTextRectangles];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

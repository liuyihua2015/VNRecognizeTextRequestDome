//
//  ResultsViewController.m
//  VisionLearn
//
//  Created by liuyihua on 2021/12/28.
//  Copyright © 2021 Dasen. All rights reserved.
//

#import "ResultsViewController.h"
#import "DSFaceViewController.h"
#import "DSVisionTool.h"
#import "CameraCaptureController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end

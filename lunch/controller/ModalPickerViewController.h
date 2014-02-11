//
//  ModalPickerViewController.h
//  lunch
//
//  Created by u1 on 2014/02/11.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModalPickerViewController;

@protocol ModalPickerViewControllerDelegate

- (void)didOkButtonClicked:(ModalPickerViewController *)controller
                       tag:(NSString *)tag;

- (void)didCancelButtonClicked:(ModalPickerViewController *)controller
                           tag:(NSString *)tag;

@end

@interface ModalPickerViewController : UIViewController

@property (nonatomic, assign) id<ModalPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> delegate;
@property (nonatomic, strong) NSString *tag;

@end
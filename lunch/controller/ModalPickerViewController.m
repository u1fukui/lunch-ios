//
//  ModalPickerViewController.m
//  lunch
//
//  Created by u1 on 2014/02/11.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "ModalPickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ModalPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) NSString *selectedData;

@end

@implementation ModalPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customButton:self.cancelButton];
    [self customButton:self.okButton];
    
    [self.cancelButton addTarget:self
                          action:@selector(onClickButton:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.okButton addTarget:self
                      action:@selector(onClickButton:)
            forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerView.delegate = self.delegate;
    self.pickerView.dataSource = self.delegate;
    [self.pickerView selectRow:[self.delegate initialPickerRow]
                   inComponent:0
                      animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customButton:(UIButton *)button
{
    [[button layer] setBorderColor:[button.titleLabel.textColor CGColor]];
    [[button layer] setBorderWidth:1.0];
    [[button layer] setCornerRadius:4.0];
    [button setClipsToBounds:YES];
}

- (void)onClickButton:(UIButton *)button
{
    if (button == self.cancelButton) {
        [self.delegate didCancelButtonClicked:self tag:self.tag];
    } else if (button == self.okButton) {
        [self.delegate didOkButtonClicked:self tag:self.tag];
    }
}

@end

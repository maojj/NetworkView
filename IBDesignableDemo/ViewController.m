//
//  ViewController.m
//  IBDesignableDemo
//
//  Created by maojj on 4/20/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import "ViewController.h"
#import "TTNetworkView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TTNetworkView *networkView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _networkView.strokeColor = [UIColor blueColor];
    _networkView.strengh = 0;
    _networkView.fillColor = [UIColor greenColor];

    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}

- (void)refresh {
    static BOOL isAdd;
    isAdd = !isAdd;
    CGFloat str = _networkView.strengh;
    str += 0.1;
    str = ((NSInteger)(str * 100) % 100 ) / 100.f;
    _networkView.strengh = str;
    CGRect rect = self.view.bounds;
    rect.size.width *= str;
    rect.size.height *= str;
    _networkView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

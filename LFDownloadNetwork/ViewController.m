//
//  ViewController.m
//  NSURLSession
//
//  Created by 刘峰 on 2019/4/25.
//  Copyright © 2019年 Liufeng. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LFDownloadNetwork.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) BOOL isPause;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isPause = NO;
    self.filePath = @"https://pic.ibaotu.com/00/48/71/79a888piCk9g.mp4";
}

#pragma mark - Private
//传入本地url 进行视频播放
-(void)paly:(NSURL*)playUrl{
    
    //系统的视频播放器
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    //播放器的播放类
    AVPlayer * player = [[AVPlayer alloc]initWithURL:playUrl];
    controller.player = player;
    //自动开始播放
    [controller.player play];
    //推出视屏播放器
    [self  presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIButton's response
//开始下载
- (IBAction)beginDownload:(id)sender {
    _isPause = NO;
    __weak typeof(self) weakSelf = self;
    [[LFDownloadNetwork shareManager] downloadWithUrl:self.filePath progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress];
        });
    } success:^(NSURL * _Nonnull url) {
        NSLog(@"下载完成 = %@", url.absoluteString);
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"error = %@", error.localizedDescription);
    }];
}

//暂停或继续
- (IBAction)pauseOrContinue:(id)sender {
    if (!_isPause) {//暂停
        [[LFDownloadNetwork shareManager] pauseDownloadWithUrl:self.filePath];
    } else {//继续
        [[LFDownloadNetwork shareManager] continueDownloadWithUrl:self.filePath];
    }
    _isPause = !_isPause;
}

//断点续传
- (IBAction)breakContinue:(id)sender {
    [[LFDownloadNetwork shareManager] continueDownloadWithUrl:self.filePath];
}

//取消下载
- (IBAction)cancelDownload:(id)sender {
    [[LFDownloadNetwork shareManager] cancelDownloadWithUrl:self.filePath];
    self.progressLabel.text = @"0.00%";
}

#pragma mark - Getters


@end

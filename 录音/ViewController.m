//
//  ViewController.m
//  录音
//
//  Created by 吴胜杰 on 16/3/15.
//  Copyright © 2016年 DPSoftwareDevelopmentCompany. All rights reserved.
//

/*
 录音 类
 AVAudioRecorder《输入音频》
 
  <1>AVNumberOfChannelsKey《通道数》
  <2>AVSampleRateKey 《采样率》44100
  <3>AVLinearPCMBitDepthKey 《比特率》16  32
  <4>AVEncoderAudioQualityKey 质量
  <5>AVEncoderBitRateKey 《比特采样率》12800
 
 
 */


#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioRecorderDelegate>
{
    AVAudioRecorder *audioRecoder;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录音";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"TICK" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor brownColor];
    [button addTarget:self action:@selector(audioRecoder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    
    
}


- (void)audioRecoder:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected !=YES) {
        
        [audioRecoder stop];
        return;
    }
    
    /*
     URL 是一个本地的URL 
     AVAudioRecorder 需要一个 存储的路经
     
     
     */
    
    NSString *name = [NSString stringWithFormat:@"%d.aiff",(int)[NSDate date].timeIntervalSince1970];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
    NSError *error;
    // 录音 初始化
    audioRecoder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:@{AVNumberOfChannelsKey:@2,AVSampleRateKey:@44100,AVLinearPCMBitDepthKey:@32,AVEncoderAudioQualityKey:@(AVAudioQualityMax),AVEncoderBitRateKey:@128000} error:&error];
    /*
     AVNumberOfChannelsKey:@2 通道数 一般都是双声道
     AVSampleRateKey:@44100 采样率 HZ 通常设置成44.1k
     AVLinearPCMBitDepthKey:@32 比特率 分为 8 16 24 32
     AVEncoderAudioQualityKey:@(AVAudioQualityMax) 声音的质量 是一个枚举
     {AVAudioQualityMin 最小的质量
     AVAudioQualityLow  比较低的质量
     AVAudioQualityMedium 中间的质量
     AVAudioQualityHigh   高的质量
     AVAudioQualityMax    最好的质量}
     
     
AVEncoderBitRateKey:@128000 音频编码的比特率 BPS 传输的速率
     
     */
    audioRecoder.delegate = self;
// 开始录音
    [audioRecoder prepareToRecord];// 预录音
    [audioRecoder record];
    
    NSLog(@"%@",path);
    
    
    
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
    NSLog(@"录音结束");
//     文件操作类
    NSFileManager *manager = [NSFileManager defaultManager];
//    获得当前文件的所有 子文件subpathsAtPath ：
     NSArray *pathList = [manager subpathsAtPath:path];
//     只获得录音文件
    NSMutableArray *audioPathList = [NSMutableArray array];
//     遍历所有文件夹下面的子文件
    for (NSString *audioPath in pathList) {
//         通过文件的延展名（扩展名。尾缀 ）来区分是不是录音文件
        if ([audioPath.pathExtension isEqualToString:@"aiff"]) {
//            把 筛选出来的文件放到数组中
            [audioPathList addObject:audioPath];
            
        }
        
        
    }
    
    
    NSLog(@"%@",audioPathList);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

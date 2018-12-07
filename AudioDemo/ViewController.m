//
//  ViewController.m
//  AudioDemo
//
//  Created by yogurts on 2018/11/29.
//  Copyright © 2018 yogurts. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>

@interface ViewController () <AVAudioRecorderDelegate>

/** 音频会话 */
@property (nonatomic, strong) AVAudioSession *audioSession;

/** 音频录音对象 */
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

/** 音频播放器 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - record

- (IBAction)record:(UIButton *)button {
    if (!self.audioRecorder.isRecording) {
        [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [self.audioSession setActive:YES error:nil];
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder peakPowerForChannel:0.0];
        [self.audioRecorder record];
    }
}

- (IBAction)stopRecord:(UIButton *)button {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
        [self.audioSession setActive:NO error:nil];
    }
}


#pragma mark - play

- (IBAction)play:(UIButton *)button {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.volume = 1.f;
        NSLog(@"录音时长 = %lf", self.audioPlayer.duration);
        [self.audioPlayer play];
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.audioSession setActive:YES error:nil];
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.volume = 1.f;
        [self.audioPlayer play];
    }
}

- (IBAction)stopPlay:(UIButton *)button {
    [self.audioPlayer stop];
    [self.audioSession setActive:NO error:nil];
}

#pragma mark - lazy load

- (AVAudioSession *)audioSession {
    if (!_audioSession) {
        _audioSession = [AVAudioSession sharedInstance];
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    return _audioSession;
}

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        //对AVAudioRecorder进行一些设置
        NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                                       [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                       [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                       [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey, nil];
        
        //录音存放的地址文件
        NSURL *recordingUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"myRecord.wav"]];
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordingUrl settings:recordSettings error:nil];
        //对录音开启音量检测
        _audioRecorder.meteringEnabled = YES;
        //设置代理
        _audioRecorder.delegate = self;
    }
    return _audioRecorder;
}

- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSURL *recordingUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"myRecord.wav"]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingUrl error:nil];
    }
    return _audioPlayer;
}


@end

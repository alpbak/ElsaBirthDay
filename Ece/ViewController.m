//
//  ViewController.m
//  Ece
//
//  Created by Alpaslan Bak on 3.03.2019.
//  Copyright © 2019 Alpaslan Bak. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *elsaImageView;
@property (nonatomic)NSInteger imageNo;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageNo = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLabel:)
                                                 name:@"handleLabel" object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *changeImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageGesture:)];
    changeImageGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:changeImageGesture];
    
    [self handleImage];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self playHappyBirthDay];
    }
}

- (void)handleImageGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"IMAGE");
        [self handleImage];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)handleLabel:(NSNotification *)note {
    [self handleEcesBirthDay];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake){
        [self playHappyBirthDay];
    }
}

- (void)playHappyBirthDay{    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"hb" ofType:@"mp3"];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:mp3Path] options:nil];
    AVPlayerItem *_playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _player && [keyPath isEqualToString:@"status"]){
        if (_player.status == AVPlayerStatusFailed)
            NSLog(@"AVPlayer Status Failed");
        else if (_player.status == AVPlayerStatusReadyToPlay){
            [_player play];
        }
        else if (_player.status == AVPlayerItemStatusUnknown)
            NSLog(@"AVPlayer Status Unknown");
    }
}

- (void)handleEcesBirthDay{
    NSTimeInterval todaysDiff = [[NSDate date] timeIntervalSinceNow];
    NSTimeInterval futureDiff = [[self dateWithYear:2020 month:3 day:22] timeIntervalSinceNow];
    NSTimeInterval dateDiff = futureDiff - todaysDiff;
    
    div_t r1 = div(dateDiff, 60*60*24);
    NSInteger theDays = r1.quot;
    
    _daysLabel.text = [NSString stringWithFormat:@"%li", (long)theDays];
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

- (void)handleImage{
    _imageNo++;
    NSString *imgStr = [NSString stringWithFormat:@"%ld.png", (long)_imageNo];
    [_elsaImageView setImage:[UIImage imageNamed:imgStr]];
    
    if (_imageNo == 11) {
        _imageNo = 0;
    }
    
    
}
@end

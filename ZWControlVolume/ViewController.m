//
//  ViewController.m
//  ZWControlVolume
//
//  Created by 崔先生的MacBook Pro on 2022/9/12.
//

#import "ViewController.h"
#import "MediaPlayer/MPVolumeView.h"
#import "AVFAudio/AVFAudio.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *brightLabel;
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UISlider *brightSlider;

@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, assign) CGFloat systemVolume;
@property (nonatomic, assign) CGFloat systemBright;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"音量与亮度调节";
    //设置导航栏字体的大小与颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 19], NSForegroundColorAttributeName:[UIColor redColor]}];
    
    /*获取系统音量,范围是0-1*/
    _audioSession = [AVAudioSession sharedInstance];
    _systemVolume = _audioSession.outputVolume;
    _systemBright = [UIScreen mainScreen].brightness;
    NSLog(@"volume = %f  bright = %f", _systemVolume, _systemBright);
    
    [self initview];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void *)[AVAudioSession sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setVolumeAndBright) name:@"enterControllerView" object:nil];
}

- (void)dealloc {
    [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterControllerView" object:nil];
}

- (void)initview {
    [self.view addSubview:self.volumeLabel];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.volumeView];
    [self.view addSubview:self.brightLabel];
    [self.view addSubview:self.brightSlider];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(context == (__bridge void *)[AVAudioSession sharedInstance]){
        //改变后的值
        float newValue = [[change objectForKey:@"new"] floatValue];
        //改变前的值
        float oldValue = [[change objectForKey:@"old"] floatValue];
        // TODO: 这里实现你的逻辑代码
        NSLog(@"new = %f", newValue);
        NSLog(@"old = %f", oldValue);
        
        [self.slider setValue:newValue animated:YES];
    }
}

/// APP重新进入前台后查询当前的音量与亮度
- (void)setVolumeAndBright {
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void *)[AVAudioSession sharedInstance]];
    _audioSession = [AVAudioSession sharedInstance];
    _systemVolume = _audioSession.outputVolume;
    _systemBright = [UIScreen mainScreen].brightness;
    [self.slider setValue:_systemVolume animated:YES];
    _brightSlider.value = _systemBright;
    NSLog(@"volume = %f  bright = %f", _systemVolume, _systemBright);
}

- (UILabel *)volumeLabel {
    if (!_volumeView) {
        _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95, 20)];
        _volumeLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        _volumeLabel.text = @"音量🔊调节";
    }
    return _volumeLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
        _slider.center = self.view.center;
        _slider.value = _systemVolume;
        _slider.minimumTrackTintColor = [UIColor orangeColor];
        [_slider addTarget:self action:@selector(changeVolume) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void)changeVolume {
    [self.volumeSlider setValue:_slider.value animated:YES];
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, 0, 10, 10)];
        //隐藏音量框不能设置hidden,否则无法隐藏音量框,只需设置frame即可
//        _volumeView.hidden = YES;无效
    }
    return _volumeView;
}

- (UILabel *)brightLabel {
    if (!_brightLabel) {
        _brightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        _brightLabel.center = CGPointMake(self.view.center.x, _slider.center.y + 50);
        _brightLabel.text = @"亮度调节";
    }
    return _brightLabel;
}

- (UISlider *)brightSlider {
    if (!_brightSlider) {
        _brightSlider = [[UISlider alloc] initWithFrame:CGRectMake(_slider.frame.origin.x, _brightLabel.frame.origin.y + 50, 250, 20)];
        _brightSlider.minimumTrackTintColor = [UIColor purpleColor];
        [_brightSlider addTarget:self action:@selector(changeBright) forControlEvents:UIControlEventValueChanged];
        _brightSlider.value = _systemBright;
    }
    return _brightSlider;
}

- (void)changeBright {
    [UIScreen mainScreen].brightness = _brightSlider.value;
}

/*
 * 遍历控件，拿到UISlider
 */
- (UISlider *)volumeSlider {
    UISlider* volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            break;
        }
    }
    return volumeSlider;
}

@end

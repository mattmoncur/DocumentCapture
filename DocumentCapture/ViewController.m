//
//  ViewController.m
//  DocumentCapture
//
//  Created by Matt Moncur on 2016-12-31.
//  Copyright © 2016 Matt Moncur. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController () {
    AVCaptureSession *session;
    int count;
}

@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCapturingTapped:(UIButton *)sender {
    [self setupImageCaptureDevice];
}

- (IBAction)stopCapturingTapped:(UIButton *)sender {
    [session stopRunning];
    self.videoPreviewView.layer.sublayers = nil;
//    NSLog(@"%lu",(unsigned long)outputs.count);
//    [session removeOutput:session.outputs[0]];
}

- (IBAction)defaultConfig:(UIButton *)sender {
    switch (count) {
        case 0:
            session.sessionPreset = AVCaptureSessionPresetPhoto;
            sender.titleLabel.text = @"Photo";
            break;
        case 1:
            session.sessionPreset = AVCaptureSessionPresetLow;
            sender.titleLabel.text = @"Low";
            break;
        case 2:
            session.sessionPreset = AVCaptureSessionPresetMedium;
            sender.titleLabel.text = @"Medium";
            break;
        case 3:
            session.sessionPreset = AVCaptureSessionPresetHigh;
            sender.titleLabel.text = @"High";
            break;
        default:
            count = 0;
            session.sessionPreset = AVCaptureSessionPresetPhoto;
            sender.titleLabel.text = @"Photo";
            break;
    }
    count ++;
}

- (void)setupImageCaptureDevice {
    
    session = [AVCaptureSession new];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    NSArray *deviceTypes = [NSArray arrayWithObject:AVCaptureDeviceTypeBuiltInWideAngleCamera];
    AVCaptureDeviceDiscoverySession *discovery = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes
                                                           mediaType:AVMediaTypeVideo
                                                            position:AVCaptureDevicePositionBack];
    
    NSArray *devices = discovery.devices;
    
    
    if (devices.count <= 0 && authStatus != AVAuthorizationStatusDenied && authStatus != AVAuthorizationStatusRestricted) {
        NSLog(@"No devices found");
        return;
    }
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                //proceed
            } else {
                //Throw error or sum sum
            }
        }];
    }
    
    
    AVCaptureDevice *device = devices[0];
    NSLog(@"%@", device.localizedName);
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];

    //Add device input to Capture Session
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    //Create Preview Layer for Capture Session and add as sublayer
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.frame = self.videoPreviewView.bounds;
    [self.videoPreviewView.layer addSublayer:previewLayer];
    

    
    [session startRunning];
    
}


@end

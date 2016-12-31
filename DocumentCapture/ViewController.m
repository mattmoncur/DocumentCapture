//
//  ViewController.m
//  DocumentCapture
//
//  Created by Matt Moncur on 2016-12-31.
//  Copyright © 2016 Matt Moncur. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

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

- (IBAction)startCapturingTapped:(UIButton *)sender {
    [self setupImageCaptureDevice];
}


- (void)setupImageCaptureDevice {
    
    AVCaptureSession *session = [AVCaptureSession new];
    
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
    previewLayer.frame = self.backgroundView.bounds;
    [self.backgroundView.layer addSublayer:previewLayer];
    
    [session startRunning];
    
}


@end

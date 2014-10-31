//
//  ViewController.m
//  Keyboard
//
//  Created by Aurelius Prochazka on 10/31/14.
//  Copyright (c) 2014 Hear For Yourself. All rights reserved.
//

#import "ViewController.h"

#import "AKFoundation.h"
#import "ToneGenerator.h"
#import "EffectsProcessor.h"

@interface ViewController () {
    ToneGenerator *toneGenerator;
    EffectsProcessor *fx;
    NSMutableDictionary *currentNotes;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AKOrchestra *orch = [[AKOrchestra alloc] init];
    toneGenerator = [[ToneGenerator alloc] init];
    fx = [[EffectsProcessor alloc] initWithAudioSource:toneGenerator.auxilliaryOutput];
    currentNotes = [NSMutableDictionary dictionary];
    [orch addInstrument:toneGenerator];
    [orch addInstrument:fx];
    [[AKManager sharedAKManager] runOrchestra:orch];
    [fx play];
}

- (IBAction)keyPressed:(id)sender {
    NSArray *frequencies = @[@440, @466.16, @493.88, @523.25, @554.37, @587.33, @622.25, @659.26, @698.46, @739.99, @783.99, @830.61, @880];
    NSInteger index = [(UILabel *)sender tag];
    float frequency = [[frequencies objectAtIndex:index] floatValue];
    
    ToneGeneratorNote *note = [[ToneGeneratorNote alloc] initWithFrequency:frequency];
    [toneGenerator playNote:note];
    [currentNotes setObject:note forKey:[NSNumber numberWithInt:(int)index]];
}

- (IBAction)keyReleased:(id)sender {
    NSInteger index = [(UILabel *)sender tag];
    ToneGeneratorNote *noteToStop = [currentNotes objectForKey:[NSNumber numberWithInt:(int)index]];
    [noteToStop stop];
    [currentNotes removeObjectForKey:sender];
}



- (IBAction)reverbSliderValueChanged:(id)sender {
    fx.reverb.value = [(UISlider *)sender value];
    NSLog(@"%g", fx.reverb.value);
}

- (IBAction)volumeSliderValueChanged:(id)sender {
    toneGenerator.volume.value = [(UISlider *)sender value];
}

@end
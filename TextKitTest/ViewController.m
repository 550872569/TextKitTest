//
//  ViewController.m
//  TextKitTest
//
//  Created by Manjit Bedi on 2013-07-18.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSCharacterSet *characterSet;
@property NSUInteger sentenceLength;
@property NSRange currentWordRange;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    _currentWordRange.length = 4;
    _currentWordRange.location = 0;
    _sentenceLength = [_textView.text length];
    
    NSLog(@"length of sentence %lu", (unsigned long)_sentenceLength);
    
    [self highLightWord];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void) timerFireMethod:(NSTimer *) timer {
    
    [self unhighlightWord];
    [self advanceToNextWord];
    [self highLightWord];
}

- (void) advanceToNextWord {
    
    // TODO: deal with if the white space is more than one character
    
    NSUInteger position = _currentWordRange.location + _currentWordRange.length;
    
    if(position < _sentenceLength) {
     
        // get the range of the next word
       
        // scan for white space
        NSRange searchRange;
        NSUInteger startOfNextWord;
        NSUInteger lengthOfNextWord;
        
        searchRange.length = _sentenceLength - (_currentWordRange.length + _currentWordRange.location + 1);
        NSUInteger temp = _currentWordRange.length + _currentWordRange.location;
        
        if(temp + searchRange.length <= _sentenceLength)
            searchRange.location = temp + 1;
        else
            searchRange.location = temp;
        
        NSLog(@"search range %@, sum %lu", NSStringFromRange(searchRange), searchRange.location + searchRange.length);

        // get the location of the next word
        NSRange newRange = [_textView.text rangeOfCharacterFromSet:_characterSet options:NSLiteralSearch range:searchRange];
        
        // the start of the new word is the current word's end position plus the white space plus 1
        if(newRange.location != NSNotFound) {
            NSLog(@"new range %@", NSStringFromRange(newRange));
            startOfNextWord = _currentWordRange.length + _currentWordRange.location + 1;
            lengthOfNextWord = newRange.location - (1 + _currentWordRange.length + _currentWordRange.location);
            
            _currentWordRange.location = startOfNextWord;
            _currentWordRange.length = lengthOfNextWord;
        } else {
            // We have encountered the end of the string - get the position of the last word in the sentence.
            // This may not be perfect but that is ok for the purpose of this test.
            _currentWordRange.location = _currentWordRange.location + _currentWordRange.length;
            _currentWordRange.length = _sentenceLength - _currentWordRange.location;
            [self.timer invalidate];
        }
    } else {
        [self.timer invalidate];
    }
}


- (void) unhighlightWord {
    
    [_textView.textStorage beginEditing];
    NSDictionary *attrsDictionary = @{ NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [_textView.textStorage addAttributes:attrsDictionary range:_currentWordRange];
    [_textView.textStorage endEditing];
}


- (void) highLightWord {

    NSLog(@"current word range %@", NSStringFromRange(_currentWordRange));
    [_textView.textStorage beginEditing];
    NSDictionary *attrsDictionary = @{ NSForegroundColorAttributeName: [UIColor redColor]};
    [_textView.textStorage addAttributes:attrsDictionary range:_currentWordRange];
    [_textView.textStorage endEditing];
}

@end

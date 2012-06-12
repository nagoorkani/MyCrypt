//
//  MyCryptViewController.m
//  MyCrypt
//
//  Created by Nagoor.KaniS on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCryptViewController.h"

@implementation MyCryptViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//*********

-(IBAction)encryptButton{

    NSString * _key = @"test123";
    NSString * encryptValue = [self getEncryptFile:_key];
    
}

-(IBAction)decryptButton{
    
    NSString * _key = @"test123";
    NSString * decryptValue = [self getDecryptFile:_key];
    
}


//------ Encrypt char
- (NSString*) getEncryptChar:(NSString *)key
{
    
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero( keyPtr, sizeof(keyPtr) ); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char *dataIn = "This is your data";
    char dataOut[500];// set it acc ur data
    bzero(dataOut, sizeof(dataOut));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,  keyPtr,kCCKeySizeAES256, NULL, dataIn, strlen(dataIn), dataOut, sizeof(dataOut), &numBytesEncrypted);    
    
    
    NSData *output_encrypt = [NSData dataWithBytesNoCopy:result length:numBytesEncrypted];    
    
    
    if (result == kCCSuccess) {
        
        NSLog(@"Encrypted value: %s", dataOut);

    }
    
    free(result); //free the buffer;
    return nil;
    
}


- (NSString*) getEncryptFile:(NSString *)key
{
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"txt"];
    NSData *dataIn = [NSData dataWithContentsOfFile:path1];
    
//    NSLog(@"Source file path: %@", path1 );
    
    if ( path1 == NULL ) {
        NSLog(@"No file found...!");
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [dataIn length];
    NSLog(@"Data length: %i", dataLength);

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *dataOut = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    char iv[32];
    for (int i = 0; i < 32; i++) {
        iv[i] = 0;
    }
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr,kCCKeySizeAES128, NULL, [dataIn bytes], dataLength, dataOut, bufferSize, &numBytesEncrypted);    
    
    
    NSData *output_encrypt = [NSData dataWithBytesNoCopy:dataOut length:numBytesEncrypted];    

    if (result == kCCSuccess && numBytesEncrypted != 0) {
        
        NSString * docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString * path = [docsDir stringByAppendingPathComponent:@"index_enc.txt"];
        
        [output_encrypt writeToFile:path atomically:YES];

        NSLog(@"Encrypt bytes: %lu", numBytesEncrypted);        
        NSLog(@"Encrypt is done! in path: %@", path);
        
    }
    
    free(result); //free the buffer;
    return nil;
    
}



- (NSString*) getDecryptFile:(NSString *)key
{
    
    NSString * docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString * inputPath = [docsDir stringByAppendingPathComponent:@"index_enc.txt"];   
    NSData *dataIn = [NSData dataWithContentsOfFile:inputPath];
    
    //    NSLog(@"Source file path: %@", path1 );
    
    if ( inputPath == NULL ) {
        NSLog(@"No file found...!");
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [dataIn length];
    NSLog(@"Data length: %i", dataLength);
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *dataOut = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    char iv[32];
    for (int i = 0; i < 32; i++) {
        iv[i] = 0;
    }
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr,kCCKeySizeAES128, NULL, [dataIn bytes], dataLength, dataOut, bufferSize, &numBytesEncrypted);    
    
    
    NSData *output_encrypt = [NSData dataWithBytesNoCopy:dataOut length:numBytesEncrypted];    
    
    if (result == kCCSuccess && numBytesEncrypted != 0) {
        
        NSString * docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString * outPath = [docsDir stringByAppendingPathComponent:@"index_des.txt"];
        
        [output_encrypt writeToFile:outPath atomically:YES];
        
        NSLog(@"Encrypt bytes: %lu", numBytesEncrypted);        
        NSLog(@"Encrypt is done! in path: %@", outPath);
        
    }
    
    free(result); //free the buffer;
    return nil;
    
}


@end

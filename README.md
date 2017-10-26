Purpose
--------------

CryptoCoding is a superset of the NSCoding protocol that allows for simple, seamless encryption of any NSCoding-compatible object.

CryptoCoding is designed to work with the AutoCoding library (https://github.com/nicklockwood/AutoCoding), which can automatically write the `initWithCoder:` and `encodeWithCoder:` methods for your classes.

CryptoCoding is also designed to work hand-in-hand with the BaseModel library (https://github.com/nicklockwood/BaseModel) which forms the basis for building a powerful model hierarchy for your project with minimal effort. Check the *CryptoTodoList* example included in the BaseModel repository for an example of how these libraries can work together.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 11.0 / Mac OS 10.12 (Xcode 9.0)
* Earliest supported deployment target - iOS 9.0 / Mac OS 10.10
* Earliest compatible deployment target - iOS 4.0 / Mac OS 10.7

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

As of version 1.0.2, CryptoCoding requires ARC. If you wish to use CryptoCoding in a non-ARC project, just add the -fobjc-arc compiler flag to the CryptoCoding.m file. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click CryptoCoding.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to CryptoCoding, comment out the #error line in CryptoCoding.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including CryptoCoding.m) are checked.


Thread Safety
--------------

CryptoCoding is fully thread-safe.


Installation
--------------

To use CryptoCoding, just drag the CryptoCoding class files into your project and add the Apple Security framework.


Usage
--------------

The simplest way to use CryptoCoding is as follows:

1) Add NSCoding to your classes as normal, either by manually adding the `initWithCoder:` and `encodeWithCoder:` methods manually, or by using the AutoCoding library (https://github.com/nicklockwood/AutoCoding) to add NSCoding support automatically.

2) Implement the CryptoCoding protocol for the root object in your object graph (the one that will be saved/loaded from a file). This protocol consists of a single method, `CCPassword` that returns the password used to encrypt and decrypt the arhive. The password can be hard-coded, or retrieved from user input or the Keychain.

3) Save the root object using the `archiveRootObject:toFile:` method of the CryptoCoder class. You can then load the object later using the `unarchiveObjectWithFile:` method.


CryptoCoding classes
-----------------------------

CryptoCoding provides the following class interfaces:

* A category on NSData for AES encrypting/decrypting raw data
* CryptoArchive - an NSCodable class for encrypting objects
* CryptoCoder - an NSKeyedArchiver/Unarchiver replacement for encrypted object serialisation and deserialisation


NSData (CryptoCoding) methods
-------------------------------

The CryptoCoding category extends NSData with the following methods:

    - (NSData *)AESEncryptedDataWithPassword:(NSString *)password IV:(NSData **)IV salt:(NSData **)salt error:(NSError **)error version:(float)version;
    
This method takes a password and returns an encrypted copy of the data using the AES128 algorithm. Note the IV (Initialization Vector) and salt arguments. These arguments are pointers to values that will be returned by the method. It is important to preserve the salt and IV values as you will need them to decrypt the data later. Only the password is secret - the salt and IV values can be stored in cleartext along with the encrypted data. Pass 0 for the version parameter to use the default encryption version. If you need to provide legacy support, use 1.0.
    
    - (NSData *)AESDecryptedDataWithPassword:(NSString *)password IV:(NSData *)IV salt:(NSData *)salt error:(NSError **)error version:(float)version;
    
This method takes a password, salt and IV value and returns an unencrypted copy of the data. The password, salt and IV must all match those used to originally create the data. The version value should match the version used to encrypt the data originally (either 1.0 or 2.0).


CryptoArchive methods
-----------------------

The CryptoArchive class is used to wrap the encrypted data along with the salt and IV values and some other useful information. You will not normally need to use this class directly unless you wish to encode and object that does not conform to the CryptoCoding protocol.

    - (id)initWithRootObject:(id)rootObject password:(NSString *)password;
    
This creates a new CryptoArchive from an NSCodable object and a password. Unlike the CryptoCoder methods, the object being encoded is not required to conform to the CryptoCoding protocol (although it does still need to conform to NSCoding). This may be useful if you wish to encode a generic collection object such as an NSArray or NSDictionary.

    - (id)unarchiveRootObjectWithPassword:(NSString *)password;
    
This decodes the original object from a CryptoArchive and returns it. CryptoArchives are versioned. If the inetegr part of the archive version is greater than the `CryptoCodingVersion` of the currently installed version of the library, the decryption process will fail and the method will return nil. The same applies if the password doesn't match the one used to create the archive.


CryptoCoder methods
-----------------------------

CryptoCoder implements the following methods, which mirror those of the NSKeyedArchiver and NSKeyedUnarchiver classes. Note that all of CryptoCoder's methods are static - you do not need to instantiate the CryptoCoder class.

    + (id)unarchiveObjectWithData:(NSData *)data;
    
This method decodes a CryptoCoded data object and unarchives the stored object. The password to decrypt the file will be retrieved by calling the `CCPassword` method on the class contained in the file. If the class doesn't implement this method, or the value returned doesn't match the password used to decrypt the file, the unarchiving process will fail. If the archive is not encrypted then the unencrypted object will be silently returned, so this method can be used to load either encrypted or unencrypted archives seamlessly.
    
    + (id)unarchiveObjectWithFile:(NSString *)path;
    
As above, except that this method takes a path to a serialised data file instead of a raw NSData object.
    
    + (NSData *)archivedDataWithRootObject:(id)rootObject;
    
This method archives the rootObject using the NSCoding protocol, and then encrypts it using the AES128 algorithm. The password for encrypting the object is retrieved by calling the `CCPassword` method on the rootObject class. If rootObject doesn't implement the `CCPassword` method, this method will throw an exception.
    
    + (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;
    
As above, except that the resulting encypted data will be written directly to the file specified by the path parameter.
    
    + (void)setClassName:(NSString *)codedName forClass:(Class)cls;
    + (NSString *)classNameForClass:(Class)cls;
    + (void)setClass:(Class)cls forClassName:(NSString *)codedName;
    + (Class)classForClassName:(NSString *)codedName;
    
These methods are used to specify class name substitutions when encoding or decoding objects, and can be useful when managing upgrades between app releases where classes may have been renamed. These methods wrap the equivalent methods of NSKeyedArchiver/Unarchiver respectively, so it makes no difference whether you call them on CryptoCoder or NSKeyedArchiver/Unarchiver.


Release notes
-----------------

Version 1.1.1

- Uodated for Xcode 9

Version 1.1

- Now requires ARC
- Implemented new key generation mechanism for iOS 5 / Mac OS 10.7 and above
- Now conforms to -Weverything warning level

Version 1.0.1

- Dropped support for Mac OS 10.6

Version 1.0

- Initial release

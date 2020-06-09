# PayU SDK Lite

Supports: iOS 10.x and above

## Branches:

* master - stable SDK releases
* develop - development branch, merge your feature branches here

## Dependencies:

The project minimizes the use of external dependencies. We only use Carthage to add dependencies for tests.
No external dependencies are used in the SDK.

## Release process

#### Before tests
* Create release branch: release/x.y.z
* Run unit tests for all configurations
* Update version number according to SemVer in PayU-SDK-Lite-Info.plist
* Update documentation
* Fill changelog entry
* Hand over to tester for tests
 
#### After Tests
* Archive UniversalLib target
* Distribute Content (docs, changelog)
* Upload archive to Google Drive / Distribute through Cocoapods (see steps below)
* Update Demo App
* Notify release alias by email: mobile_sdk_release@payu.pl

#### Cocoapods distribution
* Push the PayU_SDK_Lite.framework, trimSymbols.sh and doc files into the Github repo (https://github.com/PayU-EMEA/PayU-iOS).
* Change the version in the PayULite.podspec file
* Commit and tag the release with the version number
* Establish a session with the Cocoapods trunk repository by running the command: `pod trunk register mobile_sdk_objectivity@payu.pl 'PayU Mobile SDK'`
* Confirm the session using the link send to the mobile team email address
* Release the pod by running the command `pod repo push PayULite.podspec`

## Useful links
- https://payu21.docs.apiary.io/#reference/api-endpoints - interactive API docs
- https://developers.payu.com/en/restapi.html – API docs
- https://payu.okta-emea.com/login/login.htm?fromURI=%2Fapp%2FUserHome – PayU workplace
- https://github.com/PayU-EMEA/PayU-iOS-SDK-demo – Demo app repository
- https://drive.google.com/drive/u/0/folders/1OxjmEIUbB2Q1HippHw-2Dal9FwNnqwE0 – Release drive

## Testing
Since we do not want to expose all of the frameworks classes but still want to test them, we are exposing them in the form of another framework called "PayU SDK Test Access". To use it, we need to have a special test host app that will link the Test Access framework. This is needed to prevent duplicate declarations since the demo app already links with the PayUSDK Lite Framework.

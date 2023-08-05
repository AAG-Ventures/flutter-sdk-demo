# MetaOne Wallet Integration Guide for Flutter Android App

## Overview

This guide will walk you through integrating the MetaOne wallet into your Flutter Android app. Provide your users with a secure and convenient way to manage their digital assets with MetaOne Wallet. It is a custody wallet that eliminates the need for private keys, passphrases, or hardware wallets.

## Setup

### Step 1: Setting up SSH for access to your repositories

After you will be accepted to the SDK integration program, you will be provided with SSH keys required to access secure repositories. If you haven’t received them, please ask your integration success manager to provide you files.

### Step 2: Adding MetaOne Wallet SDK to your project

To begin integrating the MetaOne Wallet SDK into your Flutter application, you need to add the SDK package as a dependency in your project. The SDK package is hosted on Pub, making it easy to include in your app using Gradle and pubspec dependencies:

Add following config to your local properties file inside the android directory:
```
walletsdk.maven.url=given-by-aag
walletsdk.maven.username=given-by-aag
walletsdk.maven.password=given-by-aag
```

Add the following code to your build.gradle file:
```gradle
url properties.getProperty('walletsdk.maven.url')
credentials {
   username = properties.getProperty('walletsdk.maven.username')
   password = properties.getProperty('walletsdk.maven.password')
}
```

Add the following code to your pubspec.yaml dependencies:
```yaml
metaone_wallet_sdk: ^{version}
```

### Step 3: Initializing SDK

Import `metaone_wallet_sdk` to your Dart file:
```dart
import 'package:metaone_wallet_sdk/metaone_wallet_sdk.dart';
```

Map SDK config values:
```dart
final sdkConfig = <String, String>{
'sdk.realm': given-by-aag,
'sdk.environment': given-by-aag,
'sdk.api.client.reference': given-by-aag,
'sdk.config.url': given-by-aag,
'sdk.key': given-by-aag,
};
```

Initialize MetaOne SDK:
```dart
await initialize(sdkConfig);
```

Check session status:
```dart
await getSessionActivityStatus();
```

### Step 4: Creating User Session

To successfully initialize a user session, your back-end integration has to be ready first. Your backend should receive the Authorization token during initialization request.

Initialize session by calling: `logInWithSSO(token);`

Your session is initialized. You can now use all other functions that require Authorization.

Call `setupUserData();` to initialize user profile data.

## Using SDK functions

### SDK session management functions

- `initialize(Map<String,String> sdkConfig)`: Initializes the MetaOne SDK by setting up the app configuration. Provide SDKConfig map with configuration values.
- `setupUserData()`: Sets up the user data by fetching the user profile and user state. This function ensures that the user profile and user state are available for use.
- `loginWithSSO(String token)`: Performs the login process by sending an authorization token.
- `refreshSession()`: Refreshes the user session to extend the session expiration time.
- `openWallet()`: For new users opens the Signature creation flow. If Signature is created - opens Wallet activity.
- `getSessionActivityStatus()`: `SessionActivityStatus`: Retrieves the current session activity status, which can be one of the values defined in the `SessionActivityStatus` enum.
- `logout()`: Logs out the user by clearing the session data, signing out the wallet service.
- (In progress) `cancelTokenExpirationCountdown()`: Cancels the token expiration countdown if it is currently running.
- (In progress) `setOnTokenExpirationListener(onTokenExpirationListener: OnTokenExpirationListener)`: Sets the listener for token expiration events. You can implement the `OnTokenExpirationListener` interface to handle token expiration, session activity changes, and token countdown events.
- (In progress) `getExpireAt()`: Long: Retrieves the expiration timestamp of the user session.

### SDK API management functions (In progress)

- `getWallets()`: Retrieves the user's wallets.
- `getWallet(walletId: String?)`: Retrieves a specific wallet based on the wallet ID. You need to provide the wallet ID.
- `getCurrencies()`: Retrieves the user's currencies.
- `getCurrency(id: String?)`: Retrieves a specific currency based on the currency ID. You need to provide the currency ID.
- `getNFTs(walletId: String?, searchString: String?, limit: Int = 100, offset: Int = 0)`: Retrieves the user's NFTs (Non-Fungible Tokens) based on the wallet ID and optional search parameters. You can provide the wallet ID, a search string, and optional limit and offset values.
- `getTransactions(walletId: String?, assetRef: String?, bip44: String?, tokenAddress: String?, page: Int?, offset: Int?)`: Retrieves the transactions for a specific wallet and optional parameters. You need to provide the wallet ID and can optionally provide the asset reference, bip44 value, token address, page number, and offset.
- `getTransaction(walletId: String?, chainId: String?, bip44: String?)`: Retrieves a specific transaction based on the wallet ID, chain ID, and bip44 value. You need to provide the wallet ID, chain ID, and bip44 value.
- `getUserContacts()`: Retrieves the user's contacts from the address book.
- `getUserContactWithId(id: String)`: Retrieves a specific contact based on the contact ID. You need to provide the contact ID.

### SDK UI management functions (In progress)

- `getCurrentTheme()`: Retrieves the currently set theme for the MetaOne SDK UI. It returns an Int value representing the theme.
- `setCurrentTheme(theme: Int)`: Sets the theme for the MetaOne SDK UI. You need to provide the desired theme as an Int value. IMPORTANT. Currently, there are 2 available themes (light, dark). During the integration process, you can ask your success manager to add an additional theme by providing a custom color scheme.
- `getCurrentLanguage()`: Retrieves the currently set language for the MetaOne SDK UI. It returns a Locale object representing the language.
- `setCurrentLanguage(locale: String)`: Sets the language for the MetaOne SDK UI. You need to provide the desired language as a String value, representing the locale.

---

Please note that some functions are marked as "In progress," indicating they may not be fully implemented yet. Make sure to check the official documentation for the latest updates and usage instructions.

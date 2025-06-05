# 🥕 Freshfield Flutter SDK

Official Flutter SDK package for integrating Freshfield updates. This SDK allows you to fetch and display updates, features, and changes from your Freshfield dashboard directly in your Flutter app.

> Since freshfield is in the early stages of development, we recommend you to take a look at an example implementation.
> [example/lib/main.dart](example/lib/main.dart).



## Installation

Add to your `pubspec.yaml` file:

```yaml
dependencies:
  freshfield:
    git:
      url: https://github.com/freshfieldio/flutter_sdk
```



## Basic Usage

Initialize the Freshfield service and fetch updates in your Flutter application:

```dart
import 'package:freshfield/freshfield.dart';

// Initialize the service
final freshfield = FreshfieldService();
freshfield.init('YOUR_API_KEY'); //You can find it in Freshfield app /widgets#basic-usage (e.g. ff.ha060qgzxe7e00v55x08mhywplk259p2)

// Get updates
final updates = await freshfield.getUpdates(limit: 5, offset: 0);
```



## API Reference

#### Methods

- `init(String apiKey)`: Initialize the service with your API key.
- `getUpdates({int limit = 10, int offset = 0})`: Fetch updates with pagination support

### Update Model

The `Update` model contains the following fields:

- `id`: String
- `title`: String
- `description`: String
- `created`: DateTim
- `features`: List<Feature>

### Feature Model

The `Feature` model contains:

- `name`: String
- `description`: String
- `type`: String
- `icon`: String? - (SVG icon string, check [example/lib/main.dart](example/lib/main.dart) for svg render)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

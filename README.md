# Weather-App-iOS

WeatherApp is a simple weather application built using UIKit in Swift. It fetches weather data from an API and displays the current weather conditions for a specified location.

![Demo](./demo.gif)

## Features

- Displays current temperature in Celsius or Fahrenheit.
- Shows weather condition description and icon.
- Updates background image based on weather conditions.
- Allows users to search for weather by location.

## Requirements

- iOS 13.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/WeatherApp.git
    ```
2. Open the project in Xcode:
    ```sh
    cd WeatherApp
    open WeatherApp.xcodeproj
    ```
3. Build and run the project on your simulator or device.

## Usage

1. Launch the app.
2. Enter a location in the search bar and press enter.
3. The app will display the current weather conditions for the specified location.

## Project Structure

- `AppDelegate.swift`: Handles application lifecycle events.
- `SceneDelegate.swift`: Manages the app's scenes.
- `ViewController.swift`: Main view controller that handles UI updates and API calls.
- `DecodingType/WeatherResponseType.swift`: Defines the data models for decoding the weather API response.
- `Assets.xcassets`: Contains image assets for different weather conditions.
- `Base.lproj/Main.storyboard`: Defines the UI layout of the app.
- `Info.plist`: Contains app configuration and permissions.

## API Integration

The app fetches weather data from a weather API. The API response is decoded into Swift models defined in `WeatherResponseType`.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

- Weather icons are provided by SF Symbols.
- Background images are included in the project assets.

## Contact

For any questions or feedback, please contact [lalanachamika123@gmail.com](mailto:lalanachamika123@gmail.com).
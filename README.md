# AirQuality

This is the Devmountain iOS App Developer Bootcamp code-along exercise AirQuality app.

The app obtains air quality data from the IQ Air API: https://www.iqair.com/commercial/air-quality-monitors/airvisual-platform/api.

The code in this repo has been heavily modified compared to the suggested code.

- The API key is stored in an AirVisual-Info.plist file that is not included in the repo. An AirVisual-Info-Sample.plist file _is_ included in the repo, but not the build target, and is copied to the required AirVisual-Info.plist file using a build phase _run script_ if it doesn't exist. (This approach is modeled after https://peterfriese.dev/posts/reading-api-keys-from-plist-files/.)

- There is a FetchType enum to hold the fetch types and the associated API endpoints.

- The AirQualityError enum includes FetchType information for each error.

- The AirQualityController includes a helper function makeURL(from:withQueryItems:).

- The AirQualityController uses .map instead of a for-loop to extract country names, state names, and city names.


### Technoloy

Swift, UIKit, URLSession

# BaseLibrary

Reusable iOS base utilities and UIKit/Foundation extensions.

## BaseBottomBar

`BaseBottomBar` is a native UIKit bottom-navigation component implemented entirely
inside `BaseLibrary`. It supports regular tabs, a center action, badges, disabled
items, multiple indicator styles, optional animations, haptic feedback, content
transitions, reselect callbacks, and animated hide/show.

### Basic usage

```swift
import BaseLibrary

final class MainTabBarController: BaseBottomBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomBarConfiguration = BaseBottomBarConfiguration(
            appearance: BaseBottomBarAppearance(
                backgroundStyle: .notched(notchDiameter: 64, cornerRadius: 0),
                indicatorStyle: .circle(diameter: 48),
                backgroundColor: .systemBackground,
                indicatorColor: .systemPink,
                selectedItemColor: .white,
                normalItemColor: .secondaryLabel,
                showsTitles: true
            ),
            selectionAnimation: .spring(duration: 0.45, dampingRatio: 0.72),
            hapticFeedback: .selection
        )
        contentTransition = .slide(duration: 0.25)

        setTabs([
            BaseBottomBarTab(
                viewController: HomeViewController(),
                image: UIImage(systemName: "house")!,
                selectedImage: UIImage(systemName: "house.fill"),
                title: "Home",
                accessibilityLabel: "Home"
            ),
            .action(
                image: UIImage(systemName: "plus")!,
                accessibilityLabel: "Create"
            ),
            BaseBottomBarTab(
                viewController: SettingsViewController(),
                image: UIImage(systemName: "gearshape")!,
                selectedImage: UIImage(systemName: "gearshape.fill"),
                title: "Settings",
                accessibilityLabel: "Settings"
            )
        ], selectedIndex: 0)
    }

    override func bottomBarDidTriggerAction(at index: Int) {
        present(CreateViewController(), animated: true)
    }

    override func bottomBarDidReselectTab(at index: Int) {
        // Example: scroll the current tab to the top.
    }

    override func shouldSelectTab(at index: Int) -> Bool {
        // Return false to block a tab, for example when authentication is required.
        true
    }
}
```

### Animation choices

Selection indicator animations:

```swift
bottomBarConfiguration.selectionAnimation = .none
bottomBarConfiguration.selectionAnimation = .ease(duration: 0.25)
bottomBarConfiguration.selectionAnimation = .fade(duration: 0.2)
bottomBarConfiguration.selectionAnimation = .spring(duration: 0.45, dampingRatio: 0.72)
bottomBarConfiguration.selectionAnimation = .bounce(duration: 0.4)
```

Content transitions:

```swift
contentTransition = .none
contentTransition = .crossDissolve(duration: 0.2)
contentTransition = .slide(duration: 0.25)
contentTransition = .scale(duration: 0.2)
```

Disable every animation:

```swift
bottomBarConfiguration.animationsEnabled = false
contentTransition = .none
```

Reduce Motion is honored automatically by default.

### Indicator and background styles

```swift
bottomBarConfiguration.appearance.indicatorStyle = .none
bottomBarConfiguration.appearance.indicatorStyle = .circle(diameter: 48)
bottomBarConfiguration.appearance.indicatorStyle = .pill(
    size: CGSize(width: 56, height: 34)
)
bottomBarConfiguration.appearance.indicatorStyle = .underline(width: 28, height: 3)

bottomBarConfiguration.appearance.backgroundStyle = .flat(cornerRadius: 0)
bottomBarConfiguration.appearance.backgroundStyle = .floating(
    horizontalInset: 16,
    cornerRadius: 24
)
bottomBarConfiguration.appearance.backgroundStyle = .notched(
    notchDiameter: 64,
    cornerRadius: 0
)
```

### Runtime controls

```swift
selectTab(at: 2)
setBadge("9", at: 2)
setBadge(nil, at: 2)
setTabEnabled(false, at: 2)
setBottomBarHidden(true, animated: true)
setBottomBarHidden(false, animated: true)

var updatedItem = tabs[0].item
updatedItem.title = "Dashboard"
updateTabItem(updatedItem, at: 0)
```

## Install From Git

```ruby
pod 'BaseLibrary', :git => 'https://github.com/NgVuongQuoc/BaseLibrary.git', :tag => '0.2.0'
```

## Release A New Version

1. Update `s.version` in `BaseLibrary.podspec`.
2. Commit and push changes.
3. Create a matching git tag, for example:

```sh
git tag 0.2.0
git push origin main --tags
```

Apps can then point to that tag in their `Podfile`.

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
bottomBarConfiguration.selectionAnimation = .toss
```

Use `bounce` for a squash-and-release effect at the destination. Use `toss` when
the circle should travel upward in an arc and then land on the selected tab.

For the complete toss preset, only choose its colors and whether titles appear:

```swift
bottomBarConfiguration = .toss(
    backgroundColor: .systemYellow,
    indicatorColor: .systemBlue,
    selectedItemColor: .white,
    normalItemColor: .secondaryLabel,
    showsTitles: true
)
```

The complete preset reproduces AMTabView's original sizing, ball trajectory,
two-phase notch transition, tint timing, 60-point bar, safe-area fill, and
immediate child-controller switch. Tapping the selected item makes the ball
jump vertically and triggers `bottomBarDidReselectTab(at:)`.

Set controller-level options before or after the preset to override its
60-point height and immediate content switch:

```swift
bottomBarHeight = 72
contentTransition = .crossDissolve(duration: 0.2)
bottomBarConfiguration = .toss()
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
bottomBarConfiguration.appearance.backgroundStyle = .liquidGlass(
    horizontalInset: 16,
    cornerRadius: 28,
    style: .regular,
    tintColor: .systemOrange,
    isInteractive: true,
    fallback: .systemMaterial
)
```

`flat` and `notched` are bottom-attached styles: their corner radius applies to
the two top corners while the background continues through the device safe area.
Use `floating` when all four corners should be rounded with transparent space
under the bar.

`liquidGlass` automatically uses UIKit's native `UIGlassEffect` when built with
Xcode 26 and run on iOS 26. It falls back when built with an older Xcode or when
running on iOS 13–25. Available fallbacks are `.systemUltraThinMaterial`,
`.systemThinMaterial`, `.systemMaterial`, `.systemThickMaterial`, and
`.solid(UIColor)`. When Reduce Transparency is enabled on an older system, the
bar uses a solid accessible background instead of blur.

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
pod 'BaseLibrary', :git => 'https://github.com/NgVuongQuoc/BaseLibrary.git', :tag => '0.3.3'
```

## Release A New Version

1. Update `s.version` in `BaseLibrary.podspec`.
2. Commit and push changes.
3. Create a matching git tag, for example:

```sh
git tag 0.3.3
git push origin main --tags
```

Apps can then point to that tag in their `Podfile`.

## Third-Party Notices

The complete toss preset is adapted from AMTabView 0.1.2 under the MIT license.
See `THIRD_PARTY_NOTICES.md` for the required copyright and license notice.

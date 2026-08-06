import XCTest
@testable import BaseLibrary

@MainActor
final class BaseBottomBarTests: XCTestCase {
    func testInitialSelectionUsesFirstEnabledTab() {
        let bottomBar = BaseBottomBar()
        bottomBar.setItems([
            makeItem(role: .action),
            makeItem(isEnabled: false),
            makeItem()
        ])

        XCTAssertEqual(bottomBar.selectedIndex, 2)
    }

    func testActionAndDisabledItemsCannotBeSelected() {
        let bottomBar = BaseBottomBar()
        bottomBar.setItems([
            makeItem(),
            makeItem(role: .action),
            makeItem(isEnabled: false)
        ])

        XCTAssertFalse(bottomBar.selectItem(at: 1))
        XCTAssertFalse(bottomBar.selectItem(at: 2))
        XCTAssertFalse(bottomBar.selectItem(at: 99))
        XCTAssertEqual(bottomBar.selectedIndex, 0)
    }

    func testBadgeUpdatesTheStoredItem() {
        let bottomBar = BaseBottomBar()
        bottomBar.setItems([makeItem()])

        XCTAssertTrue(bottomBar.setBadge("12", at: 0))
        XCTAssertEqual(bottomBar.items[0].badgeValue, "12")
        XCTAssertTrue(bottomBar.setBadge(nil, at: 0))
        XCTAssertNil(bottomBar.items[0].badgeValue)
    }

    func testLastSelectedTabCannotBeDisabled() {
        let bottomBar = BaseBottomBar()
        bottomBar.setItems([makeItem()])

        XCTAssertFalse(bottomBar.setItemEnabled(false, at: 0))
        XCTAssertTrue(bottomBar.items[0].isEnabled)
        XCTAssertEqual(bottomBar.selectedIndex, 0)
    }

    func testDisablingSelectedTabMovesToNextAllowedTab() {
        let bottomBar = BaseBottomBar()
        let delegate = BottomBarDelegateSpy()
        bottomBar.delegate = delegate
        bottomBar.setItems([makeItem(), makeItem(), makeItem()])

        XCTAssertTrue(bottomBar.setItemEnabled(false, at: 0))
        XCTAssertEqual(bottomBar.selectedIndex, 1)
        XCTAssertEqual(delegate.selectedIndices, [1])
    }

    func testControllerKeepsSelectionAndItemStateInSync() {
        let controller = BaseBottomBarController()
        controller.setTabs([
            BaseBottomBarTab(
                viewController: UIViewController(),
                image: UIImage(),
                title: "One"
            ),
            .action(image: UIImage(), title: "Create"),
            BaseBottomBarTab(
                viewController: UIViewController(),
                image: UIImage(),
                title: "Two"
            )
        ], selectedIndex: 0)

        XCTAssertEqual(controller.selectedIndex, 0)
        XCTAssertTrue(controller.selectTab(at: 2, animated: false))
        XCTAssertEqual(controller.selectedIndex, 2)
        XCTAssertEqual(controller.baseBottomBar.selectedIndex, 2)

        XCTAssertTrue(controller.setBadge("3", at: 2))
        XCTAssertEqual(controller.tabs[2].item.badgeValue, "3")
        XCTAssertEqual(controller.baseBottomBar.items[2].badgeValue, "3")

        XCTAssertTrue(controller.setTabEnabled(false, at: 2))
        XCTAssertEqual(controller.selectedIndex, 0)
        XCTAssertEqual(controller.baseBottomBar.selectedIndex, 0)
    }

    func testFloatingBackgroundLeavesBottomSafeAreaTransparent() {
        let controller = BaseBottomBarController()
        var configuration = BaseBottomBarConfiguration()
        configuration.appearance.backgroundStyle = .floating(
            horizontalInset: 16,
            cornerRadius: 24
        )
        configuration.appearance.backgroundColor = .systemOrange
        controller.bottomBarConfiguration = configuration
        controller.loadViewIfNeeded()

        let safeAreaFill = controller.view.subviews.first {
            $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.safeAreaFill"
        }
        XCTAssertEqual(safeAreaFill?.backgroundColor, UIColor.clear)

        configuration.appearance.backgroundStyle = .flat(cornerRadius: 0)
        controller.bottomBarConfiguration = configuration
        XCTAssertEqual(safeAreaFill?.backgroundColor, UIColor.systemOrange)

        configuration.appearance.backgroundStyle = .liquidGlass()
        controller.bottomBarConfiguration = configuration
        XCTAssertEqual(safeAreaFill?.backgroundColor, UIColor.clear)
    }

    func testLiquidGlassUsesTheBestEffectForTheRunningSystem() throws {
        let bottomBar = BaseBottomBar(frame: CGRect(x: 0, y: 0, width: 390, height: 72))
        bottomBar.configuration = BaseBottomBarConfiguration(
            appearance: BaseBottomBarAppearance(
                backgroundStyle: .liquidGlass(
                    horizontalInset: 16,
                    cornerRadius: 28,
                    style: .regular,
                    tintColor: .systemOrange,
                    isInteractive: true,
                    fallback: .systemMaterial
                ),
                indicatorStyle: .circle(diameter: 48),
                backgroundColor: .systemOrange
            )
        )
        bottomBar.setItems([BaseBottomBarItem(image: UIImage())])
        bottomBar.layoutIfNeeded()

        let effectView = try XCTUnwrap(bottomBar.subviews.first {
            $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.liquidGlass"
        } as? UIVisualEffectView)

        XCTAssertFalse(effectView.isHidden)
        XCTAssertEqual(effectView.frame.minX, 16, accuracy: 0.5)
        XCTAssertEqual(effectView.frame.width, 358, accuracy: 0.5)
        XCTAssertEqual(effectView.layer.cornerRadius, 28, accuracy: 0.5)

        #if compiler(>=6.2)
            if #available(iOS 26.0, *) {
                let effect = try XCTUnwrap(effectView.effect as? UIGlassEffect)
                XCTAssertTrue(effect.isInteractive)
                XCTAssertEqual(effect.tintColor, UIColor.systemOrange)
            } else {
                XCTAssertTrue(effectView.effect is UIBlurEffect)
            }
        #else
            XCTAssertTrue(effectView.effect is UIBlurEffect)
        #endif
    }

    func testCircleIndicatorCentersSelectedIcon() throws {
        let bottomBar = BaseBottomBar(frame: CGRect(x: 0, y: 0, width: 390, height: 72))
        bottomBar.configuration = BaseBottomBarConfiguration(
            appearance: BaseBottomBarAppearance(
                backgroundStyle: .floating(horizontalInset: 16, cornerRadius: 24),
                indicatorStyle: .circle(diameter: 48),
                showsTitles: true,
                contentInsets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            ),
            selectionAnimation: .toss(duration: 0.55, height: 28)
        )
        bottomBar.setItems([
            BaseBottomBarItem(image: UIImage(), title: "Home"),
            BaseBottomBarItem(image: UIImage(), title: "Search")
        ], selectedIndex: 0)
        bottomBar.layoutIfNeeded()

        let indicator = try XCTUnwrap(bottomBar.subviews.first {
            $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.indicator"
        })
        let selectedButton = try XCTUnwrap(bottomBar.subviews
            .flatMap(\.subviews)
            .first {
                $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.item.0"
            })
        let icon = try XCTUnwrap(selectedButton.subviews.first {
            $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.icon"
        })
        let iconCenter = icon.convert(
            CGPoint(x: icon.bounds.midX, y: icon.bounds.midY),
            to: bottomBar
        )

        XCTAssertEqual(iconCenter.x, indicator.frame.midX, accuracy: 0.5)
        XCTAssertEqual(iconCenter.y, indicator.frame.midY, accuracy: 0.5)
        XCTAssertLessThan(indicator.frame.minY, 0)
        XCTAssertGreaterThan(indicator.frame.maxY, 0)
    }

    private func makeItem(
        role: BaseBottomBarItemRole = .tab,
        isEnabled: Bool = true
    ) -> BaseBottomBarItem {
        BaseBottomBarItem(
            image: UIImage(),
            role: role,
            isEnabled: isEnabled
        )
    }
}

@MainActor
private final class BottomBarDelegateSpy: BaseBottomBarDelegate {
    private(set) var selectedIndices: [Int] = []

    func baseBottomBar(_ bottomBar: BaseBottomBar, didSelectItemAt index: Int) {
        selectedIndices.append(index)
    }
}

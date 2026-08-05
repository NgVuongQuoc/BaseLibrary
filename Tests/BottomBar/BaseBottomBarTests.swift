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

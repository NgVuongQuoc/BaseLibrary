import UIKit
import XCTest
@testable import BaseLibrary

@MainActor
final class AdaptiveLayoutTests: XCTestCase {
    func testDuoDisplayChangeUpdatesLayoutWithoutChangingSizeOrTraits() {
        let controller = LayoutSpy()
        controller.displayTypeOverride = .duoInner
        XCTAssertFalse(controller.isViewLoaded)
        controller.loadViewIfNeeded()
        controller.view.bounds.size = CGSize(width: 390, height: 800)
        controller.viewWillLayoutSubviews()
        let inner = controller.contexts.last
        let count = controller.contexts.count
        XCTAssertEqual(inner?.displayType, .duoInner)

        controller.displayTypeOverride = .duoOuter
        controller.viewWillLayoutSubviews()
        XCTAssertEqual(controller.contexts.count, count + 1)
        XCTAssertEqual(controller.contexts.last?.displayType, .duoOuter)
        XCTAssertEqual(controller.contexts.last?.size, inner?.size)

        controller.viewWillLayoutSubviews()
        XCTAssertEqual(controller.contexts.count, count + 1)

        controller.displayTypeOverride = nil
        controller.viewWillLayoutSubviews()
        XCTAssertEqual(controller.contexts.last?.displayType,
            DeviceDisplayType(traitCollection: controller.traitCollection))
    }

    func testDisplayOverridesAreLocalToEachController() {
        let inner = LayoutSpy()
        let outer = LayoutSpy()
        inner.displayTypeOverride = .duoInner
        outer.displayTypeOverride = .duoOuter
        for controller in [inner, outer] {
            controller.loadViewIfNeeded()
            controller.view.bounds.size = CGSize(width: 390, height: 800)
            controller.viewWillLayoutSubviews()
        }

        XCTAssertEqual(inner.adaptiveLayoutContext?.displayType, .duoInner)
        XCTAssertEqual(outer.adaptiveLayoutContext?.displayType, .duoOuter)
    }

    func testInnerDisplayCanUseCompactLayout() {
        let traits = UITraitCollection(horizontalSizeClass: .compact)
        let context = AdaptiveLayoutContext(
            size: CGSize(width: 390, height: 800), safeAreaInsets: .zero,
            traits: traits, displayType: .duoInner
        )

        XCTAssertEqual(context.displayType, .duoInner)
        XCTAssertEqual(context.layoutType, .compact)
    }

    func testWidthChangesWithoutSizeClassChangeAndSkipsDuplicatePasses() {
        let controller = LayoutSpy()
        controller.loadViewIfNeeded()
        controller.view.bounds.size = CGSize(width: 390, height: 800)
        controller.viewWillLayoutSubviews()
        let initialCount = controller.contexts.count
        let originalClass = controller.contexts.last?.horizontalSizeClass
        controller.viewWillLayoutSubviews()
        XCTAssertEqual(controller.contexts.count, initialCount)

        controller.view.bounds.size.width = 600
        controller.viewWillLayoutSubviews()
        XCTAssertEqual(controller.contexts.count, initialCount + 1)
        XCTAssertEqual(controller.contexts.last?.size.width, 600)
        XCTAssertEqual(controller.contexts.last?.horizontalSizeClass, originalClass)
    }

    func testZeroSizeWaitsForUsableGeometry() {
        let controller = LayoutSpy()
        controller.loadViewIfNeeded()
        controller.view.bounds.size = .zero
        controller.viewWillLayoutSubviews()
        XCTAssertNil(controller.adaptiveLayoutContext)
        XCTAssertTrue(controller.contexts.isEmpty)
    }

    func testSafeAreaAndDynamicTypeAffectContext() {
        let size = CGSize(width: 600, height: 800)
        let original = AdaptiveLayoutContext(size: size, safeAreaInsets: .zero,
            traits: UITraitCollection(preferredContentSizeCategory: .large))
        let inset = AdaptiveLayoutContext(size: size,
            safeAreaInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30),
            traits: UITraitCollection(preferredContentSizeCategory: .large))
        let largerText = AdaptiveLayoutContext(size: size, safeAreaInsets: .zero,
            traits: UITraitCollection(preferredContentSizeCategory: .accessibilityLarge))
        XCTAssertEqual(inset.availableWidth, 550)
        XCTAssertNotEqual(original, inset)
        XCTAssertNotEqual(original, largerText)
    }
}

@MainActor
private final class LayoutSpy: BaseAdaptiveViewController {
    var contexts: [AdaptiveLayoutContext] = []

    override func adaptiveLayoutDidChange(_ context: AdaptiveLayoutContext) {
        contexts.append(context)
    }
}

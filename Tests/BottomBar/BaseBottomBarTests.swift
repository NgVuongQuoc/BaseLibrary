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

        configuration.appearance.backgroundStyle = .notched(
            notchDiameter: 68,
            cornerRadius: 20
        )
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
            selectionAnimation: .toss
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

    func testFlatBackgroundRoundsOnlyTopCornersForSafeAreaJoin() throws {
        let bottomBar = makeGeometryTestBottomBar(
            backgroundStyle: .flat(cornerRadius: 24)
        )
        let path = try XCTUnwrap(backgroundPath(in: bottomBar))

        XCTAssertFalse(path.contains(CGPoint(x: 1, y: 1)))
        XCTAssertTrue(path.contains(CGPoint(x: 1, y: 71)))
        XCTAssertTrue(path.contains(CGPoint(x: 389, y: 71)))
    }

    func testNotchedBackgroundUsesOneContinuousWavePath() throws {
        let bottomBar = makeGeometryTestBottomBar(
            backgroundStyle: .notched(notchDiameter: 68, cornerRadius: 20)
        )
        let referencePath = try XCTUnwrap(backgroundPath(in: bottomBar))
        let referenceElementTypes = elementTypes(in: referencePath)

        for index in 0..<5 {
            XCTAssertTrue(bottomBar.selectItem(at: index, animated: false))
            bottomBar.layoutIfNeeded()

            let path = try XCTUnwrap(backgroundPath(in: bottomBar))
            let indicator = try XCTUnwrap(bottomBar.subviews.first {
                $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.indicator"
            })

            XCTAssertEqual(moveToCount(in: path), 1)
            XCTAssertEqual(elementTypes(in: path), referenceElementTypes)
            XCTAssertFalse(path.contains(CGPoint(x: indicator.frame.midX, y: 1)))
            XCTAssertTrue(path.contains(CGPoint(x: indicator.frame.midX, y: 45)))
            XCTAssertTrue(path.contains(CGPoint(x: 1, y: 71)))
            XCTAssertTrue(path.contains(CGPoint(x: 389, y: 71)))
        }
    }

    func testTossPresetConfiguresOriginalControllerBehavior() {
        let controller = BaseBottomBarController()
        controller.bottomBarConfiguration = .toss(
            backgroundColor: .systemYellow,
            indicatorColor: .systemBlue,
            selectedItemColor: .white,
            normalItemColor: .secondaryLabel,
            showsTitles: true
        )

        XCTAssertEqual(controller.bottomBarHeight, 60)
        XCTAssertEqual(
            controller.bottomBarConfiguration.appearance.backgroundColor,
            UIColor.systemYellow
        )
        XCTAssertEqual(
            controller.bottomBarConfiguration.appearance.indicatorColor,
            UIColor.systemBlue
        )
        XCTAssertTrue(controller.bottomBarConfiguration.appearance.showsTitles)
        if case .none = controller.bottomBarConfiguration.hapticFeedback {
            // Matches the original AMTabsViewController behavior.
        } else {
            XCTFail("The complete toss preset must not add haptic feedback")
        }
        XCTAssertFalse(controller.bottomBarConfiguration.allowsReselection)
        if case .none = controller.contentTransition {
            // Matches AMTabsViewController's immediate content replacement.
        } else {
            XCTFail("The complete toss preset must disable content transitions")
        }
    }

    func testTossEngineMatchesAMTabViewGeometryAndTiming() throws {
        let bounds = CGRect(x: 0, y: 0, width: 390, height: 60)
        let metrics = BaseBottomBarTossEngine.metrics(
            in: bounds,
            numberOfTabs: 5
        )

        XCTAssertEqual(metrics.sectionWidth, 78, accuracy: 0.001)
        XCTAssertEqual(metrics.ballSize, 39, accuracy: 0.001)
        XCTAssertEqual(metrics.itemHeight, 39, accuracy: 0.001)
        XCTAssertEqual(metrics.iconSize, 26, accuracy: 0.001)
        XCTAssertEqual(BaseBottomBarTossEngine.shapePhaseDuration, 0.2)
        XCTAssertEqual(BaseBottomBarTossEngine.ballDuration, 0.4)
        XCTAssertEqual(BaseBottomBarTossEngine.tintAndIconDuration, 0.4)

        let ballElements = pathElements(
            in: BaseBottomBarTossEngine.ballPath(
                fromX: 39,
                toX: 351,
                in: bounds,
                numberOfTabs: 5
            )
        )
        XCTAssertEqual(ballElements.count, 2)
        XCTAssertPointEqual(ballElements[0].points[0], CGPoint(x: 39, y: 19.5))
        XCTAssertPointEqual(ballElements[1].points[0], CGPoint(x: 195, y: -312))
        XCTAssertPointEqual(ballElements[1].points[1], CGPoint(x: 351, y: 9.75))

        let notchElements = pathElements(
            in: BaseBottomBarTossEngine.notchPath(
                selectedIndex: 0,
                in: bounds,
                numberOfTabs: 5
            )
        )
        XCTAssertPointEqual(notchElements[1].points[0], CGPoint(x: -23.4, y: 0))
        XCTAssertPointEqual(notchElements[2].points[0], CGPoint(x: 7.8, y: 0))
        XCTAssertPointEqual(notchElements[2].points[1], CGPoint(x: 15.6, y: 19.5))
        XCTAssertPointEqual(notchElements[3].points[0], CGPoint(x: 23.4, y: 39))
        XCTAssertPointEqual(notchElements[3].points[1], CGPoint(x: 54.6, y: 39))
        XCTAssertPointEqual(notchElements[3].points[2], CGPoint(x: 62.4, y: 19.5))
        XCTAssertPointEqual(notchElements[4].points[0], CGPoint(x: 70.2, y: 0))
        XCTAssertPointEqual(notchElements[4].points[1], CGPoint(x: 101.4, y: 0))
    }

    func testTossPresetUsesDynamicBallAndIconSizes() throws {
        let bottomBar = BaseBottomBar(
            frame: CGRect(x: 0, y: 0, width: 390, height: 60)
        )
        bottomBar.configuration = .toss(showsTitles: false)
        bottomBar.setItems((0..<5).map { index in
            BaseBottomBarItem(image: UIImage(), title: "Item \(index)")
        }, selectedIndex: 0)
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

        XCTAssertEqual(indicator.frame.width, 39, accuracy: 0.001)
        XCTAssertEqual(indicator.frame.midY, 9.75, accuracy: 0.001)
        XCTAssertEqual(icon.frame.width, 26, accuracy: 0.001)
        XCTAssertEqual(icon.frame.minY, -3.25, accuracy: 0.001)
    }

    func testTossSelectionInstallsOriginalAnimationPhases() throws {
        let bottomBar = BaseBottomBar(
            frame: CGRect(x: 0, y: 0, width: 390, height: 60)
        )
        bottomBar.configuration = .toss()
        bottomBar.setItems((0..<5).map { _ in
            BaseBottomBarItem(image: UIImage())
        }, selectedIndex: 0)
        bottomBar.layoutIfNeeded()

        XCTAssertTrue(bottomBar.selectItem(at: 4, animated: true))

        let indicator = try XCTUnwrap(bottomBar.subviews.first {
            $0.accessibilityIdentifier == "BaseLibrary.BaseBottomBar.indicator"
        })
        let ballAnimation = try XCTUnwrap(
            indicator.layer.animation(
                forKey: "BaseLibrary.BottomBar.toss.ball"
            ) as? CAKeyframeAnimation
        )
        let backgroundLayer = try XCTUnwrap(bottomBar.layer.sublayers?.first {
            $0.name == "BaseLibrary.BaseBottomBar.background"
        } as? CAShapeLayer)
        let flattenAnimation = try XCTUnwrap(
            backgroundLayer.animation(
                forKey: "BaseLibrary.BottomBar.toss.background"
            ) as? CABasicAnimation
        )

        XCTAssertEqual(ballAnimation.duration, 0.4, accuracy: 0.001)
        XCTAssertNotNil(ballAnimation.path)
        XCTAssertEqual(flattenAnimation.duration, 0.2, accuracy: 0.001)
        XCTAssertNotNil(flattenAnimation.toValue)
    }

    private func makeGeometryTestBottomBar(
        backgroundStyle: BaseBottomBarBackgroundStyle
    ) -> BaseBottomBar {
        let bottomBar = BaseBottomBar(
            frame: CGRect(x: 0, y: 0, width: 390, height: 72)
        )
        bottomBar.configuration = BaseBottomBarConfiguration(
            appearance: BaseBottomBarAppearance(
                backgroundStyle: backgroundStyle,
                indicatorStyle: .circle(diameter: 50),
                showsTitles: true
            )
        )
        bottomBar.setItems((0..<5).map { index in
            BaseBottomBarItem(image: UIImage(), title: "Item \(index)")
        }, selectedIndex: 0)
        bottomBar.layoutIfNeeded()
        return bottomBar
    }

    private func backgroundPath(in bottomBar: BaseBottomBar) -> CGPath? {
        (bottomBar.layer.sublayers?.first {
            $0.name == "BaseLibrary.BaseBottomBar.background"
        } as? CAShapeLayer)?.path
    }

    private func moveToCount(in path: CGPath) -> Int {
        var count = 0
        path.applyWithBlock { element in
            if element.pointee.type == .moveToPoint {
                count += 1
            }
        }
        return count
    }

    private func elementTypes(in path: CGPath) -> [CGPathElementType] {
        var types: [CGPathElementType] = []
        path.applyWithBlock { element in
            types.append(element.pointee.type)
        }
        return types
    }

    private func pathElements(
        in path: CGPath
    ) -> [(type: CGPathElementType, points: [CGPoint])] {
        var elements: [(CGPathElementType, [CGPoint])] = []
        path.applyWithBlock { element in
            let pointCount: Int
            switch element.pointee.type {
            case .moveToPoint, .addLineToPoint:
                pointCount = 1
            case .addQuadCurveToPoint:
                pointCount = 2
            case .addCurveToPoint:
                pointCount = 3
            case .closeSubpath:
                pointCount = 0
            @unknown default:
                pointCount = 0
            }
            elements.append((
                element.pointee.type,
                (0..<pointCount).map { element.pointee.points[$0] }
            ))
        }
        return elements
    }

    private func XCTAssertPointEqual(
        _ actual: CGPoint,
        _ expected: CGPoint,
        accuracy: CGFloat = 0.001,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(actual.x, expected.x, accuracy: accuracy, file: file, line: line)
        XCTAssertEqual(actual.y, expected.y, accuracy: accuracy, file: file, line: line)
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

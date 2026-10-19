import XCTest
@testable import BaseLibrary

final class DeviceTypeTests: XCTestCase {
    func testDisplayCasesPreserveExistingRawValuesAndIncludeBothDuoDisplays() {
        XCTAssertEqual(DeviceDisplayType.watch.rawValue, 0)
        XCTAssertEqual(DeviceDisplayType.iPhone.rawValue, 1)
        XCTAssertEqual(DeviceDisplayType.iPad.rawValue, 2)
        XCTAssertNil(DeviceDisplayType(rawValue: 3))
        XCTAssertTrue(DeviceDisplayType.allCases.contains(.duoInner))
        XCTAssertTrue(DeviceDisplayType.allCases.contains(.duoOuter))
        XCTAssertTrue(DeviceDisplayType.allCases.contains(.unspecified))
    }

    func testIdiomDoesNotGuessDuoFromRegularWidth() {
        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceIdiom: .phone),
            UITraitCollection(horizontalSizeClass: .regular)
        ])

        XCTAssertEqual(DeviceDisplayType(traitCollection: traits), .iPhone)
        XCTAssertEqual(DeviceDisplayType(userInterfaceIdiom: .pad), .iPad)
        XCTAssertEqual(DeviceDisplayType(userInterfaceIdiom: .unspecified), .unspecified)
        XCTAssertEqual(DeviceDisplayType(userInterfaceIdiom: .tv), .unspecified)
    }

    func testDuoIncludesOnlyItsTwoDisplays() {
        XCTAssertTrue(DeviceDisplayType.duoInner.isDuo)
        XCTAssertTrue(DeviceDisplayType.duoOuter.isDuo)
        XCTAssertFalse(DeviceDisplayType.iPhone.isDuo)
        XCTAssertFalse(DeviceDisplayType.iPad.isDuo)
        XCTAssertFalse(DeviceDisplayType.watch.isDuo)
        XCTAssertFalse(DeviceDisplayType.unspecified.isDuo)
    }

    func testCompactWidthUsesCompactLayout() {
        let traits = UITraitCollection(horizontalSizeClass: .compact)

        XCTAssertEqual(DeviceLayoutType(traitCollection: traits), .compact)
        XCTAssertFalse(DeviceLayoutType(traitCollection: traits).usesExpandedLayout)
        XCTAssertEqual(itemPerRow(for: traits), 2)
        XCTAssertEqual(spacingPerRow(for: traits), 3)
    }

    func testRegularWidthUsesExpandedLayout() {
        let traits = UITraitCollection(horizontalSizeClass: .regular)

        XCTAssertEqual(DeviceLayoutType(traitCollection: traits), .regular)
        XCTAssertTrue(DeviceLayoutType(traitCollection: traits).usesExpandedLayout)
        XCTAssertEqual(itemPerRow(for: traits), 3)
        XCTAssertEqual(spacingPerRow(for: traits), 4)
    }

    func testUnspecifiedWidthDoesNotAssumeExpandedLayout() {
        let traits = UITraitCollection(horizontalSizeClass: .unspecified)

        XCTAssertEqual(DeviceLayoutType(traitCollection: traits), .unspecified)
        XCTAssertFalse(DeviceLayoutType(traitCollection: traits).usesExpandedLayout)
    }
}

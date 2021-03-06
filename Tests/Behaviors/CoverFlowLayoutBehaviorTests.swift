//
//  CoverFlowLayoutBehaviorTests.swift
//  BrickKit
//
//  Created by Randall Spence on 10/11/16.
//  Copyright © 2016 Wayfair. All rights reserved.
//

import XCTest
@testable import BrickKit

extension CGAffineTransform {
    var scaleX: CGFloat {
        return self.a
    }

    var scaleY: CGFloat {
        return self.d
    }
}

class CoverFlowLayoutBehaviorTests: XCTestCase {

    var brickView: BrickCollectionView!
    var repeatCountDataSource: FixedRepeatCountDataSource!
    let coverFlowBehavior = CoverFlowLayoutBehavior(minimumScaleFactor: 0.5)

    override func setUp() {
        super.setUp()
        brickView = BrickCollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 480))

        brickView.layout.behaviors.insert(coverFlowBehavior)
        brickView.layout.scrollDirection = .Horizontal
        brickView.registerBrickClass(DummyBrick.self)
        let section = BrickSection(bricks: [
            DummyBrick("Brick", width: .Ratio(ratio: 1/3), height: .Fixed(size: 50))
            ])
        repeatCountDataSource = FixedRepeatCountDataSource(repeatCountHash: ["Brick": 20])
        section.repeatCountDataSource = repeatCountDataSource
        brickView.setSection(section)
        brickView.layoutSubviews()
    }

    func testCoverFlowBehaviorBase() {

        let cellBase = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        let cell1 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1))
        let cell2 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 1))
        let cell3 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 2, inSection: 1))

        XCTAssertEqualWithAccuracy(cellBase!.transform.scaleX, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cellBase!.transform.scaleY, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell1!.transform.scaleX, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell1!.transform.scaleY, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleX, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleY, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleX, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleY, 2/3, accuracy: 0.01)
    }


    func testCoverFlowBehaviorScrollHalf() {
        brickView.contentOffset.x = brickView.frame.width / 6
        brickView.layoutIfNeeded()

        let cell1 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1))
        let cell2 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 1))
        let cell3 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 2, inSection: 1))

        XCTAssertEqualWithAccuracy(cell1!.transform.scaleX, 0.5, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell1!.transform.scaleY, 0.5, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleX, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleY, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleX, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleY, 5/6, accuracy: 0.01)
    }

    func testCoverFlowBehaviorScrollToEnd() {
        brickView.contentOffset.x = brickView.contentSize.width - brickView.frame.width
        brickView.layoutSubviews()

        let cell1 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 17, inSection: 1))
        let cell2 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 18, inSection: 1))
        let cell3 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 19, inSection: 1))

        XCTAssertEqualWithAccuracy(cell1!.transform.scaleX, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell1!.transform.scaleY, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleX, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleY, 1, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleX, 2/3, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleY, 2/3, accuracy: 0.01)
    }

    func testCoverFlowBehaviorScrollNegative() {
        brickView.contentOffset.x = -(brickView.frame.width / 6)
        brickView.layoutIfNeeded()

        let cell1 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1))
        let cell2 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 1))
        let cell3 = brickView.cellForItemAtIndexPath(NSIndexPath(forItem: 2, inSection: 1))

        XCTAssertEqualWithAccuracy(cell1!.transform.scaleX, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell1!.transform.scaleY, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleX, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell2!.transform.scaleY, 5/6, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleX, 0.5, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(cell3!.transform.scaleY, 0.5, accuracy: 0.01)
    }

    func testIfContentSizeIsCalculatedCorrectly() {
        XCTAssertEqual(brickView.contentSize, CGSize(width: 2000, height: 50))
    }
}


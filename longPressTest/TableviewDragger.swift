//
//  TableviewDragger.swift
//  longPressTest
//
//  Created by larvata_ios on 2018/9/6.
//  Copyright © 2018年 dishrank. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TableViewDraggerDataSource: class {
  /// Return any cell if want to change the cell in drag.
  @objc optional func dragger(_ dragger: TableViewDragger, cellForRowAt indexPath: IndexPath) -> UIView?
  /// Return the indexPath if want to change the indexPath to start drag.
  @objc optional func dragger(_ dragger: TableViewDragger, indexPathForDragAt indexPath: IndexPath) -> IndexPath
}

open class TableViewDragger: NSObject {

}

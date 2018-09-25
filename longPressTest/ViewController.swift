//
//  ViewController.swift
//  longPressTest
//
//  Created by larvata_ios on 2018/9/3.
//  Copyright © 2018年 dishrank. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var xxxTableview: UITableView!

  var tempImage = UIImageView()
  var initPoint = CGPoint()
  var lastCell = UITableViewCell()
  var moveTimer = Timer()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    xxxTableview.delegate = self
    xxxTableview.dataSource = self

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XXXCell
    cell.selectionStyle = .none
    cell.panLabel.text = indexPath.row.description


    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
    gesture.minimumPressDuration = 0.3


    cell.panLabel.addGestureRecognizer(gesture)
    return cell
  }

  @objc func longPress(_ longP: UILongPressGestureRecognizer) {
    let tableViewPoint = longP.location(in: self.xxxTableview) //xxxTableview == pareantView
    let viewPoint = longP.location(in: self.view)

    switch longP.state {
    case .began:
      let longPressView = longP.view as! UILabel
      let longPressViewPoint = longP.location(in: longPressView)

      UIGraphicsBeginImageContextWithOptions(longPressView.bounds.size, false, 0)
      longPressView.layer.render(in: UIGraphicsGetCurrentContext()!)
      let img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      tempImage = UIImageView(image: img)
      tempImage.frame = CGRect(origin: CGPoint.zero, size: longPressView.bounds.size)

      self.view.addSubview(tempImage)

      tempImage.frame.size = CGSize(width: (longPressView.frame.width), height: (longPressView.frame.height))
      tempImage.frame.origin = CGPoint(x: viewPoint.x - longPressViewPoint.x , y: viewPoint.y - longPressViewPoint.y)

      initPoint = viewPoint
    case .changed:
      let cells = xxxTableview.visibleCells.filter { (cell) -> Bool in
        return cell.frame.origin.y < tableViewPoint.y && cell.frame.maxY > tableViewPoint.y
      }
      if cells.count > 0 {
        let cell = cells.first
        if lastCell != cell {
          lastCell.layer.borderWidth = 0
          lastCell = cell!
        }

        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor.black.cgColor
      }

      let vectorX = viewPoint.x - initPoint.x
      let vectorY = viewPoint.y - initPoint.y

      tempImage.center = CGPoint(x: tempImage.center.x + vectorX, y: tempImage.center.y + vectorY)

      initPoint = viewPoint


      let tableviewHeight = xxxTableview.frame.size.height
      var tableviewInitOffset = xxxTableview.contentOffset.y
      let tableviewContentHeight = xxxTableview.contentSize.height



//      if tableviewOffset + 44 >= point.y {
//        print("up")
//      } else if tableviewOffset + tableviewHeight <= point.y {
//        print("down")
//      }

      if (tableviewInitOffset + 44) + (tableviewHeight / 5) >= tableViewPoint.y {
        print("up")
        if !moveTimer.isValid {
          moveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            if self.xxxTableview.contentOffset.y - 5 <= -44 {
              self.xxxTableview.contentOffset.y = -44
            } else {
              self.xxxTableview.contentOffset.y -= 5
            }
          })
        }
      } else if tableviewInitOffset + (tableviewHeight / 5 * 4) <= tableViewPoint.y {
        print("down")
        if !moveTimer.isValid {
          moveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            if self.xxxTableview.contentOffset.y + 5 >= tableviewContentHeight - self.xxxTableview.frame.height {
              self.xxxTableview.contentOffset.y = tableviewContentHeight - self.xxxTableview.frame.height
            } else {
              self.xxxTableview.contentOffset.y += 5
            }
          })
        }
      } else {
        moveTimer.invalidate()
      }


    case .ended:
      moveTimer.invalidate()

      let cells = xxxTableview.visibleCells.filter { (cell) -> Bool in
        return cell.frame.origin.y < tempImage.frame.origin.y && cell.frame.maxY > tempImage.frame.origin.y
      }

      if cells.count > 0 {
        let cell = cells.first
        lastCell.layer.borderWidth = 0
      }
      tempImage.removeFromSuperview()
    default:
      break
    }
  }
}

class XXXCell: UITableViewCell {
  @IBOutlet weak var panLabel: UILabel!
  override func awakeFromNib() {
    
  }
}

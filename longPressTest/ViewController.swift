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
  @IBOutlet weak var testLabel: UILabel!

  var label = UIImageView()
  var initPoint = CGPoint()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    xxxTableview.delegate = self
    xxxTableview.dataSource = self

    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
    gesture.minimumPressDuration = 0.3

    testLabel.addGestureRecognizer(gesture)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
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
    let point = longP.location(in: self.xxxTableview) //xxxTableview == pareantView



    switch longP.state {
    case .began:
      let longPressView = longP.view as! UILabel
      let longPressViewPoint = longP.location(in: longPressView)

      UIGraphicsBeginImageContextWithOptions(longPressView.bounds.size, false, 0)
      longPressView.layer.render(in: UIGraphicsGetCurrentContext()!)
      let img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      label = UIImageView(image: img)
      label.frame = CGRect(origin: CGPoint.zero, size: longPressView.bounds.size)

      xxxTableview.addSubview(label)

      label.frame.size = CGSize(width: (longPressView.frame.width), height: (longPressView.frame.height))
      label.frame.origin = CGPoint(x: point.x - longPressViewPoint.x , y: point.y - longPressViewPoint.y)

      initPoint = point
    case .changed:

      let vectorX = point.x - initPoint.x
      let vectorY = point.y - initPoint.y

      label.center = CGPoint(x: label.center.x + vectorX, y: label.center.y + vectorY)

      initPoint = point

    case .ended:
      let cells = xxxTableview.visibleCells.filter { (cell) -> Bool in
        print(cell.frame.origin.y)
        print(label.frame.origin.y)
        return cell.frame.origin.y < label.frame.origin.y && cell.frame.maxY > label.frame.origin.y
      }
      label.removeFromSuperview()
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

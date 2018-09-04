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
  
  var label = UILabel()
  var initPoint = CGPoint()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    xxxTableview.delegate = self
    xxxTableview.dataSource = self
    
    label.isHidden = true
    xxxTableview.addSubview(label)

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

      label.frame.size = CGSize(width: (longPressView.frame.width), height: (longPressView.frame.height))
      label.frame.origin = CGPoint(x: point.x - longPressViewPoint.x , y: point.y - longPressViewPoint.y)
      label.text = longPressView.text

      if longPressView.backgroundColor == nil {
        label.backgroundColor = .clear
      } else {
        label.backgroundColor = longPressView.backgroundColor
      }

      label.isHidden = false
      initPoint = point
    case .changed:

      let vectorX = point.x - initPoint.x
      let vectorY = point.y - initPoint.y

      label.center = CGPoint(x: label.center.x + vectorX, y: label.center.y + vectorY)

      initPoint = point

    case .ended:
      label.isHidden = true
      let cells = xxxTableview.visibleCells.filter { (cell) -> Bool in
        print(cell.frame.origin.y)
        print(label.frame.origin.y)
        return cell.frame.origin.y < label.frame.origin.y && cell.frame.maxY > label.frame.origin.y
      }

      let cell = cells.first


    default:
      break
    }
  }

  @objc func panFunc(_ pan: UIPanGestureRecognizer) {
    //pan 事件觸發
    var representation = UIView()


    if pan.state == .began {

      let point = pan.location(in: self.xxxTableview) //xxxTableview == pareantView
      let panView = pan.view as! UILabel
      let panViewPoint = pan.location(in: panView)



//      representation.frame = view.convert(representation.frame, from: xxxTableview)
//
//      representation.alpha = 0.7
//
//      let pointOnCanvas = pan.location(in: xxxTableview)
//
//      let offset = CGPoint(x: pointOnCanvas.x - representation.frame.origin.x, y: pointOnCanvas.y - representation.frame.origin.y)
//
//      self.xxxTableview.addSubview(representation)


      label.frame.size = CGSize(width: (panView.frame.width), height: (panView.frame.height))
      label.frame.origin = CGPoint(x: point.x - panViewPoint.x , y: point.y - panViewPoint.y)
      label.text = panView.text

      if panView.backgroundColor == nil {
        label.backgroundColor = .clear
      } else {
        label.backgroundColor = panView.backgroundColor
      }

      label.isHidden = false
    }else if pan.state == .ended {
      label.isHidden = true
      let cells = xxxTableview.visibleCells.filter { (cell) -> Bool in
        print(cell.frame.origin.y)
        print(label.frame.origin.y)
        return cell.frame.origin.y < label.frame.origin.y && cell.frame.maxY > label.frame.origin.y
      }
      
      let cell = cells.first
      
//      print(xxxTableview.indexPath(for: cell!))
    }else if pan.state == .changed {
      let translation = pan.translation(in: self.xxxTableview)
      label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
      pan.setTranslation(CGPoint.zero, in: self.xxxTableview)

//      let translation = pan.translation(in: self.xxxTableview)
//      representation.center = CGPoint(x: representation.center.x + translation.x, y: representation.center.y + translation.y)
//      pan.setTranslation(CGPoint.zero, in: self.xxxTableview)

    }



  }
}

class XXXCell: UITableViewCell {
  @IBOutlet weak var panLabel: UILabel!
  override func awakeFromNib() {
    
  }
}

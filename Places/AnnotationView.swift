/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}


class AnnotationView: ARAnnotationView {
  var titleLabel: UILabel?
  var distanceLabel: UILabel?
  
  var btPlay: UIButton?
  
  
  var delegate: AnnotationViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    loadUI()
  }
  
  func loadUI() {
    titleLabel?.removeFromSuperview()
    distanceLabel?.removeFromSuperview()
    btPlay?.removeFromSuperview()
    
    
    let bgImg = UIImageView(frame: CGRect(x: -60, y: 30, width: 60, height: 60))
    bgImg.image = #imageLiteral(resourceName: "cameraview")
    self.addSubview(bgImg)
    
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30))
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    label.textColor = UIColor.white
    self.addSubview(label)
    self.titleLabel = label
    
    distanceLabel = UILabel(frame: CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20))
    distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
    distanceLabel?.textColor = UIColor.green
    distanceLabel?.font = UIFont.systemFont(ofSize: 12)
    self.addSubview(distanceLabel!)
    
    
    btPlay = UIButton(frame: CGRect(x: 10, y: 50, width: self.frame.size.width, height: 30))
    btPlay?.setTitle("Play", for: .normal)
    btPlay?.setTitleColor(UIColor.black, for: .normal)
    btPlay?.backgroundColor = UIColor.yellow
    self.addSubview(btPlay!)
    
    
    if let annotation = annotation as? Place {
      titleLabel?.text = annotation.placeName
      distanceLabel?.text = String(format: "%.2f m", annotation.distanceFromUser)
      
      
      if annotation.distanceFromUser < 100 {
        btPlay?.isEnabled = true
        btPlay?.setTitle("Play", for: .normal)
        
      
        
      } else {
        btPlay?.isEnabled = false
        btPlay?.setTitle("Come closer", for: .normal)
      }
      
    }
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width, height: 30)
    distanceLabel?.frame = CGRect(x: 10, y: 30, width: self.frame.size.width, height: 20)
    btPlay?.frame = CGRect(x: 10, y: 50, width: self.frame.size.width, height: 30)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    
    
    delegate?.didTouch(annotationView: self)
    
    
    guard let btPlay = btPlay else { return }
    
    if btPlay.isEnabled  {

      //      playVideo()
      
//      delegate?.didTouch(annotationView: self)

    
    } else {
      
        // can't be played yet
      
    }
    
    
  }
  
  
  func playVideo()
  {
    print("play video")
    let url = URL(string: "https://www.youtube.com/watch?v=KHcHWz4iEk0")
    
    UIApplication.shared.open(url!,
                              options: [:], completionHandler: nil)
  }
  
  
}

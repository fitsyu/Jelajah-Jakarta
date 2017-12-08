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

import CoreLocation
import MapKit

import PopupDialog

class ViewController: UIViewController {
  
  fileprivate var places = [Place]()
  fileprivate let locationManager = CLLocationManager()
  @IBOutlet weak var mapView: MKMapView!
  var arViewController: ARViewController!
  var startedLoadingPOIs = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
  }
  
  
  @IBAction func showARController(_ sender: Any) {
    arViewController = ARViewController()
    arViewController.dataSource = self
    arViewController.maxDistance = 0
    arViewController.maxVisibleAnnotations = 30
    arViewController.maxVerticalLevel = 5
    arViewController.headingSmoothingFactor = 0.05
    
    arViewController.trackingManager.userDistanceFilter = 25
    arViewController.trackingManager.reloadDistanceFilter = 75
    arViewController.setAnnotations(places)
    arViewController.uiOptions.debugEnabled = false
    arViewController.uiOptions.closeButtonEnabled = true
    
    arViewController.closeButtonImage = #imageLiteral(resourceName: "btw_black")
    
    
    self.present(arViewController, animated: true, completion: nil)
  }
  
  func showInfoView(forPlace place: Place) {
    let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    arViewController.present(alert, animated: true, completion: nil)
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if locations.count > 0 {
      let location = locations.last!
      if location.horizontalAccuracy < 100 {
        manager.stopUpdatingLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
        
        
        if !startedLoadingPOIs {
          startedLoadingPOIs = true
          
        
//          print("loading pois")
          
          
          let loader = PlacesLoader()

        
//          print("getting nearby parks..")
          loader.getNearbyPlace(location: location, onDone: { json, error in
            
            
//            print(json)
            
            if let reply = json {
              
              
              for rawPlace in reply.arrayValue {
                
                
                let name = rawPlace["name"].stringValue
                let lat = rawPlace["lat"].doubleValue
                let lng = rawPlace["lng"].doubleValue
                
                let videoUrl = rawPlace["link"].stringValue
                
                
                let placeLocation = CLLocation(latitude:  lat,
                                               longitude: lng)
                
                let place = Place(location: placeLocation, reference: videoUrl, name: name, address: "")
                
                self.places.append( place )
                
                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                DispatchQueue.main.async {
                  self.mapView.addAnnotation(annotation)
                }

                
              }
              
              
              
            }
          
          })
          
          
          
          
        }
      }
    }
  }
  
  
  
  @IBAction func popTheVideoBox(_ sender: UIButton)
  {
    startVideo(url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
  }
  
  func startVideo(url: String)
  {
    
    let videoboxVC = storyboard?.instantiateViewController(withIdentifier: "VideoBox") as! EmbeddedVideoPlayer
    
    videoboxVC.videoStringURL = url
    
    let popup = PopupDialog(viewController: videoboxVC,
                            buttonAlignment: .horizontal,
                            transitionStyle: .zoomIn,
                            gestureDismissal: false, completion: nil)
    
    
    let btClose = DefaultButton(title: "Close") {
      
      videoboxVC.stopVideo()
      
      popup.dismiss()
      
    }
    
    popup.addButtons([ btClose ])
    
    UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
    
  }
}

extension ViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
    let annotationView = AnnotationView()
    annotationView.annotation = viewForAnnotation
    annotationView.delegate = self
    annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
    
    return annotationView
  }
}

extension ViewController: AnnotationViewDelegate {
  
  func didTouch(annotationView: AnnotationView) {
    
    let place = annotationView.annotation as? Place
    startVideo(url: place?.reference ?? "")
    
//    if let annotation = annotationView.annotation as? Place {
//      let placesLoader = PlacesLoader()
//      placesLoader.loadDetailInformation(forPlace: annotation) { resultDict, error in
//        
//        if let infoDict = resultDict?.object(forKey: "result") as? NSDictionary {
//          annotation.phoneNumber = infoDict.object(forKey: "formatted_phone_number") as? String
//          annotation.website = infoDict.object(forKey: "website") as? String
//          
//          self.showInfoView(forPlace: annotation)
//        }
//      }
//      
//    }
  }
}


extension UIApplication {
  class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}





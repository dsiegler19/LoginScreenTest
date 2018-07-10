//
//  MapDemoViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/9/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import MapKit

class MapDemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var rangePickerView: UIPickerView!
    
    private let ranges = [1, 5, 10, 20, 50, 100]
    private var selectedRange = 10
    
    private let locationManager = CLLocationManager()
   
    private var rangeCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 1000)
    
    private var initialized = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.rangePickerView.delegate = self
        self.rangePickerView.dataSource = self
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        
        self.rangePickerView.selectRow(2, inComponent: 0, animated: false)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestWhenInUseAuthorization()
            
        }
                
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.initializeMapView()
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        self.initializeMapView()
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if !self.initialized {
            
            self.initializeMapView(userLocationLoaded: true)
            self.initialized = true
            
        }
        
    }
    
    func initializeMapView(userLocationLoaded: Bool = false) {
        
        // This really is two functions, one for pre-loading and one for post-loading, but it is combined into one with a parameter
        if !userLocationLoaded {
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                
                // Trigger the mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) function when it's ready
                mapView.showsUserLocation = true
                
            }
            
        }
        
        else {
            
            self.centerMapOnLocation(location: mapView.userLocation.location!, regionRadius: 1000)
            self.updateMapView()
            
        }
        
    }
    
    func updateMapView() {
        
        // Load in and display the teams within the initial radius
        self.addRadiusCircle(location: self.mapView.userLocation.location!, radiusInMiles: selectedRange)
        self.displayTeamsWithinRadius(userLocation:  self.mapView.userLocation.location!, radiusInMiles: Double(selectedRange))
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Ensure that this annotation is a Team annotation
        guard let annotation = annotation as? TeamAnnotation else { return nil }
        
        // Set this as a simple text annotation
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        // Map views resuse annotations so this checks to ensure the annotation is visible (and thus loaded)
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        }
            
            // If not already on the queue, simply create a new annotation
        else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            // For now the deatil disclosure does nothing, but it can link to a detail page for that team
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        
        return view
        
    }
    
    func displayTeamsWithinRadius(userLocation location: CLLocation, radiusInMiles: Double) {
                
        // Fetch the data from the server
        MapDemoController.shared.getTeamsInRadius(userLocation: location, radiusInMiles: radiusInMiles) { teams in
            
            DispatchQueue.main.async {
                
                if teams != nil {
                    
                    var annotationsToRemove: [MKAnnotation] = []
                    
                    // Check through all the current team annotations and remove those that aren't going to be re-drawn
                    for currentTeamAnnotation in self.mapView.annotations {
                        
                        var inTeams = false
                        
                        for team in teams! {
                            
                            if currentTeamAnnotation.title == team.teamName {
                                
                                inTeams = true
                                break
                                
                            }
                            
                        }
                        
                        if !inTeams {
                            
                            annotationsToRemove.append(currentTeamAnnotation)
                            
                        }
                        
                    }
                    
                    self.mapView.removeAnnotations(annotationsToRemove)
                    
                    // Add in new teams
                    for team in teams! {
                        
                        let teamAnnotation = TeamAnnotation(team: team)
                        
                        // Check to make sure no annotation is added twice
                        var alreadyAdded = false
                        
                        // self.mapView.annotations
                        
                        for annotation in self.mapView.annotations {
                            
                            if annotation.title == team.teamName {
                                
                                alreadyAdded = true
                                break
                                
                            }
                            
                        }
                        
                        if !alreadyAdded {
                            
                            self.mapView.addAnnotation(teamAnnotation)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.ranges.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(self.ranges[row]) Mile\(self.ranges[row] == 1 ? "" : "s")"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Update the map based on the selected range
        selectedRange = ranges[row]
        self.updateMapView()
        
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func addRadiusCircle(location: CLLocation, radiusInMiles: Int){
        
        self.mapView.remove(self.rangeCircle)
        self.rangeCircle = MKCircle(center: location.coordinate, radius: CLLocationDistance(Double(radiusInMiles) * 1609.34))
        self.mapView.add(self.rangeCircle)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0)
            circleRenderer.lineWidth = 1
            
            return circleRenderer
        }
            
        else {
            
            return MKPolylineRenderer()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}

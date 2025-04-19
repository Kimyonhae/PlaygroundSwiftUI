//
//  BackgroundLocation.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/18/25.
//

import SwiftUI
import CoreLocation

struct LocationView: View {
    @StateObject private var locationInfo = LocationManager()
    var body: some View {
        ZStack {
            VStack {
                Text("Speed : \(locationInfo.speed, specifier: "%.2f")")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(locationInfo.speed < 1.0 ? .gray : .green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("latitude : \(locationInfo.latitude, specifier: "%.5f")")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(locationInfo.speed < 1.0 ? .gray : .green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("longitude : \(locationInfo.longitude, specifier: "%.5f")")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(locationInfo.speed < 1.0 ? .gray : .green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text(locationInfo.log)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

#Preview {
    LocationView()
}

class LocationManager: NSObject, ObservableObject {
    private var locationManager: CLLocationManager?
    @Published var speed: Double = 0.0
    @Published var latitude: Double = 37.463737159954015
    @Published var longitude: Double = 126.71542882919312
    @Published var log: String = ""
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 권한 요청
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 권한 로직
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            log = "권한이 거절되었습니다."
        case .notDetermined:
            log = "권한이 요청되지 않았습니다."
        case .restricted:
            log = "권한이 제한되었습니다"
        case .authorizedWhenInUse, .authorizedAlways:
            log = "권한이 허용되었습니다."
        @unknown default:
                log = "알 수 없는 상태입니다"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            self.speed = location.speed
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
}

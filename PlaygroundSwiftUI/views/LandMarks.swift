//
//  LandMarks.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import SwiftUI
import MapKit

struct LandMarks: View {
    @StateObject var location = LocationManager()
    var body: some View {
        VStack {
            MapView(location: location)
                .frame(height: 300)
            circleImage
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                Text("Kim Yong Hae")
                    .font(.title)
                HStack(alignment: .top) {
                    Text("인천광역시 남동구")
                        .font(.subheadline)
                    Spacer()
                    Text("간석동")
                        .font(.subheadline)
                }
            }
            .padding()
            Spacer()
        }
    }
    
    private var circleImage: some View {
        Image("myProfile")
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.white,lineWidth: 4)
            }
            .shadow(radius: 10)
    }
}

#Preview {
    LandMarks()
}


// SwiftUI에서 UIKit 코드 사용 (MapKit 사용)
struct MapView: UIViewRepresentable {
    let location: LocationManager
    func makeUIView(context: Context) -> some MKMapView {
        MKMapView(frame: .zero)
    }
    
    // coordinate는 좌표 , span -> 범위, region 은 맵의 영역
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

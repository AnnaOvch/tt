//
//  MapView.swift
//  TestTask
//
//  Created by Anna Ovchynnykova on 17.10.2022.
//

import SwiftUI
import MapKit

struct MapView<ViewModel>: View  where ViewModel: LocationViewModelProtocol {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var shouldShowPartners = true
    @ObservedObject var locationViewModel: ViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(width: 1, height: Constans.padding)
                title
                toggle
            }.padding(.horizontal, Constans.padding)
            
            mainMap
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .background(Color.white)
        .onAppear {
            locationViewModel.requestPermission()
        }
    }
    
    private var backButton : some View {
        Button(action: {
            mode.wrappedValue.dismiss()
        }) {
            Constans.backButtonImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constans.buttonSize,
                       height: Constans.buttonSize,
                       alignment: .leading)
        }
    }
    
    private var title: some View {
        Text("Doctors and Labs near me")
            .font(.headline)
            .foregroundColor(.black)
    }
    
    private var toggle: some View {
        Toggle(isOn: $shouldShowPartners) {
            Text("Show only partners")
                .font(.body)
                .foregroundColor(.black)
        }
        .toggleStyle(ColoredToggleStyle(Constans.onColor,
                                        Constans.offColor))
    }
    
    @ViewBuilder
    private var mainMap: some View {
        switch locationViewModel.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            map
        case .notDetermined:
            Color.white
        case .denied:
            requestPermission
        case .restricted:
            restrictedPermission
        @unknown default:
            EmptyView()
        }
    }
    
    private var map: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true, annotationItems: locationViewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                            .background(Circle().fill(.blue))
                        Circle()
                            .fill(.white)
                            .frame(width: Constans.pointSize,
                                   height: Constans.pointSize)
                    }.frame(width: Constans.annotationSize,
                            height:  Constans.annotationSize)
                }
            }
            closeButton
        }
    }
    
    private var requestPermission: some View {
        ZStack {
            Color.white
            Text("Please allow location in settings")
                .foregroundColor(.black)
        }
    }
    private var restrictedPermission: some View {
        ZStack {
            Color.white
            Text("Sorry you are not allowed to share location")
                .foregroundColor(.black)
        }
    }
    
    private var closeButton: some View {
        Button("Close") {
            mode.wrappedValue.dismiss()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Color.white)
        .foregroundColor(Color.blue)
        .clipShape(Capsule())
        .offset(x: 0, y: Constans.offsetCloseButton)
    }
}

private enum Constans {
    static let onColor: Color = Color("lightBlue")
    static let offColor: Color = Color("lightGray")
    static let padding: CGFloat = 24
    static let annotationSize: CGFloat = 24
    static let buttonSize: CGFloat = 30
    static let pointSize: CGFloat = 5
    static let offsetCloseButton: CGFloat = -34
    static let backButtonImage: Image = Image("backIcon")
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationViewModel: LocationViewModel())
    }
}

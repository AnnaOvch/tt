//
//  Location.swift
//  TestTask
//
//  Created by Anna Ovchynnykova on 18.10.2022.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

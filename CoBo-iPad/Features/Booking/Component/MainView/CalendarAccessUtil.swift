//
//  CalendarAccessUtil.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import EventKit

let eventStore = EKEventStore()

func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
    switch EKEventStore.authorizationStatus(for: .event) {
    case .notDetermined:
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    case .authorized:
        completion(true, nil)
    case .denied, .restricted:
        completion(false, nil)
    @unknown default:
        completion(false, nil)
    }
}


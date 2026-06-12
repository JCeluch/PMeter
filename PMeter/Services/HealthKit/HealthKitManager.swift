//
//  HealthKitManager.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import Foundation
import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()

    private init() {}

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard isAvailable else {
            completion(false, nil)
            return
        }

        var readTypes = Set<HKObjectType>()
        var shareTypes = Set<HKSampleType>()

        if let menstrualFlowType = HKObjectType.categoryType(forIdentifier: .menstrualFlow) {
            readTypes.insert(menstrualFlowType)
            shareTypes.insert(menstrualFlowType)
        }

        if let cervicalMucusType = HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality) {
            readTypes.insert(cervicalMucusType)
            shareTypes.insert(cervicalMucusType)
        }

        if let basalBodyTemperature = HKObjectType.quantityType(forIdentifier: .basalBodyTemperature) {
            readTypes.insert(basalBodyTemperature)
            shareTypes.insert(basalBodyTemperature)
        }

        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}

//
//  HealthManager.swift
//  kariquewatchthings
//
//  Created by Karique Vera on 11/6/18.
//  Copyright © 2018 com.upc.karique. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    class var sharedInstance: HealthKitManager {
        struct Singleton {
            static let instance = HealthKitManager()
        }
        
        return Singleton.instance
    }
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let distanceCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
    let heartRate = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
    let activeCalories = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
    
    let stepsUnit = HKUnit.count()
    let distanceUnit = HKUnit(from: "mi")
    let heartRateUnit = HKUnit(from: "count/min")
    let activeCaloriesUnit = HKUnit(from: "kcal")
    
}

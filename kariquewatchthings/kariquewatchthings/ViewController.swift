//
//  ViewController.swift
//  kariquewatchthings
//
//  Created by Angel Antonio Santa Cruz Miñano on 11/5/18.
//  Copyright © 2018 com.upc.karique. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    let healthKitManager = HealthKitManager.sharedInstance

    @IBOutlet weak var heartRateValue: UILabel!
    @IBOutlet weak var energyBurnedValue: UILabel!
    @IBOutlet weak var stepsCountValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestHealthKitAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func getHealthKitData(_ sender: UIButton) {
        queryAverageHeartRate()
        queryStepsSum()
        queryActiveCaloriesSum()
    }
    
    func requestHealthKitAuthorization() {
//        if HKHealthStore.isHealthDataAvailable()
//        {
//            let healthKitTypesToRead : Set = [
//                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
//                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
//                HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
//                HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)!,
//                HKObjectType.workoutType()
//            ]
//
//            healthKitStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead, completion: { (success, error) in
//                isEnabled = success
//            })
//        }
        
        //let dataTypesToRead = NSSet(objects: healthKitManager.heartRate!)
        let dataTypesToRead:Set<HKSampleType> = [healthKitManager.heartRate!,healthKitManager.stepsCount!,healthKitManager.activeCalories!]
        healthKitManager.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as NSSet as? Set<HKObjectType>, completion: { [unowned self] (success, error) in
            if success {
                self.queryAverageHeartRate()
                self.queryStepsSum()
                self.queryActiveCaloriesSum()
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    func queryAverageHeartRate() {
        let option = HKStatisticsOptions.discreteAverage
        let startDate = NSDate().dateByRemovingTime()
        let endDate = NSDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date, options: [])
        let statisticsSumQuery = HKStatisticsQuery(quantityType: healthKitManager.heartRate!, quantitySamplePredicate: predicate, options: option) { [unowned self] (query, result, error) in
            if let quantity = result?.averageQuantity() {
                DispatchQueue.main.async {
                    let averageHeartRate = Double(quantity.doubleValue(for: self.healthKitManager.heartRateUnit))
                    self.heartRateValue.text = "\(averageHeartRate)"
                    //self.score = averageHeartRate
                    //self.submitScore()
                }
            }
        }
        healthKitManager.healthStore?.execute(statisticsSumQuery)
    }
    func queryStepsSum() {
        let sumOption = HKStatisticsOptions.cumulativeSum
        let startDate = NSDate().dateByRemovingTime()
        let endDate = NSDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date, options: [])
        let statisticsSumQuery = HKStatisticsQuery(quantityType: healthKitManager.stepsCount!, quantitySamplePredicate: predicate, options: sumOption) { [unowned self] (query, result, error) in
            if (result != nil) {
                if let sumQuantity = result?.sumQuantity() {
                    DispatchQueue.main.async {
                        let numberOfSteps = Int(sumQuantity.doubleValue(for: self.healthKitManager.stepsUnit))
                        self.stepsCountValue.text = "\(numberOfSteps)"
                        //self.score = numberOfSteps
                        //self.submitScore()
                    }
                }
            }
        }
        healthKitManager.healthStore?.execute(statisticsSumQuery)
    }
    func queryActiveCaloriesSum() {
        let sumOption = HKStatisticsOptions.cumulativeSum
        let startDate = NSDate().dateByRemovingTime()
        let endDate = NSDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate as Date, end: endDate as Date, options: [])
        let statisticsSumQuery = HKStatisticsQuery(quantityType: healthKitManager.activeCalories!, quantitySamplePredicate: predicate, options: sumOption) { [unowned self] (query, result, error) in
            if let sumQuantity = result?.sumQuantity() {
                DispatchQueue.main.async {
                    let totalCalories = Double(sumQuantity.doubleValue(for: self.healthKitManager.activeCaloriesUnit))
                    self.energyBurnedValue.text = "\(totalCalories)"
                    //self.score = totalCalories
                    //self.submitScore()
                }
            }
        }
        healthKitManager.healthStore?.execute(statisticsSumQuery)
    }
}

extension NSDate {
    func dateByRemovingTime() -> NSDate {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self as Date)
        return calendar.date(from: components)! as NSDate
    }
}

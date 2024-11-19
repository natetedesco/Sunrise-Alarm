//
//  Archive.swift
//  Sunrise Alarm
//
//  Created by Developer on 11/19/24.
//


//private func scheduleBackgroundTask() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.sunriseAlarm.backgroundTask")
//        request.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 10, to: Date())
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Failed to schedule background task: \(error)")
//        }
//    }
//
//    func handleBackgroundTask(_ task: BGAppRefreshTask) {
//        Task {
//            await updateSunriseTime()
//            if let sunriseTime = sunriseTime {
//                notifications.setAlarm(date: sunriseTime)
//                task.setTaskCompleted(success: true)
//            }
//            scheduleBackgroundTask()
//        }
//    }

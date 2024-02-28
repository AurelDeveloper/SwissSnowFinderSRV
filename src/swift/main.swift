import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var recommendations: [String] = []

    var body: some View {
        List(recommendations, id: \.self) { recommendation in
            Text(recommendation)
        }
        .onReceive(NotificationPublisher()) { output in
            self.recommendations = output
        }
    }
}

class NotificationPublisher: ObservableObject {
    let objectWillChange = PassthroughSubject<[String], Never>()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
        }

        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationPublisher: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let data = response.notification.request.content.userInfo["custom"] as? [String: Any],
           let recommendations = data["recommendations"] as? [String] {
            objectWillChange.send(recommendations)
        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


--------------------------------------------


import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        Text("App is running")
            .onAppear(perform: {
                let url = URL(string: "http://localhost:5000/user")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let user = ["device_id": "12345", "device_model": "iPhone 12", "os_version": "14.4"]
                let jsonData = try! JSONEncoder().encode(user)
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                    } else if let data = data {
                        let str = String(data: data, encoding: .utf8)
                        print("Received data:\n\(str ?? "")")
                    }
                }

                task.resume()
            })
    }
}
//
//  HomeScreen.swift
//  Boss Clinic
//
//  Created by Onqanet on 26/06/26.
//

import SwiftUI


struct HomeScreen: View {
   
   @State var isScheduled: Bool = true
   @State var isTodaySchedule: Bool = true
   @StateObject private var dashboardVM = DashboardViewModel()
   
   @StateObject private var reminderTakenVM = ReminderTakenViewModel()
   @StateObject private var requestRefillVM = RefillRequestViewModel()
   @StateObject private var notificationCountVM = NotificationCountViewModel()
    
   @StateObject private var newsletterVM = NewsletterViewModel()
   @State private var newsletters: [Newsletter] = []
   
   
   @State private var schedules: [TodaySchedule] = []
   @State var nextMedication: NextMedication?
   @State var refillReminder: [RefillReminder] = []
   
   @State private var showSuccessAlert = false
   @State private var successMessage = ""
    
    @State private var notificationCount = 0
   
   @State var showNotificationScreen = false
   @AppStorage("loginUserName") private var loginUserName = "Jhon"
    
    @State private var selectedNewsletter: Newsletter?
    @State private var showNewsletterDetail = false
    
    @State private var showOfflineAlert = false
   
   var body: some View {
       
       ZStack {
           ScrollView(showsIndicators: false) {
               VStack(spacing: 20) {
                   
                   HStack {
                       Text("Hello, \(loginUserName) 👋🏽")
                           .font(.custom("Inter18pt-SemiBold", size: 20))
                           .foregroundColor(Color.white)
                       Spacer()
                       
                       Button {
                           print("Notification tapped")
                           showNotificationScreen = true
                       } label: {
                           ZStack(alignment: .topTrailing) {
                               
                               Image(systemName: "bell")
                                   .font(.system(size: 22))
                                   .foregroundColor(.white)
                               
                               
                               if notificationCount > 0 {

                                   Text("\(notificationCount)")
                                       .font(.system(size: 10, weight: .bold))
                                       .foregroundColor(.white)
                                       .frame(minWidth: 18, minHeight: 18)
                                       .background(Color.red)
                                       .clipShape(Circle())
                                       .offset(x: 6, y: -6)
                               }
                           }
                       }
                   }
                   
                   
                   newsLetterSection   // ← add this line
                   
                   if isScheduled {
                       NextMedicationCardView(
                           receiveNextMedication: nextMedication
                       ) {

                           guard let medication = nextMedication else { return }

                           let formatter = DateFormatter()
                           formatter.dateFormat = "yyyy-MM-dd"

                           let today = formatter.string(from: Date())

                           reminderTakenVM.markReminderAsTaken(
                               medicationID: medication.medicineId,
                               time: medication.time,
                               scheduledDate: today
                           )
                       }
                   } else {
                       NoMedicationCardView()
                   }
                   
                   if isTodaySchedule {
                       TodaysScheduleView(schedules: schedules)
                   } else {
                       EmptyTodayScheduleView()
                   }
                   
                   refillSection
                   
                   Spacer()
                   
               }
               .frame(maxWidth: .infinity)
               .padding()
           }
           .refreshable {
               await refreshDashboard()
           }
           
           // Loader
           if dashboardVM.isLoading || reminderTakenVM.isLoading || requestRefillVM.isLoading || newsletterVM.isLoading {
              // HomeSkeletonScreen()
               MedicationSkeletonScreen()
           }

           
           NavigationLink(
               destination: NotificationListScreen(),
               isActive: $showNotificationScreen
           ) {
               EmptyView()
           }
           .hidden()
           
           
           
           // ✅ moved here, inside the ZStack
               NavigationLink(
                   destination: selectedNewsletter.map { NewsletterDetailScreen(newsletter: $0) },
                   isActive: $showNewsletterDetail
               ) {
                   EmptyView()
               }
               .hidden()
           
       }
       .background(Color.black.ignoresSafeArea())
       .navigationBarBackButtonHidden(true)
       .onAppear {

           dashboardVM.fetchDashboard()
           notificationCountVM.fetchNotificationCount()
       }
       .onChange(of: reminderTakenVM.isOffline) { offline in
           if offline {
               showOfflineAlert = true
           }
       }
       
       .onChange(of: dashboardVM.dashboardResponse) { response in

           guard let response else { return }

           schedules = response.data.todaySchedule
           
           nextMedication = response.data.nextMedication
           
           refillReminder = response.data.refillReminders
           
           if nextMedication == nil  {
               isScheduled = false
           } else {
               isScheduled = true
           }

           if schedules.count == 0 || schedules.isEmpty {
               isTodaySchedule = false
           } else {
               isTodaySchedule = true
           }
       }
       
       .onChange(of: reminderTakenVM.reminderTakenResponse) { response in

           guard let response else { return }

           print(response.message)

           dashboardVM.fetchDashboard()
       }
       
       .onChange(of: reminderTakenVM.errorMessage) { error in

           guard let error else { return }

           print(error)
       }
       
       .onChange(of: requestRefillVM.refillRequestResponse) { response in

           guard let response else { return }

               successMessage = response.message
               showSuccessAlert = true


           dashboardVM.fetchDashboard()
       }
       .onChange(of: notificationCountVM.notificationCountResponse) { response in

           guard let response else { return }

           notificationCount = response.notificationCount
       }
       
       .onChange(of: requestRefillVM.isOffline) { offline in
           if offline {
               showOfflineAlert = true
               // if using a shared alert, consider a dedicated message var, e.g.:
               // offlineAlertMessage = "No internet connection. Your refill request wasn't sent."
           }
       }
       
       .alert("Success", isPresented: $showSuccessAlert) {
           Button("OK", role: .cancel) { }
       } message: {
           Text(successMessage)
       }
       
       .onAppear {
           dashboardVM.fetchDashboard()
           notificationCountVM.fetchNotificationCount()
           newsletterVM.fetchNewsletters()
       }

       .onChange(of: newsletterVM.newsletterResponse) { response in
           guard let response else { return }
           newsletters = response.data?.data ?? []
       }
       .onChange(of: dashboardVM.isOffline) { offline in
           if offline {
               showOfflineAlert = true
           }
       }
       .onChange(of: newsletterVM.isOffline) { offline in
           if offline {
               showOfflineAlert = true
           }
       }
       .onChange(of: notificationCountVM.isOffline) { offline in
           if offline {
               showOfflineAlert = true
           }
       }

       .alert("No Internet Connection", isPresented: $showOfflineAlert) {
           Button("OK", role: .cancel) { }
       } message: {
           Text("Please check your internet connection and try again.")
       }
       
   }
   
   
   
   private var refillSection: some View {
       ForEach(refillReminder) { medication in
           RefillReminderCardView(
               medication: medication,
               onTappedRefill: {
                   //print("Hellow")
                   requestRefillVM.requestRefill(medicationID: medication.id, schedule: "yes")
               },
               
               onTappedNotNow: {
                   requestRefillVM.requestRefill(medicationID: medication.id, schedule: "no")
               }
           )
       }
   }

   /// Bridges the completion-handler-based fetchDashboard() into the
   /// async world .refreshable expects, so the pull-to-refresh spinner
   /// stays visible until the dashboard has actually finished loading.
   @MainActor
   private func refreshDashboard() async {
       await withCheckedContinuation { continuation in

           dashboardVM.fetchDashboard()

           notificationCountVM.fetchNotificationCount()
           
           newsletterVM.fetchNewsletters()

           // dashboardVM.isLoading flips to false once the request
           // completes (success or failure) — poll it briefly rather
           // than requiring a completion closure on fetchDashboard().
           Task {
               while dashboardVM.isLoading {
                   try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
               }
               continuation.resume()
           }
       }
   }
    
    
    private var newsLetterSection: some View {
        Group {
            if !newsletters.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("News Letter")
                        .font(.custom("Inter18pt-SemiBold", size: 16))
                        .foregroundColor(.white)

                    ForEach(newsletters) { newsletter in
                        NewsLetterCardView(newsletter: newsletter) {
                            selectedNewsletter = newsletter
                            showNewsletterDetail = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}



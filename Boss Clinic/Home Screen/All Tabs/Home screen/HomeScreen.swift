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

    // MARK: - Body

    var body: some View {
        decoratedContent
            .homeScreenAlerts(
                showSuccessAlert: $showSuccessAlert,
                showOfflineAlert: $showOfflineAlert,
                successMessage: successMessage
            )
    }


    private var decoratedContent: some View {
        mainContent
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: loadInitialData)
            .modifier(dashboardObservers)
    }

    // MARK: - Layout split into small pieces

    private var mainContent: some View {
        ZStack {
            scrollContent
            loadingOverlay
            navigationLinks
        }
    }

    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HomeHeaderView(
                    userName: loginUserName,
                    notificationCount: notificationCount,
                    onNotificationTapped: showNotifications
                )

                NewsLetterSectionView(newsletters: newsletters, onSelect: selectNewsletter)

                medicationSection

                scheduleSection

                RefillSectionView(
                    refillReminders: refillReminder,
                    onRefillTapped: requestRefill,
                    onNotNowTapped: dismissRefill
                )

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom, 20)
        }
        .refreshable {
            await refreshDashboard()
        }
    }

    @ViewBuilder
    private var medicationSection: some View {
        if isScheduled {
            NextMedicationCardView(
                receiveNextMedication: nextMedication
            ) {
                markNextMedicationAsTaken()
            }
        } else {
            NoMedicationCardView()
        }
    }

    @ViewBuilder
    private var scheduleSection: some View {
        if isTodaySchedule {
            TodaysScheduleView(schedules: schedules)
        } else {
            EmptyTodayScheduleView()
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if isBusy {
            MedicationSkeletonScreen()
        }
    }

    private var isBusy: Bool {
        dashboardVM.isLoading
            || reminderTakenVM.isLoading
            || requestRefillVM.isLoading
            || newsletterVM.isLoading
    }

    @ViewBuilder
    private var navigationLinks: some View {
        HiddenNavigationLink(
            destination: NotificationListScreen(),
            isActive: $showNotificationScreen
        )

        if let selectedNewsletter {
            HiddenNavigationLink(
                destination: NewsletterDetailScreen(newsletter: selectedNewsletter),
                isActive: $showNewsletterDetail
            )
        }
    }

        private var dashboardObservers: DashboardObserversModifier {
        DashboardObserversModifier(
            dashboardVM: dashboardVM,
            reminderTakenVM: reminderTakenVM,
            requestRefillVM: requestRefillVM,
            notificationCountVM: notificationCountVM,
            newsletterVM: newsletterVM,
            onOfflineChange: handleOfflineChange,
            onDashboardResponse: handleDashboardResponse,
            onReminderTakenResponse: handleReminderTakenResponse,
            onReminderError: handleReminderError,
            onRefillResponse: handleRefillResponse,
            onNotificationCountResponse: handleNotificationCountResponse,
            onNewsletterResponse: handleNewsletterResponse
        )
    }

    // MARK: - Simple UI actions

    private func showNotifications() {
        print("Notification tapped")
        showNotificationScreen = true
    }

    private func selectNewsletter(_ newsletter: Newsletter) {
        selectedNewsletter = newsletter
        showNewsletterDetail = true
    }

    private func requestRefill(_ medication: RefillReminder) {
        requestRefillVM.requestRefill(medicationID: medication.id, schedule: "yes")
    }

    private func dismissRefill(_ medication: RefillReminder) {
        requestRefillVM.requestRefill(medicationID: medication.id, schedule: "no")
    }

    private func loadInitialData() {
        dashboardVM.fetchDashboard(pageNo: 0, pageElements: 10)
        notificationCountVM.fetchNotificationCount()
        newsletterVM.fetchNewsletters()
    }

    // MARK: - onChange handlers (named methods, not inline closures)

    private func handleOfflineChange(_ isOffline: Bool) {
        if isOffline { showOfflineAlert = true }
    }

    private func handleDashboardResponse(_ response: DashboardResponse?) {
        guard let response else { return }

        schedules = response.data.todaySchedule ?? []
        nextMedication = response.data.nextMedication
        refillReminder = response.data.refillReminders ?? []

        isScheduled = nextMedication != nil
        isTodaySchedule = !schedules.isEmpty
    }

    private func handleReminderTakenResponse(_ response: MedicationTakenResponse?) {
        guard let response else { return }
        print(response.message)
        dashboardVM.fetchDashboard(pageNo: 0, pageElements: 10)
    }

    private func handleReminderError(_ error: String?) {
        guard let error else { return }
        print(error)
    }

    private func handleRefillResponse(_ response: RefillRequestResponse?) {
        guard let response else { return }
        successMessage = response.message
        showSuccessAlert = true
        dashboardVM.fetchDashboard(pageNo: 0, pageElements: 10)
    }

    private func handleNotificationCountResponse(_ response: NotificationCountResponse?) {
        guard let response else { return }
        notificationCount = response.notificationCount
    }

    private func handleNewsletterResponse(_ response: NewsletterResponse?) {
        guard let response else { return }
        newsletters = response.data?.data ?? []
    }

    private func markNextMedicationAsTaken() {
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

    /// Bridges the completion-handler-based fetchDashboard() into the
    /// async world .refreshable expects, so the pull-to-refresh spinner
    /// stays visible until the dashboard has actually finished loading.
    @MainActor
    private func refreshDashboard() async {
        await withCheckedContinuation { continuation in

            dashboardVM.fetchDashboard(pageNo: 0, pageElements: 10)
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
}



struct RefillSectionView: View {
 
    let refillReminders: [RefillReminder]
    let onRefillTapped: (RefillReminder) -> Void
    let onNotNowTapped: (RefillReminder) -> Void
 
    var body: some View {
        ForEach(refillReminders) { medication in
            RefillReminderCardView(
                medication: medication,
                onTappedRefill: { onRefillTapped(medication) },
                onTappedNotNow: { onNotNowTapped(medication) }
            )
        }
    }
}
 

struct HomeHeaderView: View {
 
    let userName: String
    let notificationCount: Int
    let onNotificationTapped: () -> Void
 
    var body: some View {
        HStack {
            Text("Hello, \(userName) 👋🏽")
                .font(.custom("Inter18pt-SemiBold", size: 20))
                .foregroundColor(.white)
 
            Spacer()
 
            NotificationBellButton(
                count: notificationCount,
                action: onNotificationTapped
            )
        }
    }
}


/// A bell icon button with an optional red badge showing an unread count.
struct NotificationBellButton: View {

    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 22))
                    .foregroundColor(.white)

                if count > 0 {
                    Text(count > 99 ? "99+" : "\(count)")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .frame(minWidth: 20, minHeight: 20)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 6, y: -6)
                }
            }
        }
    }
}
 

struct HiddenNavigationLink<Destination: View>: View {

    let destination: Destination
    @Binding var isActive: Bool

    var body: some View {
        NavigationLink(
            destination: destination,
            isActive: $isActive
        ) {
            EmptyView()
        }
        .hidden()
    }
}



struct NewsLetterSectionView: View {

    let newsletters: [Newsletter]
    let onSelect: (Newsletter) -> Void

    var body: some View {
        if !newsletters.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("News Letter")
                    .font(.custom("Inter18pt-SemiBold", size: 16))
                    .foregroundColor(.white)

                ForEach(newsletters) { newsletter in
                    NewsLetterCardView(newsletter: newsletter) {
                        onSelect(newsletter)
                    }
                }
            }
        }
    }
}


#Preview {
    HomeScreen()
}



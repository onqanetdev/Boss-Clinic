//
//  TodaysScheduleListScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 22/07/26.
//

import SwiftUI


struct TodaysScheduleListScreen: View {

    /// Seed value passed in from HomeScreen so this screen has something
    /// to show immediately. Once DashboardViewModel's own fetch completes,
    /// `schedules` is kept in sync with that response instead.
    let initialSchedules: [TodaySchedule]

    @Environment(\.dismiss) private var dismiss

    @StateObject private var dashboardVM = DashboardViewModel()
    @State private var schedules: [TodaySchedule] = []
    @State private var showOfflineAlert = false

    // MARK: - Pagination state
    private let pageElements = 10
    @State private var currentPage = 0
    @State private var isLoadingMore = false
    @State private var hasMorePages = true

    init(schedules: [TodaySchedule]) {
        self.initialSchedules = schedules
        _schedules = State(initialValue: schedules)
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: loadFirstPage)
            .onChange(of: dashboardVM.dashboardResponse, perform: handleDashboardResponse)
            .onChange(of: dashboardVM.isOffline, perform: handleOfflineChange)
            .alert("No Internet Connection", isPresented: $showOfflineAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please check your internet connection and try again.")
            }
    }

    // MARK: - Layout

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            scheduleList
        }
    }

    private var headerView: some View {
        HStack(spacing: 16) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text("Today's Schedule")
                .font(.custom("Inter24pt-Bold", size: 28))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }

    private var scheduleList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(schedules.indices, id: \.self) { index in
                    scheduleRow(for: schedules[index], at: index)
                }

                if isLoadingMore {
                    loadMoreIndicator
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var loadMoreIndicator: some View {
        HStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))

            Text("Loading more…")
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private func scheduleRow(for schedule: TodaySchedule, at index: Int) -> some View {
        ScheduleRowView(schedule: schedule)
            .padding(.vertical, 14)
            .onAppear { fetchNextPageIfNeeded(currentIndex: index) }

        if index != schedules.count - 1 {
            Divider()
                .background(Color.white.opacity(0.15))
        }
    }

    // MARK: - Data

    private func loadFirstPage() {
        currentPage = 0
        hasMorePages = true
        dashboardVM.dashboardResponse = nil
       // print("📄 [TodaysSchedule] requesting page \(currentPage) (pageElements: \(pageElements))")
        dashboardVM.fetchDashboard(pageNo: currentPage, pageElements: pageElements)
    }

    private func fetchNextPageIfNeeded(currentIndex: Int) {
        let thresholdIndex = schedules.count - 3

        // Log every call so we can see exactly why it does or doesn't
        // proceed — not just the ones that pass the guard.
        //print("🔎 [TodaysSchedule] row \(currentIndex) appeared — threshold: \(thresholdIndex), hasMorePages: \(hasMorePages), isLoadingMore: \(isLoadingMore), vmLoading: \(dashboardVM.isLoading)")

        guard currentIndex >= thresholdIndex,
              hasMorePages,
              !isLoadingMore,
              !dashboardVM.isLoading
        else { return }

        isLoadingMore = true
        currentPage += 1
        dashboardVM.dashboardResponse = nil
        print("📄 [TodaysSchedule] requesting page \(currentPage) (pageElements: \(pageElements))")
        dashboardVM.fetchDashboard(pageNo: currentPage, pageElements: pageElements)
    }

    @MainActor
    private func refreshSchedules() async {
        await withCheckedContinuation { continuation in
            currentPage = 0
            hasMorePages = true
            dashboardVM.dashboardResponse = nil
            dashboardVM.fetchDashboard(pageNo: currentPage, pageElements: pageElements)

            Task {
                while dashboardVM.isLoading {
                    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
                }
                continuation.resume()
            }
        }
    }

    private func handleDashboardResponse(_ response: DashboardResponse?) {
        guard let response else { return }

        isLoadingMore = false

        let newSchedules = response.data.todaySchedule

        //print("✅ [TodaysSchedule] page \(currentPage) returned \(newSchedules.count) item(s): \(newSchedules.map(\.medicineName))")

        if currentPage == 0 {
            schedules = newSchedules
        } else {
            schedules.append(contentsOf: newSchedules)
        }

        hasMorePages = newSchedules.count == pageElements
       // print("➡️ [TodaysSchedule] hasMorePages now \(hasMorePages), total schedules on screen: \(schedules.count)")
    }

    private func handleOfflineChange(_ isOffline: Bool) {
        if isOffline {
            isLoadingMore = false
            showOfflineAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        TodaysScheduleListScreen(schedules: [])
    }
}


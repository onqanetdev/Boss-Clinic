//
//  AddMedicationScreen.swift
//  Boss Clinic
//
//  Created by Faizan Khan on 08/10/26.
//

import SwiftUI

// MARK: - Form Models


struct MedicationTimeEntry: Hashable {
    var hour: Int = 12
    var minute: Int = 0
    var period: String = "AM"

    /// 24-hour "HH:mm" — ready for the API later
    var apiValue: String {
        var h = hour % 12
        if period == "PM" { h += 12 }
        return String(format: "%02d:%02d", h, minute)
    }
}

struct AddMedicationEntry: Identifiable {
    let id = UUID()
    var type = ""
    var dose = ""
    var mg = ""
    var frequency = ""
    var time = MedicationTimeEntry()
    var startDate: Date? = Date()
    var endDate: Date?
    var totalDay = ""
    var takenDayStock = ""

    var remainingStock: Int {
        max((Int(totalDay) ?? 0) - (Int(takenDayStock) ?? 0), 0)
    }

    /// Auto-fills Total Day from Start / End date (inclusive)
    mutating func updateTotalDays() {
        guard let start = startDate, let end = endDate else { return }
        let calendar = Calendar.current
        let s = calendar.startOfDay(for: start)
        let e = calendar.startOfDay(for: end)
        guard e >= s else { return }
        let days = calendar.dateComponents([.day], from: s, to: e).day ?? 0
        totalDay = "\(days + 1)"
    }
}

// MARK: - Static Options (replace with API data later)

private enum MedicationOptions {
    static let frequencies = ["Once Daily", "Twice Daily", "Thrice Daily", "Four Times Daily",
                              "Every 8 Hours", "As Needed", "Weekly"]
}

private struct DatePickerTarget: Identifiable {
    enum Field { case start, end }

    let id = UUID()
    let entryID: UUID
    let field: Field
}

// MARK: - Screen

struct AddMedicationScreen: View {

    @Environment(\.dismiss) private var dismiss

    @State private var entries: [AddMedicationEntry] = [AddMedicationEntry()]

    @State private var datePickerTarget: DatePickerTarget?
    @State private var tempDate = Date()

    @State private var validationMessage = ""
    @State private var showValidationAlert = false

    @StateObject private var medicationTypeVM = MedicationTypeViewModel()
    @State private var showOfflineAlert = false

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                header

                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.horizontal, 20)

                ScrollViewReader { proxy in

                    ScrollView(showsIndicators: false) {

                        VStack(spacing: 16) {

                            ForEach($entries) { $entry in

                                let index = entries.firstIndex(where: { $0.id == entry.id }) ?? 0

                                MedicineFormCard(
                                    entry: $entry,
                                    index: index,
                                    typeOptions: medicationTypeVM.medicationTypes,
                                    isLoadingTypes: medicationTypeVM.isLoading,
                                    canRemove: entries.count > 1,
                                    onRemove: { removeEntry(id: entry.id) },
                                    onPickDate: { field in openDatePicker(for: entry, field: field) }
                                )
                                .id(entry.id)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }

                            addAnotherButton(proxy: proxy)

                            actionButtons
                                .padding(.top, 8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $datePickerTarget) { target in
            datePickerSheet(target)
        }
        .alert("Missing Details", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
        .onAppear {
            if medicationTypeVM.medicationTypes.isEmpty {
                medicationTypeVM.fetchMedicationTypes()
            }
        }
        .onChange(of: medicationTypeVM.isOffline) { offline in
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

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 40, height: 40)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)

            Text("Add Medication")
                .font(.custom("Inter24pt-Bold", size: 23))
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .padding(.horizontal, 20)
    }

    // MARK: - Add Another

    private func addAnotherButton(proxy: ScrollViewProxy) -> some View {
        Button {
            let newEntry = AddMedicationEntry()
            withAnimation(.easeInOut(duration: 0.2)) {
                entries.append(newEntry)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation { proxy.scrollTo(newEntry.id, anchor: .top) }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))

                Text("Add Another Medicine")
                    .font(.custom("Inter18pt-SemiBold", size: 14))
            }
            .foregroundColor(.white.opacity(0.7))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Save / Cancel

    private var actionButtons: some View {
        HStack(spacing: 12) {

            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white)
                    .frame(width: 110, height: 52)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            Button(action: saveAll) {
                Text(entries.count > 1 ? "Save All Medications" : "Save Medication")
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Date Picker Sheet

    private func datePickerSheet(_ target: DatePickerTarget) -> some View {
        VStack(spacing: 0) {

            HStack {
                Button("Cancel") { datePickerTarget = nil }
                    .font(.custom("Inter18pt-Regular", size: 15))
                    .foregroundColor(.white.opacity(0.6))

                Spacer()

                Text(target.field == .start ? "Start Date" : "End Date")
                    .font(.custom("Inter18pt-SemiBold", size: 16))
                    .foregroundColor(.white)

                Spacer()

                Button("Done") { applyDate(target) }
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            DatePicker("", selection: $tempDate, in: dateRange(for: target), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(.white)
                .colorScheme(.dark)
                .padding(.horizontal, 12)

            Spacer(minLength: 0)
        }
        .background(Color(red: 0.11, green: 0.11, blue: 0.11).ignoresSafeArea())
        .presentationDetents([.height(420)])
    }

    private func dateRange(for target: DatePickerTarget) -> PartialRangeFrom<Date> {
        guard target.field == .end,
              let entry = entries.first(where: { $0.id == target.entryID }),
              let start = entry.startDate else {
            return Date.distantPast...
        }
        return Calendar.current.startOfDay(for: start)...
    }

    // MARK: - Actions

    private func openDatePicker(for entry: AddMedicationEntry, field: DatePickerTarget.Field) {
        let current = field == .start ? entry.startDate : entry.endDate
        tempDate = current ?? entry.startDate ?? Date()
        datePickerTarget = DatePickerTarget(entryID: entry.id, field: field)
    }

    private func applyDate(_ target: DatePickerTarget) {
        guard let i = entries.firstIndex(where: { $0.id == target.entryID }) else { return }

        switch target.field {
        case .start:
            entries[i].startDate = tempDate
            // Clear end date if it's now before the start date
            if let end = entries[i].endDate,
               Calendar.current.startOfDay(for: end) < Calendar.current.startOfDay(for: tempDate) {
                entries[i].endDate = nil
                entries[i].totalDay = ""
            }
        case .end:
            entries[i].endDate = tempDate
        }

        entries[i].updateTotalDays()
        datePickerTarget = nil
    }

    private func removeEntry(id: UUID) {
        withAnimation(.easeInOut(duration: 0.2)) {
            entries.removeAll { $0.id == id }
        }
    }

    private func saveAll() {
        for (i, entry) in entries.enumerated() {
            let suffix = entries.count > 1 ? " for Medicine \(i + 1)" : ""

            if entry.type.isEmpty { return fail("Please select a type\(suffix).") }
            if entry.dose.trimmingCharacters(in: .whitespaces).isEmpty { return fail("Please enter a dose\(suffix).") }
            if entry.frequency.isEmpty { return fail("Please select a frequency\(suffix).") }
            if entry.startDate == nil { return fail("Please select a start date\(suffix).") }
            if entry.endDate == nil { return fail("Please select an end date\(suffix).") }
        }

        // TODO: Replace with API call
        for (i, entry) in entries.enumerated() {
            print("📌 Medicine \(i + 1): \(entry.type) | dose \(entry.dose) | \(entry.mg) mg | \(entry.frequency) | \(entry.time.apiValue)")
            print("📌 Total Day: \(entry.totalDay) | Taken: \(entry.takenDayStock) | Remaining: \(entry.remainingStock)")
        }
        print("✅ \(entries.count) medication(s) ready to save")

        dismiss()
    }

    private func fail(_ message: String) {
        validationMessage = message
        showValidationAlert = true
    }
}

// MARK: - Medicine Card

private struct MedicineFormCard: View {

    @Binding var entry: AddMedicationEntry
    let index: Int
    let typeOptions: [MedicationTypeOption]
    let isLoadingTypes: Bool
    let canRemove: Bool
    let onRemove: () -> Void
    let onPickDate: (DatePickerTarget.Field) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Card header
            HStack {
                Text("Medicine \(index + 1)")
                    .font(.custom("Inter18pt-SemiBold", size: 15))
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                if canRemove {
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.red.opacity(0.85))
                            .frame(width: 32, height: 32)
                            .background(Color.red.opacity(0.12))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack(alignment: .top, spacing: 12) {
                FormField("Type") {
                    DropdownField(placeholder: isLoadingTypes ? "Loading..." : "Select Type",
                                  selection: $entry.type,
                                  options: typeOptions.map(\.value),
                                  displayText: { value in
                                      typeOptions.first(where: { $0.value == value })?.label ?? value
                                  })
                    .disabled(isLoadingTypes || typeOptions.isEmpty)
                }
                FormField("Dose") {
                    InputField(placeholder: "e.g. 1", text: $entry.dose, keyboard: .numberPad)
                }
            }

            HStack(alignment: .top, spacing: 12) {
                FormField("Mg") {
                    InputField(placeholder: "e.g. 500", text: $entry.mg, keyboard: .decimalPad)
                }
                FormField("Frequency") {
                    DropdownField(placeholder: "Select frequency",
                                  selection: $entry.frequency,
                                  options: MedicationOptions.frequencies)
                }
            }

            FormField("Time") {
                HStack(spacing: 8) {
                    CompactMenu(title: "\(entry.time.hour)",
                                options: (1...12).map { "\($0)" }) {
                        entry.time.hour = Int($0) ?? 12
                    }

                    Text(":")
                        .font(.custom("Inter18pt-SemiBold", size: 14))
                        .foregroundColor(.white.opacity(0.5))

                    CompactMenu(title: String(format: "%02d", entry.time.minute),
                                options: (0..<60).map { String(format: "%02d", $0) }) {
                        entry.time.minute = Int($0) ?? 0
                    }

                    CompactMenu(title: entry.time.period, options: ["AM", "PM"]) {
                        entry.time.period = $0
                    }

                    Spacer()
                }
            }

            HStack(alignment: .top, spacing: 12) {
                FormField("Start Date") {
                    DateButton(date: entry.startDate) { onPickDate(.start) }
                }
                FormField("End Date") {
                    DateButton(date: entry.endDate) { onPickDate(.end) }
                }
            }

            HStack(alignment: .top, spacing: 12) {
                FormField("Total Day") {
                    InputField(placeholder: "0", text: $entry.totalDay, keyboard: .numberPad)
                }
                FormField("Taken Day Stock") {
                    InputField(placeholder: "0", text: $entry.takenDayStock, keyboard: .numberPad)
                }
            }

            FormField("Remaining Stock") {
                ReadOnlyField(value: "\(entry.remainingStock)")
            }
        }
        .padding(16)
        .background(Color(red: 0.11, green: 0.11, blue: 0.11))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Form Components

private struct FormField<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("Inter18pt-Regular", size: 13))
                .foregroundColor(.gray)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.35)))
            .font(.custom("Inter18pt-Regular", size: 14))
            .foregroundColor(.white)
            .tint(.white)
            .keyboardType(keyboard)
            .formFieldStyle()
    }
}

private struct ReadOnlyField: View {
    let value: String

    var body: some View {
        Text(value)
            .font(.custom("Inter18pt-Regular", size: 14))
            .foregroundColor(.white.opacity(0.6))
            .frame(maxWidth: .infinity, alignment: .leading)
            .formFieldStyle()
    }
}

private struct DropdownField: View {
    let placeholder: String
    @Binding var selection: String
    let options: [String]
    /// Maps a stored value to the text shown (e.g. API value → label)
    var displayText: (String) -> String = { $0 }

    @State private var isOpen = false
    @State private var fieldWidth: CGFloat = 0

    private let rowHeight: CGFloat = 46

    var body: some View {
        // A Button + popover (instead of Menu) keeps the field visible
        // and shows the list just below it.
        Button {
            isOpen = true
        } label: {
            HStack(spacing: 4) {
                Text(selection.isEmpty ? placeholder : displayText(selection))
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .foregroundColor(selection.isEmpty ? .white.opacity(0.35) : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 4)

                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isOpen)
            }
            .formFieldStyle()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(isOpen ? 0.35 : 0), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { fieldWidth = geo.size.width }
                        .onChange(of: geo.size.width) { fieldWidth = $0 }
                }
            )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isOpen, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
            optionsList
                .presentationCompactAdaptation(.popover)
                .presentationBackground(Color(red: 0.15, green: 0.15, blue: 0.15))
        }
    }

    private var optionsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection = option
                        isOpen = false
                    } label: {
                        HStack {
                            Text(displayText(option))
                                .font(.custom(selection == option ? "Inter18pt-SemiBold" : "Inter18pt-Regular", size: 14))
                                .foregroundColor(.white)
                                .lineLimit(1)

                            Spacer()

                            if selection == option {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: rowHeight)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if option != options.last {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
        }
        .frame(width: max(fieldWidth, 180),
               height: min(CGFloat(options.count) * rowHeight, 280))
    }
}

private struct DateButton: View {
    let date: Date?
    let action: () -> Void

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(date.map { Self.formatter.string(from: $0) } ?? "dd/mm/yyyy")
                    .font(.custom("Inter18pt-Regular", size: 14))
                    .foregroundColor(date == nil ? .white.opacity(0.35) : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 4)

                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .formFieldStyle()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct CompactMenu: View {
    let title: String
    let options: [String]
    let onSelect: (String) -> Void

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) { onSelect(option) }
            }
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(.custom("Inter18pt-SemiBold", size: 14))
                    .foregroundColor(.white)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 12)
            .frame(height: 42)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

private extension View {
    func formFieldStyle() -> some View {
        self
            .padding(.horizontal, 14)
            .frame(minHeight: 48)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        AddMedicationScreen()
    }
}


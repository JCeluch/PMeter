//
//  EntryFormView.swift
//  PMeter
//
//  Created by JCeluch on 03/06/2026.
//

import SwiftUI
import SwiftData

struct EntryFormView: View {
    let existingEntry: CycleEntry?
    let initialDate: Date?
    let onSave: ((Date) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var date = Date()
    @State private var bleeding: BleedingLevel = .none
    @State private var mucus: MucusObservation = .none
    @State private var lhTest: LHTestResult = .none
    @State private var hasTemperature = false
    @State private var temperatureWholePart = 36
    @State private var temperatureFractionPart = 50
    @State private var intercourse = false
    @State private var notes = ""
    @State private var mucusAmount = 0
    @State private var breastTenderness = 0
    @State private var cervix: CervixObservation = .none

    @State private var isDatePickerExpanded = false

    @FocusState private var focusedField: Field?

    init(
        existingEntry: CycleEntry? = nil,
        initialDate: Date? = nil,
        onSave: ((Date) -> Void)? = nil
    ) {
        self.existingEntry = existingEntry
        self.initialDate = initialDate
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.CycleForm.dateSection) {
                    Button {
                        focusedField = nil
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDatePickerExpanded.toggle()
                        }
                    } label: {
                        HStack {
                            Text(L10n.CycleForm.observationDate)
                                .foregroundStyle(Color.pmTextPrimary)

                            Spacer()

                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundStyle(Color.pmTextSecondary)

                            Image(systemName: isDatePickerExpanded ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundStyle(Color.pmTextSecondary)
                        }
                    }
                    .buttonStyle(.plain)

                    if isDatePickerExpanded {
                        DatePicker(
                            "",
                            selection: $date,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .onChange(of: date) { _, _ in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isDatePickerExpanded = false
                            }
                        }
                    }
                }

                Section(L10n.CycleForm.observationsSection) {
                    Toggle(L10n.CycleForm.addTemperature, isOn: $hasTemperature)

                    if hasTemperature {
                        HStack {
                            Text(L10n.CycleForm.temperature)
                            Spacer()
                            Text("\(temperatureWholePart),\(String(format: "%02d", temperatureFractionPart))°C")
                                .foregroundStyle(Color.pmTextSecondary)
                        }

                        temperatureWheelPicker
                    }
                    
                    Picker(L10n.CycleForm.bleeding, selection: $bleeding) {
                        ForEach(BleedingLevel.allCases, id: \.self) { option in
                            Text(option.localizationKey).tag(option)
                        }
                    }

                    Picker(L10n.CycleForm.mucus, selection: $mucus) {
                        ForEach(MucusObservation.allCases, id: \.self) { option in
                            Text(option.localizationKey).tag(option)
                        }
                    }
                    
                    Picker(L10n.CycleForm.mucusAmount, selection: $mucusAmount) {
                        ForEach(0...5, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    
                    Picker(L10n.CycleForm.cervix, selection: $cervix) {
                        ForEach(CervixObservation.allCases, id: \.self) { option in
                            Text(option.localizationKey).tag(option)
                        }
                    }
                    
                    Picker(L10n.CycleForm.breastTenderness, selection: $breastTenderness) {
                        ForEach(0...5, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }

                    Picker(L10n.CycleForm.lhTest, selection: $lhTest) {
                        ForEach(LHTestResult.allCases, id: \.self) { option in
                            Text(option.localizationKey).tag(option)
                        }
                    }

                    Toggle(L10n.CycleForm.intercourse, isOn: $intercourse)
                }

                Section(L10n.CycleForm.notesSection) {
                    TextField(L10n.CycleForm.notesPlaceholder, text: $notes, axis: .vertical)
                        .lineLimit(4...8)
                        .focused($focusedField, equals: .notes)
                }
                
                if focusedField != nil {
                    Section {
                        Button(L10n.Common.done) {
                            focusedField = nil
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.pmPrimary)
                    }
                }
            }
            .navigationTitle(existingEntry == nil ? L10n.CycleForm.newEntryTitle : L10n.CycleForm.editEntryTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Common.cancel) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.save) {
                        focusedField = nil
                        saveEntry()
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.Common.done) {
                        focusedField = nil
                    }
                }
            }
            .onAppear {
                loadExistingDataIfNeeded()
            }
        }
    }

    private func loadExistingDataIfNeeded() {
        if let entry = existingEntry {
            date = entry.date
            bleeding = entry.bleeding
            mucus = entry.mucus
            lhTest = entry.lhTest
            intercourse = entry.intercourse
            notes = entry.notes
            cervix = entry.cervix
            mucusAmount = entry.mucusAmount
            breastTenderness = entry.breastTenderness

            if let temperature = entry.temperature {
                hasTemperature = true
                temperatureWholePart = Int(temperature)

                let fractional = Int(round((temperature - Double(temperatureWholePart)) * 100))
                temperatureFractionPart = max(0, min(99, fractional))
            } else {
                hasTemperature = false
                temperatureWholePart = 36
                temperatureFractionPart = 50
            }

            return
        }

        if let initialDate {
            date = initialDate
        }
    }

    private func saveEntry() {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        let normalizedTemperature: Double? = {
            guard hasTemperature else { return nil }
            return Double(temperatureWholePart) + (Double(temperatureFractionPart) / 100.0)
        }()

        if let existingEntry {
            existingEntry.date = normalizedDate
            existingEntry.bleeding = bleeding
            existingEntry.mucus = mucus
            existingEntry.lhTest = lhTest
            existingEntry.temperature = normalizedTemperature
            existingEntry.intercourse = intercourse
            existingEntry.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            existingEntry.cervix = cervix
            existingEntry.mucusAmount = mucusAmount
            existingEntry.breastTenderness = breastTenderness
            existingEntry.touch()
        } else {
            let entry = CycleEntry(
                date: normalizedDate,
                bleeding: bleeding,
                mucus: mucus,
                lhTest: lhTest,
                cervix: cervix,
                mucusAmount: mucusAmount,
                breastTenderness: breastTenderness,
                temperature: normalizedTemperature,
                intercourse: intercourse,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            modelContext.insert(entry)
        }

        onSave?(normalizedDate)
        dismiss()
    }

    private enum Field: Hashable {
        case temperature
        case notes
    }
    
    private var temperatureWheelPicker: some View {
        HStack(spacing: 0) {
            Picker("Stopnie", selection: $temperatureWholePart) {
                ForEach(35...38, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            Text(",")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.pmTextPrimary)

            Picker("Setne", selection: $temperatureFractionPart) {
                ForEach(0...99, id: \.self) { value in
                    Text(String(format: "%02d", value)).tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 160)
    }
}

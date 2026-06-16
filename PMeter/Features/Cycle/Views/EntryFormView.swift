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
    
    // MARK: - State
    @State private var date = Date()
    @State private var isDatePickerExpanded = false

    // Krawienie
    @State private var bleeding: BleedingLevel = .none
    @State private var bleedingColor: BleedingColor = .none
    @State private var intermenstrualSpotting = false

    // Śluz
    @State private var mucusSensation: MucusSensation = .none
    @State private var mucusAppearance: MucusAppearance = .none
    @State private var mucusStretch: MucusStretch = .none
    @State private var mucusVolume: MucusVolume = .none
    @State private var isPeakDay = false

    // Temperatura
    @State private var hasTemperature = false
    @State private var temperatureWholePart = 36
    @State private var temperatureFractionPart = 50
    @State private var temperatureSite: BBTMeasurementSite = .oral
    @State private var bbtDisturbances: Set<BBTDisturbance> = []
    @State private var temperatureExcluded = false

    // Szyjka macicy
    @State private var showCervix = false
    @State private var cervixPosition: CervixPosition = .none
    @State private var cervixFirmness: CervixFirmness = .none
    @State private var cervixOpening: CervixOpening = .none

    // Testy
    @State private var lhTest: LHTestResult = .none
    @State private var progesteroneTestPositive: Bool? = nil

    // Objawy
    @State private var ovulationPainIntensity = 0
    @State private var ovulationPainSide: PainSide = .none
    @State private var breastTenderness = 0
    @State private var menstrualPainIntensity = 0
    
    // Inne
    @State private var intercourse: IntercourseType = .none
    @State private var isBreastfeeding = false
    @State private var mood = 0
    @State private var notes = ""

    @FocusState private var focusedField: Field?

    // MARK: - Init

    init(
        existingEntry: CycleEntry? = nil,
        initialDate: Date? = nil,
        onSave: ((Date) -> Void)? = nil
    ) {
        self.existingEntry = existingEntry
        self.initialDate = initialDate
        self.onSave = onSave
    }
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                dateSection
                bleedingSection
                mucusSection
                temperatureSection
                cervixSection
                testsSection
                symptomsSection
                otherSection
                notesSection
                
                if focusedField != nil {
                    Section {
                        Button (L10n.Common.done) { focusedField = nil }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(Color.pmPrimary)
                    }
                }
            }
            .navigationTitle(existingEntry == nil ? L10n.CycleForm.newEntryTitle : L10n.CycleForm.editEntryTitle)
            .inlineNavigationTitle()
            .scrollDismissesKeyboard(.interactively)
            .platformEditorToolbar {
                Button(L10n.Common.cancel) { dismiss() }
            } trailing: {
                Button(L10n.Common.save) {
                    focusedField = nil
                    saveEntry()
                }
            }
            .iosKeyboardDoneToolbar {
                focusedField = nil
            }
            .onAppear { loadExistingDataIfNeeded() }
        }
    }
    
    // MARK: - Sections
    
    private var dateSection: some View {
        Section(L10n.CycleForm.dateSection) {
            Button {
                focusedField = nil
                withAnimation(.easeInOut(duration: 0.2)) { isDatePickerExpanded.toggle() }
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
                DatePicker("", selection: $date, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .onChange(of: date) { _, _ in
                        withAnimation(.easeInOut(duration: 0.2)) { isDatePickerExpanded = false }
                    }
            }
        }
    }

    private var bleedingSection: some View {
        Section(L10n.CycleForm.bleedingSection) {
            Picker(L10n.CycleForm.bleeding, selection: $bleeding) {
                ForEach(BleedingLevel.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            if bleeding != .none {
                Picker(L10n.CycleForm.bleedingColor, selection: $bleedingColor) {
                    ForEach(BleedingColor.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
                }
            }
            Toggle(L10n.CycleForm.intermenstrualSpotting, isOn: $intermenstrualSpotting)
        }
    }

    private var mucusSection: some View {
        Section {
            Picker(L10n.CycleForm.mucusSensation, selection: $mucusSensation) {
                ForEach(MucusSensation.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            Picker(L10n.CycleForm.mucusAppearance, selection: $mucusAppearance) {
                ForEach(MucusAppearance.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            Picker(L10n.CycleForm.mucusStretch, selection: $mucusStretch) {
                ForEach(MucusStretch.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            Picker(L10n.CycleForm.mucusVolume, selection: $mucusVolume) {
                ForEach(MucusVolume.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            Toggle(L10n.CycleForm.isPeakDay, isOn: $isPeakDay)
        } header: {
            Text(L10n.CycleForm.mucusSection)
                .glossaryInfo("cervical-mucus")
        }
    }

    private var temperatureSection: some View {
        Section {
            Toggle(L10n.CycleForm.addTemperature, isOn: $hasTemperature)

            if hasTemperature {
                HStack {
                    Text(L10n.CycleForm.temperature)
                    Spacer()
                    Text("\(temperatureWholePart),\(String(format: "%02d", temperatureFractionPart))°C")
                        .foregroundStyle(Color.pmTextSecondary)
                }
                temperatureWheelPicker

                Picker(L10n.CycleForm.temperatureSite, selection: $temperatureSite) {
                    ForEach(BBTMeasurementSite.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
                }

//                Toggle(L10n.CycleForm.temperatureExcluded, isOn: $temperatureExcluded)

                if !temperatureExcluded {
                    DisclosureGroup(L10n.CycleForm.bbtDisturbances) {
                        ForEach(BBTDisturbance.allCases, id: \.self) { disturbance in
                            Toggle(disturbance.localizationKey, isOn: Binding(
                                get: { bbtDisturbances.contains(disturbance) },
                                set: { isOn in
                                    if isOn { bbtDisturbances.insert(disturbance) }
                                    else { bbtDisturbances.remove(disturbance) }
                                }
                            ))
                        }
                    }
                }
            }
        } header: {
            Text(L10n.CycleForm.temperatureSection)
                .glossaryInfo("bbt")
        }
    }

    private var cervixSection: some View {
        Section {
            if bleeding != .none {
                Label {
                    Text(L10n.CycleForm.cervixBleedingWarning)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }
            }
            
            Toggle(L10n.CycleForm.cervixSection, isOn: $showCervix)
                .disabled(bleeding != .none)
            
            if showCervix && bleeding == .none {
                Picker(L10n.CycleForm.cervixPosition, selection: $cervixPosition) {
                    ForEach(CervixPosition.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
                }
                Picker(L10n.CycleForm.cervixFirmness, selection: $cervixFirmness) {
                    ForEach(CervixFirmness.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
                }
                Picker(L10n.CycleForm.cervixOpening, selection: $cervixOpening) {
                    ForEach(CervixOpening.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
                }
            }
        } header: {
            Text(L10n.CycleForm.cervixSection)
                .glossaryInfo("cervix")
        }
    }

    private var testsSection: some View {
        Section {
            Picker(L10n.CycleForm.lhTest, selection: $lhTest) {
                ForEach(LHTestResult.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
        } header: {
            Text(L10n.CycleForm.testsSection)
                .glossaryInfo("lh")
        }
    }

    private var symptomsSection: some View {
        Section(L10n.CycleForm.symptomsSection) {
            Picker(L10n.CycleForm.breastTenderness, selection: $breastTenderness) {
                ForEach(0...5, id: \.self) { Text("\($0)").tag($0) }
            }
            Picker(L10n.CycleForm.ovulationPain, selection: $ovulationPainIntensity) {
                ForEach(0...5, id: \.self) { Text("\($0)").tag($0) }
            }
            if ovulationPainIntensity > 0 {
                Picker(L10n.CycleForm.ovulationPainSide, selection: $ovulationPainSide) {
                    ForEach(PainSide.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
            }
            Picker(L10n.CycleForm.menstrualPain, selection: $menstrualPainIntensity) {
                ForEach(0...5, id: \.self) { Text("\($0)").tag($0) }
            }
        }
    }

    private var otherSection: some View {
        Section(L10n.CycleForm.otherSection) {
            Picker(L10n.CycleForm.intercourse, selection: $intercourse) {
                ForEach(IntercourseType.allCases, id: \.self) { Text($0.localizationKey).tag($0) }
            }
            Toggle(L10n.CycleForm.isBreastfeeding, isOn: $isBreastfeeding)
        }
    }

    private var notesSection: some View {
        Section(L10n.CycleForm.notesSection) {
            TextField(L10n.CycleForm.notesPlaceholder, text: $notes, axis: .vertical)
                .lineLimit(4...8)
                .focused($focusedField, equals: .notes)
        }
    }

    // MARK: - Logic

    private func loadExistingDataIfNeeded() {
        if let entry = existingEntry {
            date = entry.date
            
            bleeding = entry.bleeding
            bleedingColor = entry.bleedingColor
            intermenstrualSpotting = entry.intermenstrualSpotting

            mucusSensation = entry.mucusSensation
            mucusAppearance = entry.mucusAppearance
            mucusStretch = entry.mucusStretch
            mucusVolume = entry.mucusVolume
            isPeakDay = entry.isPeakDay

            if let temp = entry.temperature {
                hasTemperature = true
                temperatureWholePart = Int(temp)

                let frac = Int(round((temp - Double(temperatureWholePart)) * 100))
                temperatureFractionPart = max(0, min(99, frac))
            } else {
                hasTemperature = false
                temperatureWholePart = 36
                temperatureFractionPart = 50
            }
            temperatureSite = entry.temperatureSite
            bbtDisturbances = Set(entry.bbtDisturbances)
            temperatureExcluded = entry.temperatureExcluded

            showCervix = entry.cervixPosition != .none
                || entry.cervixFirmness != .none
                || entry.cervixOpening != .none
            cervixPosition = entry.cervixPosition
            cervixFirmness = entry.cervixFirmness
            cervixOpening = entry.cervixOpening

            lhTest = entry.lhTest
            progesteroneTestPositive = entry.progesteroneTestPositive

            ovulationPainIntensity = entry.ovulationPainIntensity
            ovulationPainSide = entry.ovulationPainSide
            breastTenderness = entry.breastTenderness
            menstrualPainIntensity = entry.menstrualPainIntensity

            intercourse = entry.intercourse
            isBreastfeeding = entry.isBreastfeeding
//            mood = entry.mood
            notes = entry.notes
            return
        }

        if let initialDate {
            date = initialDate
        }
    }

    private func saveEntry() {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        let normalizedTemperature: Double? = hasTemperature
            ? Double(temperatureWholePart) + (Double(temperatureFractionPart) / 100.0)
            : nil
        let disturbancesArray = Array(bbtDisturbances)

        if let entry = existingEntry {
            entry.date = normalizedDate

            entry.bleeding = bleeding
            entry.bleedingColor = bleedingColor
            entry.intermenstrualSpotting = intermenstrualSpotting

            entry.mucusSensation = mucusSensation
            entry.mucusAppearance = mucusAppearance
            entry.mucusStretch = mucusStretch
            entry.mucusVolume = mucusVolume
            entry.isPeakDay = isPeakDay

            entry.temperature = normalizedTemperature
            entry.temperatureSite = temperatureSite
            entry.bbtDisturbances = disturbancesArray
            entry.temperatureExcluded = temperatureExcluded

            entry.cervixPosition = showCervix ? cervixPosition : .none
            entry.cervixFirmness = showCervix ? cervixFirmness : .none
            entry.cervixOpening = showCervix ? cervixOpening : .none

            entry.lhTest = lhTest
            entry.progesteroneTestPositive = progesteroneTestPositive

            entry.ovulationPainIntensity = ovulationPainIntensity
            entry.ovulationPainSide = ovulationPainIntensity > 0 ? ovulationPainSide : .none
            entry.breastTenderness = breastTenderness
            entry.menstrualPainIntensity = menstrualPainIntensity

            entry.intercourse = intercourse
            entry.isBreastfeeding = isBreastfeeding
            entry.mood = mood
            entry.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            entry.touch()
        } else {
            let entry = CycleEntry(
                date: normalizedDate,
                bleeding: bleeding,
                bleedingColor: bleedingColor,
                intermenstrualSpotting: intermenstrualSpotting,
                mucusSensation: mucusSensation,
                mucusAppearance: mucusAppearance,
                mucusStretch: mucusStretch,
                mucusVolume: mucusVolume,
                isPeakDay: isPeakDay,
                temperature: normalizedTemperature,
                temperatureSite: temperatureSite,
                bbtDisturbances: disturbancesArray,
                temperatureExcluded: temperatureExcluded,
                cervixPosition: showCervix ? cervixPosition : .none,
                cervixFirmness: showCervix ? cervixFirmness : .none,
                cervixOpening: showCervix ? cervixOpening : .none,
                lhTest: lhTest,
                progesteroneTestPositive: progesteroneTestPositive,
                ovulationPainIntensity: ovulationPainIntensity,
                ovulationPainSide: ovulationPainIntensity > 0 ? ovulationPainSide : .none,
                breastTenderness: breastTenderness,
                menstrualPainIntensity: menstrualPainIntensity,
                intercourse: intercourse,
                isBreastfeeding: isBreastfeeding,
//                mood: mood,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            modelContext.insert(entry)
        }

        onSave?(normalizedDate)
        dismiss()
    }
    
    // MARK: - Helpers
    
    private enum Field: Hashable { case notes }
    
    private var temperatureWheelPicker: some View {
        HStack(spacing: 0) {
            Picker("Stopnie", selection: $temperatureWholePart) {
                ForEach(35...38, id: \.self) { Text("\($0)").tag($0) }
            }
            .platformWheelPickerStyle()
            .frame(maxWidth: .infinity)

            Text(",")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.pmTextPrimary)

            Picker("Setne", selection: $temperatureFractionPart) {
                ForEach(0...99, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
            }
            .platformWheelPickerStyle()
            .frame(maxWidth: .infinity)
        }
        .frame(height: 160)
    }
}

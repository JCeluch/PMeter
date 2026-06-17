//
//  CycleInsightsService.swift
//  PMeter
//
//  Created by JCeluch on 17/06/2026.
//

import Foundation

struct CycleInsight: Identifiable {
    let id = UUID()
    let category: InsightCategory
    let message: String
    let severity: InsightSeverity
}

enum InsightCategory {
    case cycle, luteal, follicular, bbt, mucus, cervix, pain, breastfeeding, intercourse, general
}

enum InsightSeverity {
    case positive   // zielony — wszystko ok
    case neutral    // szary — informacja
    case warning    // pomarańczowy — warto obserwować
    case attention  // czerwony — warto skonsultować
}

enum CycleInsightsService {

    static func insights(from stats: CycleStatistics) -> [CycleInsight] {
        guard stats.cycleCount >= 2 else { return [] }
        var result: [CycleInsight] = []

        result += cycleInsights(stats)
        result += lutealInsights(stats)
        result += follicularInsights(stats)
        result += bbtInsights(stats)
        result += mucusInsights(stats)
        result += painInsights(stats)
        result += breastfeedingInsights(stats)
        result += progressInsights(stats)

        return result
    }

    // MARK: - Cykl

    private static func cycleInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []

        // Regularność
        switch s.regularityScore {
        case 85...:
            r.append(.init(category: .cycle, message: "Twoje cykle są bardzo regularne (odchylenie ±\(formatted(s.cycleVariability)) dni). To dobry znak dla zdrowia hormonalnego.", severity: .positive))
        case 65..<85:
            r.append(.init(category: .cycle, message: "Twoje cykle są umiarkowanie regularne. Odchylenie wynosi ±\(formatted(s.cycleVariability)) dni — mieszcząc się w normie.", severity: .neutral))
        default:
            r.append(.init(category: .cycle, message: "Twoje cykle są nieregularne (odchylenie ±\(formatted(s.cycleVariability)) dni). Duża zmienność może mieć różne przyczyny — stres, zmiana wagi, tarczyca.", severity: .warning))
        }

        // Długość cyklu
        let avg = s.averageCycleLength
        if avg < 21 {
            r.append(.init(category: .cycle, message: "Średnia długość cyklu (\(Int(round(avg))) dni) jest poniżej normy (21–35 dni). Warto omówić to z ginekologiem.", severity: .attention))
        } else if avg > 35 {
            r.append(.init(category: .cycle, message: "Średnia długość cyklu (\(Int(round(avg))) dni) jest powyżej normy (21–35 dni). Może to wskazywać na rzadkie owulacje.", severity: .warning))
        }

        // Trend
        switch s.cycleLengthTrend {
        case .increasing:
            r.append(.init(category: .cycle, message: "Twoje cykle stopniowo się wydłużają (+\(formatted(s.cycleLengthTrendSlope)) dni/cykl). Obserwuj ten trend.", severity: .warning))
        case .decreasing:
            r.append(.init(category: .cycle, message: "Twoje cykle stopniowo się skracają (\(formatted(s.cycleLengthTrendSlope)) dni/cykl). Obserwuj ten trend.", severity: .warning))
        default:
            break
        }

        // Aktywny cykl
        if s.currentCycleIsLate, let current = s.currentCycleDayCount {
            r.append(.init(category: .cycle, message: "Aktualny cykl trwa już \(current) dni, czyli dłużej niż Twoja średnia. Jeśli spodziewasz się miesiączki — poczekaj jeszcze kilka dni.", severity: .warning))
        }

        return r
    }

    // MARK: - Faza lutealna

    private static func lutealInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []
        let avg = s.averageLutealLength
        guard avg > 0 else { return r }

        if avg < 10 {
            r.append(.init(category: .luteal, message: "Średnia faza lutealna wynosi \(Int(round(avg))) dni, co jest poniżej normy (10–16 dni). Krótka faza lutealna może utrudniać zagnieżdżenie zarodka.", severity: .attention))
        } else if avg > 16 {
            r.append(.init(category: .luteal, message: "Średnia faza lutealna (\(Int(round(avg))) dni) jest nieco powyżej typowego zakresu. Może być Twoją normą.", severity: .neutral))
        } else {
            r.append(.init(category: .luteal, message: "Faza lutealna (\(Int(round(avg))) dni) mieści się w normie (10–16 dni).", severity: .positive))
        }

        // Progesteron
        if s.cyclesWithProgesteroneTest > 0 {
            let pct = Int(round(Double(s.cyclesWithConfirmedProgesterone) / Double(s.cyclesWithProgesteroneTest) * 100))
            if pct < 70 {
                r.append(.init(category: .luteal, message: "Wyrzut progesteronu potwierdzony w \(pct)% badanych cykli. Warto omówić to z lekarzem.", severity: .warning))
            } else {
                r.append(.init(category: .luteal, message: "Wyrzut progesteronu potwierdzony w \(pct)% badanych cykli — dobry wynik.", severity: .positive))
            }
        }

        return r
    }

    // MARK: - Faza folikularna

    private static func follicularInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []
        let avg = s.averageFollicularLength
        guard avg > 0 else { return r }

        if avg > 21 {
            r.append(.init(category: .follicular, message: "Średnia faza folikularna wynosi \(Int(round(avg))) dni — owulacja jest późna. Może to być Twoją normą, ale warto monitorować.", severity: .neutral))
        } else if avg < 10 {
            r.append(.init(category: .follicular, message: "Średnia faza folikularna (\(Int(round(avg))) dni) jest krótka. Bardzo wczesna owulacja jest rzadka.", severity: .warning))
        }

        if let peakDay = s.averagePeakDayOfCycle {
            r.append(.init(category: .follicular, message: "Szczytowy dzień śluzu (Peak Day) wypada średnio w dniu \(Int(round(peakDay))) cyklu.", severity: .neutral))
        }

        return r
    }

    // MARK: - BBT

    private static func bbtInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []

        if s.temperatureEntryCount == 0 { return r }

        let consistency = s.bbtConsistency
        if consistency >= 0.85 {
            r.append(.init(category: .bbt, message: "Mierzysz temperaturę regularnie (\(Int(consistency * 100))% dni). Tak wysoka konsekwencja znacznie zwiększa wiarygodność wykrycia owulacji.", severity: .positive))
        } else if consistency >= 0.5 {
            r.append(.init(category: .bbt, message: "Regularność pomiarów BBT wynosi \(Int(consistency * 100))%. Postaraj się mierzyć codziennie dla lepszej dokładności.", severity: .neutral))
        } else {
            r.append(.init(category: .bbt, message: "Regularność pomiarów BBT wynosi tylko \(Int(consistency * 100))%. Nieregularne pomiary utrudniają wykrycie owulacji.", severity: .warning))
        }

        if s.longestBBTStreak > 0 {
            r.append(.init(category: .bbt, message: "Twój rekord to \(s.longestBBTStreak) kolejnych dni z pomiarem temperatury.", severity: .neutral))
        }

        return r
    }

    // MARK: - Śluz

    private static func mucusInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []

        if let mucusDay = s.averageFirstFertileMucusDayOfCycle {
            r.append(.init(category: .mucus, message: "Śluz płodny (przezroczysty/jak białko) pojawia się u Ciebie średnio od dnia \(Int(round(mucusDay))) cyklu.", severity: .neutral))
        }

        return r
    }

    // MARK: - Ból

    private static func painInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []

        if s.averageMenstrualPain >= 4 {
            r.append(.init(category: .pain, message: "Średnia intensywność bólu menstruacyjnego wynosi \(formatted(s.averageMenstrualPain))/5. Silny, nawracający ból warto skonsultować z ginekologiem (możliwa endometrioza lub inne przyczyny).", severity: .attention))
        } else if s.averageMenstrualPain >= 2 {
            r.append(.init(category: .pain, message: "Odczuwasz umiarkowany ból menstruacyjny (\(formatted(s.averageMenstrualPain))/5).", severity: .neutral))
        }

        if s.averageOvulationPain >= 3 {
            r.append(.init(category: .pain, message: "Ból owulacyjny (mittelschmerz) jest u Ciebie wyraźny (\(formatted(s.averageOvulationPain))/5). Może być pomocny przy identyfikacji owulacji.", severity: .neutral))
        }

        return r
    }

    // MARK: - Karmienie piersią

    private static func breastfeedingInsights(_ s: CycleStatistics) -> [CycleInsight] {
        guard s.breastfeedingDaysCount > 0 else { return [] }
        return [.init(category: .breastfeeding, message: "Odnotowano \(s.breastfeedingDaysCount) dni z karmieniem piersią. Pamiętaj, że laktacja może wpływać na regularność cykli i opóźniać owulację (metoda LAM).", severity: .neutral)]
    }

    // MARK: - Postęp / zachęta

    private static func progressInsights(_ s: CycleStatistics) -> [CycleInsight] {
        var r: [CycleInsight] = []

        if s.cycleCount >= 6 {
            r.append(.init(category: .general, message: "Masz już \(s.cycleCount) pełnych cykli w bazie — to wystarczająco dużo do wiarygodnych statystyk.", severity: .positive))
        } else if s.cycleCount >= 3 {
            r.append(.init(category: .general, message: "Masz \(s.cycleCount) cykle. Im więcej danych, tym trafniejsze predykcje — kontynuuj obserwacje!", severity: .neutral))
        }

        let ovPct = s.cyclesWithOvulation + s.cyclesWithoutOvulation > 0
            ? Int(round(Double(s.cyclesWithOvulation) / Double(s.cyclesWithOvulation + s.cyclesWithoutOvulation) * 100))
            : 0
        if ovPct >= 80 {
            r.append(.init(category: .general, message: "Owulacja wykryta w \(ovPct)% cykli — bardzo dobra wykrywalność.", severity: .positive))
        } else if ovPct > 0 {
            r.append(.init(category: .general, message: "Owulacja wykryta w \(ovPct)% cykli. Regularny pomiar BBT i obserwacja śluzu poprawią ten wskaźnik.", severity: .neutral))
        }

        return r
    }

    // MARK: - Helpers

    private static func formatted(_ value: Double) -> String {
        String(format: "%.1f", value)
    }
}

import Foundation

final class NameDayService {
    static let shared = NameDayService()
    private init() {}

    // MARK: – Czech name day calendar (ČSN)
    // Tuple: (month, day, [names])
    // Verifikuj data oproti: https://www.svatky.centrum.cz
    private let calendar: [(month: Int, day: Int, names: [String])] = [
        // LEDEN
        (1, 2,  ["Karina"]),
        (1, 3,  ["Radmila"]),
        (1, 4,  ["Diana"]),
        (1, 5,  ["Dalimil"]),
        (1, 6,  ["Kašpar", "Melichar", "Baltazar"]),
        (1, 7,  ["Vilma"]),
        (1, 8,  ["Čestmír"]),
        (1, 9,  ["Vladan"]),
        (1, 10, ["Vilém"]),
        (1, 11, ["Bohdana"]),
        (1, 12, ["Pravoslav"]),
        (1, 13, ["Edita"]),
        (1, 14, ["Radovan"]),
        (1, 15, ["Alice"]),
        (1, 16, ["Ctirad"]),
        (1, 17, ["Drahoslav"]),
        (1, 18, ["Vladislava"]),
        (1, 19, ["Doubravka"]),
        (1, 20, ["Ilona"]),
        (1, 21, ["Běla"]),
        (1, 22, ["Slavomír"]),
        (1, 23, ["Zdeněk", "Zdena"]),
        (1, 24, ["Milena"]),
        (1, 25, ["Miloš"]),
        (1, 26, ["Zora"]),
        (1, 27, ["Ingrid"]),
        (1, 28, ["Otýlie"]),
        (1, 29, ["Zdislava"]),
        (1, 30, ["Robin"]),
        (1, 31, ["Marika"]),
        // ÚNOR
        (2, 1,  ["Hynek"]),
        (2, 2,  ["Nela"]),
        (2, 3,  ["Blažej"]),
        (2, 4,  ["Jarmila"]),
        (2, 5,  ["Dobromila"]),
        (2, 6,  ["Vanda"]),
        (2, 7,  ["Veronika"]),
        (2, 8,  ["Milada"]),
        (2, 9,  ["Apolena"]),
        (2, 10, ["Mojmír"]),
        (2, 11, ["Dezider"]),
        (2, 12, ["Slavěna"]),
        (2, 13, ["Věnceslava"]),
        (2, 14, ["Valentýn"]),
        (2, 15, ["Jiřina"]),
        (2, 16, ["Ljuba"]),
        (2, 17, ["Miloslava"]),
        (2, 18, ["Gizela"]),
        (2, 19, ["Vlastimil"]),
        (2, 20, ["Oldřich"]),
        (2, 21, ["Lenka"]),
        (2, 22, ["Isabela"]),
        (2, 23, ["Svatopluk"]),
        (2, 24, ["Matěj"]),
        (2, 25, ["Liliana"]),
        (2, 26, ["Dorota"]),
        (2, 27, ["Alexandr"]),
        (2, 28, ["Lumír"]),
        (2, 29, ["Horymír"]),
        // BŘEZEN
        (3, 1,  ["Bedřich"]),
        (3, 2,  ["Anežka"]),
        (3, 3,  ["Kamil"]),
        (3, 4,  ["Stela"]),
        (3, 5,  ["Kazimír"]),
        (3, 6,  ["Miroslav"]),
        (3, 7,  ["Tomáš"]),
        (3, 8,  ["Gabriela"]),
        (3, 9,  ["Františka"]),
        (3, 10, ["Viktorie"]),
        (3, 11, ["Anděla"]),
        (3, 12, ["Řehoř"]),
        (3, 13, ["Růžena"]),
        (3, 14, ["Matylda"]),
        (3, 15, ["Ida"]),
        (3, 16, ["Elena"]),
        (3, 17, ["Vlastimila"]),
        (3, 18, ["Eduard"]),
        (3, 19, ["Josef"]),
        (3, 20, ["Světlana"]),
        (3, 21, ["Radek"]),
        (3, 22, ["Leona"]),
        (3, 23, ["Ivona"]),
        (3, 24, ["Gabriel"]),
        (3, 25, ["Marián"]),
        (3, 26, ["Emanuel"]),
        (3, 27, ["Dita"]),
        (3, 28, ["Soňa"]),
        (3, 29, ["Taťána"]),
        (3, 30, ["Arnošt"]),
        (3, 31, ["Kvido"]),
        // DUBEN
        (4, 1,  ["Hugo"]),
        (4, 2,  ["Erika"]),
        (4, 3,  ["Richard"]),
        (4, 4,  ["Ivana"]),
        (4, 5,  ["Miroslava"]),
        (4, 6,  ["Vendula"]),
        (4, 7,  ["Hermína"]),
        (4, 8,  ["Ema"]),
        (4, 9,  ["Dušan"]),
        (4, 10, ["Darja"]),
        (4, 11, ["Izabela"]),
        (4, 12, ["Julius"]),
        (4, 13, ["Aleš"]),
        (4, 14, ["Vincenc"]),
        (4, 15, ["Anastázie"]),
        (4, 16, ["Irena"]),
        (4, 17, ["Rudolf"]),
        (4, 18, ["Valérie"]),
        (4, 19, ["Rostislav"]),
        (4, 20, ["Marcela"]),
        (4, 21, ["Alexandra"]),
        (4, 22, ["Evženie"]),
        (4, 23, ["Vojtěch"]),
        (4, 24, ["Jiří"]),
        (4, 25, ["Marek"]),
        (4, 26, ["Oto"]),
        (4, 27, ["Jaroslava"]),
        (4, 28, ["Vlastislav"]),
        (4, 29, ["Robert"]),
        (4, 30, ["Blahoslav"]),
        // KVĚTEN
        (5, 2,  ["Zikmund"]),
        (5, 3,  ["Alexej"]),
        (5, 4,  ["Květoslav"]),
        (5, 5,  ["Klaudie"]),
        (5, 6,  ["Radoslav"]),
        (5, 7,  ["Stanislav"]),
        (5, 9,  ["Ctibor"]),
        (5, 10, ["Blažena"]),
        (5, 11, ["Svatava"]),
        (5, 12, ["Pankrác"]),
        (5, 13, ["Servác"]),
        (5, 14, ["Bonifác"]),
        (5, 15, ["Žofie"]),
        (5, 16, ["Přemysl"]),
        (5, 17, ["Aneta"]),
        (5, 18, ["Nataša"]),
        (5, 19, ["Ivo"]),
        (5, 20, ["Zbyněk"]),
        (5, 21, ["Monika"]),
        (5, 22, ["Emílie"]),
        (5, 23, ["Vladimír"]),
        (5, 24, ["Jana", "Jan"]),
        (5, 25, ["Viola"]),
        (5, 26, ["Filip"]),
        (5, 27, ["Valdemar"]),
        (5, 28, ["Vilma"]),
        (5, 29, ["Maxmilián"]),
        (5, 30, ["Ferdinand"]),
        (5, 31, ["Petronela"]),
        // ČERVEN
        (6, 1,  ["Laura"]),
        (6, 2,  ["Jarmil"]),
        (6, 3,  ["Tamara"]),
        (6, 4,  ["Dalibor"]),
        (6, 5,  ["Dobroslav"]),
        (6, 6,  ["Norbert"]),
        (6, 7,  ["Iveta"]),
        (6, 8,  ["Medard"]),
        (6, 9,  ["Stanislava"]),
        (6, 10, ["Bohdan"]),
        (6, 11, ["Bruno"]),
        (6, 12, ["Antonie"]),
        (6, 13, ["Antonín"]),
        (6, 14, ["Roland"]),
        (6, 15, ["Vít"]),
        (6, 16, ["Zbyslava"]),
        (6, 17, ["Adolf"]),
        (6, 18, ["Milan"]),
        (6, 19, ["Leoš"]),
        (6, 20, ["Květa"]),
        (6, 21, ["Alois"]),
        (6, 22, ["Pavlína"]),
        (6, 23, ["Zdeňka"]),
        (6, 24, ["Jan"]),
        (6, 25, ["Ivan"]),
        (6, 26, ["Adriana"]),
        (6, 27, ["Ladislav"]),
        (6, 28, ["Lubomír"]),
        (6, 29, ["Petr", "Pavel"]),
        (6, 30, ["Šárka"]),
        // ČERVENEC
        (7, 1,  ["Jaroslav"]),
        (7, 2,  ["Patricie"]),
        (7, 3,  ["Radomír"]),
        (7, 4,  ["Prokop"]),
        (7, 5,  ["Cyril", "Metoděj"]),
        (7, 6,  ["Jitka"]),
        (7, 7,  ["Bohuslava"]),
        (7, 8,  ["Nora"]),
        (7, 9,  ["Drahomíra"]),
        (7, 10, ["Libuše"]),
        (7, 11, ["Olga"]),
        (7, 12, ["Bořek"]),
        (7, 13, ["Markéta"]),
        (7, 14, ["Karolína"]),
        (7, 15, ["Jindřich"]),
        (7, 16, ["Luboš"]),
        (7, 17, ["Martina"]),
        (7, 18, ["Drahomír"]),
        (7, 19, ["Čeněk"]),
        (7, 20, ["Ilja"]),
        (7, 21, ["Vítězslav"]),
        (7, 22, ["Magdaléna"]),
        (7, 23, ["Libor"]),
        (7, 24, ["Kristýna"]),
        (7, 25, ["Jakub"]),
        (7, 26, ["Anna"]),
        (7, 27, ["Věroslav"]),
        (7, 28, ["Viktor"]),
        (7, 29, ["Marta"]),
        (7, 30, ["Bořivoj"]),
        (7, 31, ["Ignác"]),
        // SRPEN
        (8, 1,  ["Oskar"]),
        (8, 2,  ["Gustav"]),
        (8, 3,  ["Miluše"]),
        (8, 4,  ["Dominik"]),
        (8, 5,  ["Kristián"]),
        (8, 6,  ["Oldřiška"]),
        (8, 7,  ["Lada"]),
        (8, 8,  ["Soběslav"]),
        (8, 9,  ["Roman"]),
        (8, 10, ["Vavřinec", "Vavřín"]),
        (8, 11, ["Zuzana"]),
        (8, 12, ["Klára"]),
        (8, 13, ["Alena"]),
        (8, 14, ["Alan"]),
        (8, 15, ["Hana", "Marie"]),
        (8, 16, ["Jáchym"]),
        (8, 17, ["Štěpánka"]),
        (8, 18, ["Helena"]),
        (8, 19, ["Ludvík"]),
        (8, 20, ["Bernard"]),
        (8, 21, ["Johana"]),
        (8, 22, ["Bohuslav"]),
        (8, 23, ["Sandra"]),
        (8, 24, ["Bartoloměj"]),
        (8, 25, ["Radim"]),
        (8, 26, ["Luděk"]),
        (8, 27, ["Cesarina"]),
        (8, 28, ["Augustýn"]),
        (8, 29, ["Evelína"]),
        (8, 30, ["Vladěna"]),
        (8, 31, ["Pavlína"]),
        // ZÁŘÍ
        (9, 1,  ["Linda"]),
        (9, 2,  ["Adéla"]),
        (9, 3,  ["Bronislav"]),
        (9, 4,  ["Jindřiška"]),
        (9, 5,  ["Boris"]),
        (9, 6,  ["Boleslav"]),
        (9, 7,  ["Regína"]),
        (9, 8,  ["Mariana"]),
        (9, 9,  ["Daniela"]),
        (9, 10, ["Irma"]),
        (9, 11, ["Denisa"]),
        (9, 12, ["Marie"]),
        (9, 13, ["Lubor"]),
        (9, 14, ["Radka"]),
        (9, 15, ["Jolana"]),
        (9, 16, ["Ludmila"]),
        (9, 17, ["Naděžda"]),
        (9, 18, ["Kryštof"]),
        (9, 19, ["Zita"]),
        (9, 20, ["Oleg"]),
        (9, 21, ["Matouš"]),
        (9, 22, ["Darina"]),
        (9, 23, ["Bořek"]),
        (9, 24, ["Jaromír"]),
        (9, 25, ["Zlata"]),
        (9, 26, ["Andrea"]),
        (9, 27, ["Jonáš"]),
        (9, 28, ["Václav"]),
        (9, 29, ["Michal"]),
        (9, 30, ["Jeroným"]),
        // ŘÍJEN
        (10, 1,  ["Igor"]),
        (10, 2,  ["Olívie"]),
        (10, 3,  ["Bohumila"]),
        (10, 4,  ["František"]),
        (10, 5,  ["Eliška"]),
        (10, 6,  ["Hanuš"]),
        (10, 7,  ["Justýna"]),
        (10, 8,  ["Věra"]),
        (10, 9,  ["Štefan"]),
        (10, 10, ["Marina"]),
        (10, 11, ["Andrej"]),
        (10, 12, ["Marcel"]),
        (10, 13, ["Renáta"]),
        (10, 14, ["Agáta"]),
        (10, 15, ["Tereza"]),
        (10, 16, ["Havel"]),
        (10, 17, ["Hedvika"]),
        (10, 18, ["Lukáš"]),
        (10, 19, ["Michaela"]),
        (10, 20, ["Vendelín"]),
        (10, 21, ["Brigita"]),
        (10, 22, ["Sabina"]),
        (10, 23, ["Teodor"]),
        (10, 24, ["Nina"]),
        (10, 25, ["Beáta"]),
        (10, 26, ["Erik"]),
        (10, 27, ["Šarlota"]),
        (10, 29, ["Silvie"]),
        (10, 30, ["Tadeáš"]),
        (10, 31, ["Štěpánka"]),
        // LISTOPAD
        (11, 1,  ["Felix"]),
        (11, 3,  ["Hubert"]),
        (11, 4,  ["Karel"]),
        (11, 5,  ["Miriam"]),
        (11, 6,  ["Libuše"]),
        (11, 7,  ["Saskie"]),
        (11, 8,  ["Bohumír"]),
        (11, 9,  ["Bohdan"]),
        (11, 10, ["Evžen"]),
        (11, 11, ["Martin"]),
        (11, 12, ["Benedikt"]),
        (11, 13, ["Tibor"]),
        (11, 14, ["Sáva"]),
        (11, 15, ["Leopold"]),
        (11, 16, ["Otmar"]),
        (11, 18, ["Romana"]),
        (11, 19, ["Alžběta"]),
        (11, 20, ["Nikola"]),
        (11, 21, ["Albert"]),
        (11, 22, ["Cecílie"]),
        (11, 23, ["Klement"]),
        (11, 24, ["Emílie"]),
        (11, 25, ["Kateřina"]),
        (11, 26, ["Artur"]),
        (11, 27, ["Xenie"]),
        (11, 28, ["René"]),
        (11, 29, ["Zina"]),
        (11, 30, ["Ondřej"]),
        // PROSINEC
        (12, 1,  ["Iva"]),
        (12, 2,  ["Blanka"]),
        (12, 3,  ["Svatoslav"]),
        (12, 4,  ["Barbora"]),
        (12, 5,  ["Jitka"]),
        (12, 6,  ["Mikuláš"]),
        (12, 7,  ["Ambrož"]),
        (12, 8,  ["Marta"]),
        (12, 9,  ["Vratislav"]),
        (12, 10, ["Julie"]),
        (12, 11, ["Dana"]),
        (12, 12, ["Simona"]),
        (12, 13, ["Lucie"]),
        (12, 14, ["Lýdie"]),
        (12, 15, ["Radana"]),
        (12, 16, ["Albína"]),
        (12, 17, ["Daniel"]),
        (12, 18, ["Miloslav"]),
        (12, 19, ["Ester"]),
        (12, 20, ["Dagmar"]),
        (12, 21, ["Natálie", "Tomáš"]),
        (12, 22, ["Šimon"]),
        (12, 23, ["Vlasta"]),
        (12, 24, ["Adam", "Eva"]),
        (12, 25, ["Božena"]),
        (12, 26, ["Štěpán"]),
        (12, 27, ["Žaneta"]),
        (12, 28, ["Bohumila"]),
        (12, 29, ["Judita"]),
        (12, 30, ["David"]),
        (12, 31, ["Silvestr"]),
    ]

    // MARK: – Common aliases (přezdívky → kanonické jméno)
    private let aliases: [String: String] = [
        // Jan / Jana
        "honza": "jan",
        "johnny": "jan",
        "jan": "jan",
        "janka": "jana",
        "jana": "jana",
        // Josef
        "pepa": "josef",
        "pepík": "josef",
        "pepička": "josef",
        "jožka": "josef",
        // Kateřina
        "kačka": "kateřina",
        "katka": "kateřina",
        "káťa": "kateřina",
        "kateřina": "kateřina",
        // Antonín
        "toník": "antonín",
        "tonda": "antonín",
        "antonín": "antonín",
        // Marie
        "maruška": "marie",
        "mařenka": "marie",
        "máňa": "marie",
        // Anna
        "anička": "anna",
        "anulka": "anna",
        "aňa": "anna",
        "andulka": "anna",
        // Andrea
        "andy": "andrea",
        // Barbora
        "bára": "barbora",
        "barča": "barbora",
        // Lucie
        "lucka": "lucie",
        "lucinka": "lucie",
        // Jakub
        "kuba": "jakub",
        "jakub": "jakub",
        // Michal
        "míša": "michal",
        "michal": "michal",
        // Zuzana
        "zuzka": "zuzana",
        "zuza": "zuzana",
        "zuzanka": "zuzana",
        // Tereza
        "terka": "tereza",
        "terezka": "tereza",
        // Jitka
        "jitička": "jitka",
        "jitka": "jitka",
        // Ludmila
        "lída": "ludmila",
        "ludmila": "ludmila",
        // Magdaléna
        "magda": "magdaléna",
        "magduška": "magdaléna",
        // Pavel / Pavlína
        "pavlík": "pavel",
        "pavla": "pavlína",
        "pája": "pavlína",
        // Tomáš
        "tomík": "tomáš",
        "tomáš": "tomáš",
        // Ondřej
        "ondra": "ondřej",
        // Lukáš
        "lukas": "lukáš",
        "lukáš": "lukáš",
        // Václav
        "vašek": "václav",
        "venca": "václav",
        "václav": "václav",
        // Jiří
        "jirka": "jiří",
        "jiří": "jiří",
        // Miroslav / Miroslava  ← klíčové!
        "mirek": "miroslav",
        "miroslav": "miroslav",
        "mirka": "miroslava",   // Mirka = Miroslava (ženské)
        "miroslava": "miroslava",
        // Vendula
        "vendulka": "vendula",  // Vendulka = Vendula
        "vendula": "vendula",
        // Zdeněk / Zdena
        "zdenda": "zdeněk",
        "zdeněk": "zdeněk",
        "zdena": "zdena",
        // Stanislav
        "standa": "stanislav",
        "stáňa": "stanislav",
        "stanislav": "stanislav",
        // Ladislav
        "láďa": "ladislav",
        "ladislav": "ladislav",
        // Hana
        "hanka": "hana",
        "hanička": "hana",
        "hana": "hana",
        // Alena
        "alenka": "alena",
        "alena": "alena",
        // Irena
        "irenka": "irena",
        // Eva
        "evča": "eva",
        "eva": "eva",
        // Monika
        "monička": "monika",
        "monika": "monika",
        // Ivana
        "ivanka": "ivana",
        "ivana": "ivana",
        // Jarmila
        "jaruška": "jarmila",
        "jarmila": "jarmila",
        // Karolína
        "karolínka": "karolína",
        "karolína": "karolína",
        // Kristýna
        "kristýnka": "kristýna",
        "kristýna": "kristýna",
        // Adéla
        "adélka": "adéla",
        "adéla": "adéla",
        // Linda
        "lindinka": "linda",
        "linda": "linda",
        // Naděžda
        "naďa": "naděžda",
        "nadia": "naděžda",
        "naděžda": "naděžda",
        // Nikola
        "nikolka": "nikola",
        "nikola": "nikola",
        // Marcela
        "marcelka": "marcela",
        "marcela": "marcela",
        // Aneta
        "anetka": "aneta",
        "aneta": "aneta",
        // ostatní jednoduché
        "nela": "nela",
        "martina": "martina",
        "marek": "marek",
        "olga": "olga",
        "lenka": "lenka",
        "vanda": "vanda",
        "vlasta": "vlasta",
        "petr": "petr",
        "petra": "petra",
        "pavel": "pavel",
        "pavlína": "pavlína",
        "leoš": "leoš",
        "milan": "milan",
        "lada": "lada",
        "filip": "filip",
        "david": "david",
        "daniel": "daniel",
        "adam": "adam",
        "evžen": "evžen",
        "radek": "radek",
        "radim": "radim",
        "martin": "martin",
    ]

    // MARK: – Lookup

    func nameDay(for name: String) -> (month: Int, day: Int)? {
        let normalized = normalize(name)

        // Direct match
        for entry in calendar {
            for entryName in entry.names {
                if normalize(entryName) == normalized {
                    return (entry.month, entry.day)
                }
            }
        }

        // Alias lookup
        if let canonical = aliases[normalized] {
            for entry in calendar {
                for entryName in entry.names {
                    if normalize(entryName) == canonical {
                        return (entry.month, entry.day)
                    }
                }
            }
        }
        return nil
    }

    /// Returns names for any given month+day.
    func names(forMonth month: Int, day: Int) -> [String] {
        calendar.first(where: { $0.month == month && $0.day == day })?.names ?? []
    }

    /// Returns names that have a name day today.
    func todaysNames() -> [String] {
        let cal = Foundation.Calendar.current
        let now = Date()
        let month = cal.component(.month, from: now)
        let day = cal.component(.day, from: now)
        return calendar.first(where: { $0.month == month && $0.day == day })?.names ?? []
    }

    /// Returns names that have a name day tomorrow.
    func tomorrowsNames() -> [String] {
        let cal = Foundation.Calendar.current
        let tomorrow = cal.date(byAdding: .day, value: 1, to: Date())!
        let month = cal.component(.month, from: tomorrow)
        let day = cal.component(.day, from: tomorrow)
        return calendar.first(where: { $0.month == month && $0.day == day })?.names ?? []
    }

    func nextOccurrence(month: Int, day: Int) -> Date {
        var cal = Foundation.Calendar.current
        cal.locale = Locale(identifier: "cs_CZ")
        let now = Date()
        var components = DateComponents()
        components.month = month
        components.day = day
        // Try this year first
        let currentYear = cal.component(.year, from: now)
        components.year = currentYear
        if let candidate = cal.date(from: components) {
            let todayStart = cal.startOfDay(for: now)
            let candidateStart = cal.startOfDay(for: candidate)
            if candidateStart >= todayStart {
                return candidate
            }
        }
        // Next year
        components.year = currentYear + 1
        return cal.date(from: components) ?? now
    }

    // MARK: – Suggest (used in AddPersonView)
    func suggestions(for query: String) -> [(month: Int, day: Int, name: String)] {
        guard query.count >= 2 else { return [] }
        let q = normalize(query)
        var results: [(month: Int, day: Int, name: String)] = []
        for entry in calendar {
            for name in entry.names {
                if normalize(name).hasPrefix(q) {
                    results.append((entry.month, entry.day, name))
                }
            }
        }
        return results.sorted { $0.name < $1.name }
    }

    // MARK: – Státní svátky ČR

    private let publicHolidays: [(month: Int, day: Int, name: String)] = [
        (1,  1,  "Nový rok"),
        (5,  1,  "Svátek práce"),
        (5,  8,  "Den vítězství"),
        (7,  5,  "Den Cyrila a Metoděje"),
        (7,  6,  "Den upálení Jana Husa"),
        (9,  28, "Den české státnosti"),
        (10, 28, "Den vzniku Československa"),
        (11, 17, "Den boje za svobodu"),
        (12, 24, "Štědrý den"),
        (12, 25, "1. svátek vánoční"),
        (12, 26, "2. svátek vánoční"),
    ]

    /// Vrátí státní svátek pro daný den (pokud existuje).
    func publicHoliday(for date: Date = Date()) -> String? {
        let cal = Foundation.Calendar.current
        let m = cal.component(.month, from: date)
        let d = cal.component(.day,   from: date)
        // Fixní svátky
        if let h = publicHolidays.first(where: { $0.month == m && $0.day == d }) {
            return h.name
        }
        // Pohyblivé – Velikonoce
        let year = cal.component(.year, from: date)
        let (goodFriday, easterMonday) = easterDates(year: year)
        if cal.isDate(date, inSameDayAs: goodFriday)   { return "Velký pátek" }
        if cal.isDate(date, inSameDayAs: easterMonday) { return "Velikonoční pondělí" }
        return nil
    }

    func publicHoliday(forMonth month: Int, day: Int, year: Int) -> String? {
        var comps = DateComponents(); comps.year = year; comps.month = month; comps.day = day
        guard let date = Foundation.Calendar.current.date(from: comps) else { return nil }
        return publicHoliday(for: date)
    }

    /// Gaussův algoritmus pro výpočet data Velikonoc.
    private func easterDates(year: Int) -> (goodFriday: Date, easterMonday: Date) {
        let a = year % 19
        let b = year / 100
        let c = year % 100
        let d = b / 4
        let e = b % 4
        let f = (b + 8) / 25
        let g = (b - f + 1) / 3
        let h = (19 * a + b - d - g + 15) % 30
        let i = c / 4
        let k = c % 4
        let l = (32 + 2 * e + 2 * i - h - k) % 7
        let m = (a + 11 * h + 22 * l) / 451
        let month = (h + l - 7 * m + 114) / 31
        let day   = ((h + l - 7 * m + 114) % 31) + 1

        var cal = Foundation.Calendar.current
        cal.locale = Locale(identifier: "cs_CZ")
        var easterComps = DateComponents()
        easterComps.year = year; easterComps.month = month; easterComps.day = day
        let easterSunday = cal.date(from: easterComps)!
        let goodFriday   = cal.date(byAdding: .day, value: -2, to: easterSunday)!
        let easterMonday = cal.date(byAdding: .day, value:  1, to: easterSunday)!
        return (goodFriday, easterMonday)
    }

    // MARK: – Zodiac sign

    func zodiacSign(for date: Date = Date()) -> (name: String, symbol: String) {
        let cal = Foundation.Calendar.current
        let month = cal.component(.month, from: date)
        let day   = cal.component(.day,   from: date)
        switch (month, day) {
        case (3, 21...31), (4,  1...19): return ("Beran",     "♈")
        case (4, 20...30), (5,  1...20): return ("Býk",       "♉")
        case (5, 21...31), (6,  1...20): return ("Blíženci",  "♊")
        case (6, 21...30), (7,  1...22): return ("Rak",       "♋")
        case (7, 23...31), (8,  1...22): return ("Lev",       "♌")
        case (8, 23...31), (9,  1...22): return ("Panna",     "♍")
        case (9, 23...30), (10, 1...22): return ("Váhy",      "♎")
        case (10,23...31), (11, 1...21): return ("Štír",      "♏")
        case (11,22...30), (12, 1...21): return ("Střelec",   "♐")
        case (12,22...31), (1,  1...19): return ("Kozoroh",   "♑")
        case (1, 20...31), (2,  1...18): return ("Vodnář",    "♒")
        default:                          return ("Ryby",      "♓") // 2/19–3/20
        }
    }

    // MARK: – Helpers

    private func normalize(_ string: String) -> String {
        string
            .lowercased()
            .folding(options: [.diacriticInsensitive], locale: Locale(identifier: "cs_CZ"))
    }
}

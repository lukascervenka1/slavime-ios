import Foundation

final class NameDayService {
    static let shared = NameDayService()
    private init() {
        // Pre-normalizuj aliasy (bez diakritiky, malá písmena) kvůli spolehlivému vyhledávání
        var d = [String: String]()
        for (k, v) in aliases { d[normalize(k)] = normalize(v) }
        normalizedAliases = d

        // Pre-normalizuj kalendářní jména → O(1) lookup místo O(n) iterate+normalize
        var cal = [String: (month: Int, day: Int)]()
        var ctc = [String: String]()
        for entry in calendar {
            for name in entry.names {
                let n = normalize(name)
                cal[n] = (entry.month, entry.day)
                ctc[n] = name   // normalizovaný klíč → originální kanonické jméno
            }
        }
        normalizedCalendar = cal
        normalizedToCanonical = ctc
    }

    // Normalizovaná kopie aliasů (bez diakritiky) – plněna v init
    private var normalizedAliases: [String: String] = [:]
    // Normalizovaná kopie kalendáře – O(1) lookup
    private var normalizedCalendar: [String: (month: Int, day: Int)] = [:]
    // Normalizovaný klíč → originální kanonické jméno (pro NameOriginService)
    private var normalizedToCanonical: [String: String] = [:]

    /// Vrátí kanonické jméno z kalendáře pro dané jméno nebo jeho alias.
    /// Např. "Kristýnka 🌸" → "Kristýna"
    func canonicalCalendarName(for name: String) -> String? {
        let normalized = normalize(name)
        if let canonical = normalizedToCanonical[normalized] { return canonical }
        if let alias = normalizedAliases[normalized] { return normalizedToCanonical[alias] }
        return nil
    }

    // MARK: – Czech name day calendar (ČSN)
    // Tuple: (month, day, [names])
    // Verifikuj data oproti: https://www.svatky.centrum.cz
    private let calendar: [(month: Int, day: Int, names: [String])] = [
        // LEDEN
        // 1/1 Nový rok – státní svátek, bez jména svátku
        (1, 2,  ["Karina", "Karína", "Karin"]),
        (1, 3,  ["Radmila"]),
        (1, 4,  ["Diana"]),
        (1, 5,  ["Dalimil", "Dalemil"]),
        (1, 6,  ["Kašpar", "Melichar", "Baltazar"]),
        (1, 7,  ["Vilma", "Wilhelmina"]),
        (1, 8,  ["Čestmír"]),
        (1, 9,  ["Vladan"]),
        (1, 10, ["Břetislav"]),
        (1, 11, ["Bohdana"]),
        (1, 12, ["Pravoslav"]),
        (1, 13, ["Edita"]),
        (1, 14, ["Radovan"]),
        (1, 15, ["Alice"]),
        (1, 16, ["Ctirad", "Česlav"]),
        (1, 17, ["Drahoslav"]),
        (1, 18, ["Vladislav"]),
        (1, 19, ["Doubravka"]),
        (1, 20, ["Ilona"]),
        (1, 21, ["Běla"]),
        (1, 22, ["Slavomír"]),
        (1, 23, ["Zdeněk", "Zdenek", "Zdenko"]),
        (1, 24, ["Milena"]),
        (1, 25, ["Miloš"]),
        (1, 26, ["Zora"]),
        (1, 27, ["Ingrid"]),
        (1, 28, ["Otýlie", "Otilie"]),
        (1, 29, ["Zdislava", "Zdeslava"]),
        (1, 30, ["Robin"]),
        (1, 31, ["Marika"]),
        // ÚNOR
        (2, 1,  ["Hynek"]),
        (2, 2,  ["Nela"]),
        (2, 3,  ["Blažej"]),
        (2, 4,  ["Jarmila"]),
        (2, 5,  ["Dobromila"]),
        (2, 6,  ["Vanda", "Wanda"]),
        (2, 7,  ["Veronika"]),
        (2, 8,  ["Milada"]),
        (2, 9,  ["Apolena"]),
        (2, 10, ["Mojmír"]),
        (2, 11, ["Božena"]),
        (2, 12, ["Slavěna"]),
        (2, 13, ["Věnceslav"]),
        (2, 14, ["Valentýn", "Valentin", "Valentýna"]),
        (2, 15, ["Jiřina", "Jorga"]),
        (2, 16, ["Ljuba"]),
        (2, 17, ["Miloslava"]),
        (2, 18, ["Gizela", "Gisela"]),
        (2, 19, ["Patrik"]),
        (2, 20, ["Oldřich"]),
        (2, 21, ["Lenka", "Eleonora"]),
        (2, 22, ["Petr"]),
        (2, 23, ["Svatopluk"]),
        (2, 24, ["Matěj", "Matej", "Matyáš"]),
        (2, 25, ["Liliana", "Lilian", "Lily"]),
        (2, 26, ["Dorota", "Dorotea"]),
        (2, 27, ["Alexandr", "Alexander", "Alexis"]),
        (2, 28, ["Lumír"]),
        (2, 29, ["Horymír"]),
        // BŘEZEN
        (3, 1,  ["Bedřich"]),
        (3, 2,  ["Anežka", "Agnes", "Ines"]),
        (3, 3,  ["Kamil"]),
        (3, 4,  ["Stela", "Stella"]),
        (3, 5,  ["Kazimír"]),
        (3, 6,  ["Miroslav", "Mirek"]),
        (3, 7,  ["Tomáš", "Thomas", "Tom"]),
        (3, 8,  ["Gabriela"]),
        (3, 9,  ["Františka", "Francesca"]),
        (3, 10, ["Viktorie"]),
        (3, 11, ["Anděla", "Andělína", "Angelina"]),
        (3, 12, ["Řehoř", "Gregor"]),
        (3, 13, ["Růžena", "Rozálie", "Rosita"]),
        (3, 14, ["Rút", "Rut", "Matylda"]),
        (3, 15, ["Ida"]),
        (3, 16, ["Elena", "Herbert"]),
        (3, 17, ["Vlastimil"]),
        (3, 18, ["Eduard", "Edvard"]),
        (3, 19, ["Josef", "Jozef"]),
        (3, 20, ["Světlana"]),
        (3, 21, ["Radek", "Radomil"]),
        (3, 22, ["Leona"]),
        (3, 23, ["Ivona", "Yvona"]),
        (3, 24, ["Gabriel"]),
        (3, 25, ["Marián", "Marian", "Marius"]),
        (3, 26, ["Emanuel"]),
        (3, 27, ["Dita", "Ditta"]),
        (3, 28, ["Soňa", "Sonja", "Sonia"]),
        (3, 29, ["Taťána", "Tatiana"]),
        (3, 30, ["Arnošt"]),
        (3, 31, ["Kvido", "Quido"]),
        // DUBEN
        (4, 1,  ["Hugo"]),
        (4, 2,  ["Erika"]),
        (4, 3,  ["Richard"]),
        (4, 4,  ["Ivana", "Ivanka"]),
        (4, 5,  ["Miroslava", "Mirka"]),
        (4, 6,  ["Vendula", "Vendulka"]),
        (4, 7,  ["Heřman", "Herman", "Hermína"]),
        (4, 8,  ["Ema", "Emma"]),
        (4, 9,  ["Dušan", "Dušana"]),
        (4, 10, ["Darja", "Daria", "Darya"]),
        (4, 11, ["Izabela", "Isabel"]),
        (4, 12, ["Julius", "Július", "Julian"]),
        (4, 13, ["Aleš"]),
        (4, 14, ["Vincenc", "Vincent"]),
        (4, 15, ["Anastázie", "Anastazia"]),
        (4, 16, ["Irena", "Irini"]),
        (4, 17, ["Rudolf", "Rolf"]),
        (4, 18, ["Valerie", "Valérie", "Valeria"]),
        (4, 19, ["Rostislava"]),
        (4, 20, ["Marcela"]),
        (4, 21, ["Alexandra"]),
        (4, 22, ["Evženie", "Evžénie"]),
        (4, 23, ["Vojtěch"]),
        (4, 24, ["Jiří", "Juraj", "George"]),
        (4, 25, ["Marek"]),
        (4, 26, ["Oto", "Ota", "Otto"]),
        (4, 27, ["Jaroslav"]),
        (4, 28, ["Vlastislav"]),
        (4, 29, ["Robert"]),
        (4, 30, ["Blahoslav"]),
        // KVĚTEN
        // 5/1 Svátek práce – bez jména svátku
        (5, 2,  ["Zikmund"]),
        (5, 3,  ["Alexej", "Alex"]),
        (5, 4,  ["Květoslav"]),
        (5, 5,  ["Klaudie", "Klaudia", "Claudia"]),
        (5, 6,  ["Radoslav"]),
        (5, 7,  ["Stanislav"]),
        // 5/8 Den vítězství – bez jména svátku
        (5, 9,  ["Ctibor", "Stibor"]),
        (5, 10, ["Blažena"]),
        (5, 11, ["Svatava"]),
        (5, 12, ["Pankrác"]),
        (5, 13, ["Servác"]),
        (5, 14, ["Bonifác"]),
        (5, 15, ["Žofie"]),
        (5, 16, ["Přemysl"]),
        (5, 17, ["Aneta", "Anetta"]),
        (5, 18, ["Nataša"]),
        (5, 19, ["Ivo", "Ivoš"]),
        (5, 20, ["Zbyšek"]),
        (5, 21, ["Monika"]),
        (5, 22, ["Emil"]),
        (5, 23, ["Vladimír"]),
        (5, 24, ["Jana"]),
        (5, 25, ["Viola"]),
        (5, 26, ["Filip"]),
        (5, 27, ["Valdemar", "Waldemar"]),
        (5, 28, ["Vilém"]),
        (5, 29, ["Maxmilián", "Maxmilian", "Maximilian"]),
        (5, 30, ["Ferdinand"]),
        (5, 31, ["Kamila"]),
        // ČERVEN
        (6, 1,  ["Laura"]),
        (6, 2,  ["Jarmil"]),
        (6, 3,  ["Tamara"]),
        (6, 4,  ["Dalibor"]),
        (6, 5,  ["Dobroslav"]),
        (6, 6,  ["Norbert"]),
        (6, 7,  ["Iveta", "Yveta"]),
        (6, 8,  ["Medard"]),
        (6, 9,  ["Stanislava"]),
        (6, 10, ["Otta"]),
        (6, 11, ["Bruno"]),
        (6, 12, ["Antonie", "Antonina"]),
        (6, 13, ["Antonín", "Antonin"]),
        (6, 14, ["Roland"]),
        (6, 15, ["Vít", "Vítek"]),
        (6, 16, ["Zbyněk"]),
        (6, 17, ["Adolf"]),
        (6, 18, ["Milan"]),
        (6, 19, ["Leoš"]),
        (6, 20, ["Květa", "Kveta"]),
        (6, 21, ["Alois", "Aloys", "Alojz"]),
        (6, 22, ["Pavla"]),
        (6, 23, ["Zdeňka", "Zdena", "Zdenka"]),
        (6, 24, ["Jan"]),
        (6, 25, ["Ivan"]),
        (6, 26, ["Adriana"]),
        (6, 27, ["Ladislav"]),
        (6, 28, ["Lubomír", "Lubomil"]),
        (6, 29, ["Petr", "Pavel"]),
        (6, 30, ["Šárka"]),
        // ČERVENEC
        (7, 1,  ["Jaroslava"]),
        (7, 2,  ["Patricie"]),
        (7, 3,  ["Radomír"]),
        (7, 4,  ["Prokop"]),
        (7, 5,  ["Cyril", "Metoděj"]),
        // 7/6 Den upálení Jana Husa – bez jména svátku
        (7, 7,  ["Bohuslava"]),
        (7, 8,  ["Nora"]),
        (7, 9,  ["Drahoslava"]),
        (7, 10, ["Libuše", "Amálie"]),
        (7, 11, ["Olga"]),
        (7, 12, ["Bořek"]),
        (7, 13, ["Markéta", "Margareta", "Margit"]),
        (7, 14, ["Karolína", "Karolina", "Karla"]),
        (7, 15, ["Jindřich"]),
        (7, 16, ["Luboš", "Liboslav", "Luboslav"]),
        (7, 17, ["Martina"]),
        (7, 18, ["Drahomíra"]),
        (7, 19, ["Čeněk"]),
        (7, 20, ["Ilja"]),
        (7, 21, ["Vítězslav"]),
        (7, 22, ["Magdaléna", "Magdalena"]),
        (7, 23, ["Libor"]),
        (7, 24, ["Kristýna", "Kristina", "Kristen"]),
        (7, 25, ["Jakub"]),
        (7, 26, ["Anna"]),
        (7, 27, ["Věroslav"]),
        (7, 28, ["Viktor", "Victor"]),
        (7, 29, ["Marta", "Martha"]),
        (7, 30, ["Bořivoj"]),
        (7, 31, ["Ignác"]),
        // SRPEN
        (8, 1,  ["Oskar"]),
        (8, 2,  ["Gustav"]),
        (8, 3,  ["Miluše"]),
        (8, 4,  ["Dominik"]),
        (8, 5,  ["Kristián", "Milivoj", "Křišťan"]),
        (8, 6,  ["Oldřiška"]),
        (8, 7,  ["Lada"]),
        (8, 8,  ["Soběslav"]),
        (8, 9,  ["Roman"]),
        (8, 10, ["Vavřinec"]),
        (8, 11, ["Zuzana", "Susana"]),
        (8, 12, ["Klára", "Clara"]),
        (8, 13, ["Alena"]),
        (8, 14, ["Alan"]),
        (8, 15, ["Hana", "Hanka", "Hannah"]),
        (8, 16, ["Jáchym", "Joachim"]),
        (8, 17, ["Petra", "Petronila"]),
        (8, 18, ["Helena"]),
        (8, 19, ["Ludvík"]),
        (8, 20, ["Bernard"]),
        (8, 21, ["Johana"]),
        (8, 22, ["Bohuslav", "Božislav"]),
        (8, 23, ["Sandra"]),
        (8, 24, ["Bartoloměj", "Bartolomej"]),
        (8, 25, ["Radim", "Radimír"]),
        (8, 26, ["Luděk"]),
        (8, 27, ["Otakar", "Otokar"]),
        (8, 28, ["Augustýn", "Augustin"]),
        (8, 29, ["Evelína", "Evelin", "Evelina"]),
        (8, 30, ["Vladěna"]),
        (8, 31, ["Pavlína", "Paulína"]),
        // ZÁŘÍ
        (9, 1,  ["Linda", "Samuel"]),
        (9, 2,  ["Adéla", "Adléta", "Adela"]),
        (9, 3,  ["Bronislav"]),
        (9, 4,  ["Jindřiška", "Henrieta"]),
        (9, 5,  ["Boris"]),
        (9, 6,  ["Boleslav"]),
        (9, 7,  ["Regina", "Regína"]),
        (9, 8,  ["Mariana"]),
        (9, 9,  ["Daniela"]),
        (9, 10, ["Irma"]),
        (9, 11, ["Denisa", "Denis"]),
        (9, 12, ["Marie"]),
        (9, 13, ["Lubor"]),
        (9, 14, ["Radka"]),
        (9, 15, ["Jolana"]),
        (9, 16, ["Ludmila"]),
        (9, 17, ["Naděžda"]),
        (9, 18, ["Kryštof", "Krištof"]),
        (9, 19, ["Zita"]),
        (9, 20, ["Oleg"]),
        (9, 21, ["Matouš"]),
        (9, 22, ["Darina"]),
        (9, 23, ["Berta", "Bertina"]),
        (9, 24, ["Jaromír"]),
        (9, 25, ["Zlata"]),
        (9, 26, ["Andrea", "Ondřejka"]),
        (9, 27, ["Jonáš"]),
        (9, 28, ["Václav", "Václava"]),
        (9, 29, ["Michal", "Michael"]),
        (9, 30, ["Jeroným", "Jeronym", "Jarolím"]),
        // ŘÍJEN
        (10, 1,  ["Igor"]),
        (10, 2,  ["Olívie", "Olivia", "Oliver"]),
        (10, 3,  ["Bohumil"]),
        (10, 4,  ["František"]),
        (10, 5,  ["Eliška", "Elsa"]),
        (10, 6,  ["Hanuš"]),
        (10, 7,  ["Justýna", "Justina", "Justin"]),
        (10, 8,  ["Věra", "Viera"]),
        (10, 9,  ["Štefan", "Sára"]),
        (10, 10, ["Marina", "Marína"]),
        (10, 11, ["Andrej"]),
        (10, 12, ["Marcel"]),
        (10, 13, ["Renáta", "Renata"]),
        (10, 14, ["Agáta"]),
        (10, 15, ["Tereza"]),
        (10, 16, ["Havel"]),
        (10, 17, ["Hedvika"]),
        (10, 18, ["Lukáš"]),
        (10, 19, ["Michaela", "Michala"]),
        (10, 20, ["Vendelín"]),
        (10, 21, ["Brigita", "Bridget"]),
        (10, 22, ["Sabina"]),
        (10, 23, ["Teodor", "Theodor"]),
        (10, 24, ["Nina"]),
        (10, 25, ["Beáta", "Beata"]),
        (10, 26, ["Erik", "Ervín"]),
        (10, 27, ["Šarlota", "Zoe", "Zoja"]),
        // 10/28 Den vzniku Československa – bez jména svátku
        (10, 29, ["Silvie", "Sylva", "Silva"]),
        (10, 30, ["Tadeáš"]),
        (10, 31, ["Štěpánka", "Stefanie"]),
        // LISTOPAD
        (11, 1,  ["Felix"]),
        // 11/2 Dušičky – bez jména svátku
        (11, 3,  ["Hubert"]),
        (11, 4,  ["Karel"]),
        (11, 5,  ["Miriam"]),
        (11, 6,  ["Liběna"]),
        (11, 7,  ["Saskie"]),
        (11, 8,  ["Bohumír"]),
        (11, 9,  ["Bohdan"]),
        (11, 10, ["Evžen", "Eugen"]),
        (11, 11, ["Martin"]),
        (11, 12, ["Benedikt"]),
        (11, 13, ["Tibor"]),
        (11, 14, ["Sáva"]),
        (11, 15, ["Leopold"]),
        (11, 16, ["Otmar", "Otomar"]),
        (11, 17, ["Mahulena"]),
        (11, 18, ["Romana"]),
        (11, 19, ["Alžběta", "Elisabeth"]),
        (11, 20, ["Nikola"]),
        (11, 21, ["Albert"]),
        (11, 22, ["Cecílie"]),
        (11, 23, ["Klement", "Kliment"]),
        (11, 24, ["Emílie", "Emilia"]),
        (11, 25, ["Kateřina", "Katka", "Katarína"]),
        (11, 26, ["Artur"]),
        (11, 27, ["Xenie"]),
        (11, 28, ["René", "Renée"]),
        (11, 29, ["Zina"]),
        (11, 30, ["Ondřej"]),
        // PROSINEC
        (12, 1,  ["Iva"]),
        (12, 2,  ["Blanka"]),
        (12, 3,  ["Svatoslav", "Světoslav"]),
        (12, 4,  ["Barbora", "Barbara", "Bára"]),
        (12, 5,  ["Jitka"]),
        (12, 6,  ["Mikuláš", "Mikoláš", "Nikolas"]),
        (12, 7,  ["Ambrož", "Benjamin"]),
        (12, 8,  ["Květoslava"]),
        (12, 9,  ["Vratislav"]),
        (12, 10, ["Julie", "Julia", "Juliana"]),
        (12, 11, ["Dana"]),
        (12, 12, ["Simona", "Šimona", "Simeona"]),
        (12, 13, ["Lucie", "Lucia", "Luciana"]),
        (12, 14, ["Lýdie", "Lydia", "Lydie"]),
        (12, 15, ["Radana"]),
        (12, 16, ["Albína"]),
        (12, 17, ["Daniel", "Dan"]),
        (12, 18, ["Miloslav"]),
        (12, 19, ["Ester"]),
        (12, 20, ["Dagmar", "Dagmara", "Dáša"]),
        (12, 21, ["Natálie"]),
        (12, 22, ["Šimon", "Simon", "Simeon"]),
        (12, 23, ["Vlasta"]),
        (12, 24, ["Adam", "Eva"]),
        // 12/25 1. svátek vánoční – bez jména svátku
        (12, 26, ["Štěpán"]),
        (12, 27, ["Žaneta"]),
        (12, 28, ["Bohumila"]),
        (12, 29, ["Judita"]),
        (12, 30, ["David"]),
        (12, 31, ["Silvestr", "Silvester", "Sylvestr"]),
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

        // O(1) přímý shodný lookup
        if let result = normalizedCalendar[normalized] { return result }

        // O(1) alias lookup → pak O(1) calendar lookup
        if let canonical = normalizedAliases[normalized] {
            if let result = normalizedCalendar[canonical] { return result }
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

    // MARK: – Mezinárodní dny

    private let intlDaysList: [(month: Int, day: Int, name: String, emoji: String)] = [
        // Leden
        (1, 27, "Mezinárodní den památky obětí holokaustu", "🕯️"),
        // Únor
        (2,  4, "Světový den boje proti rakovině", "🎗️"),
        (2, 14, "Valentýn – Den zamilovaných", "❤️"),
        // Březen
        (3,  8, "Mezinárodní den žen", "💜"),
        (3, 20, "Světový den štěstí", "😊"),
        (3, 21, "Světový den poezie a první den jara", "🌸"),
        (3, 22, "Světový den vody", "💧"),
        (3, 27, "Světový den divadla", "🎭"),
        // Duben
        (4,  1, "Apríl – Den vtipů", "😄"),
        (4,  7, "Světový den zdraví", "💊"),
        (4, 22, "Den Země", "🌍"),
        (4, 23, "Světový den knihy", "📚"),
        // Květen
        (5,  3, "Světový den svobody tisku", "🗞️"),
        (5,  4, "Světový den Star Wars", "⭐"),
        (5, 15, "Mezinárodní den rodiny", "👨‍👩‍👧"),
        (5, 18, "Světový den muzeí", "🏛️"),
        (5, 31, "Světový den bez tabáku", "🚭"),
        // Červen
        (6,  1, "Mezinárodní den dětí", "👶"),
        (6,  5, "Světový den životního prostředí", "🌿"),
        (6, 21, "Mezinárodní den hudby a letní slunovrat", "🎵"),
        (6, 26, "Mezinárodní den boje proti drogám", "🚫"),
        // Červenec
        (7, 11, "Světový den populace", "🌏"),
        // Srpen
        (8, 12, "Mezinárodní den mládeže", "🌟"),
        (8, 19, "Světový den humanitární pomoci", "🤝"),
        // Září
        (9,  8, "Mezinárodní den gramotnosti", "📖"),
        (9, 21, "Mezinárodní den míru", "☮️"),
        (9, 22, "Den bez auta", "🚶"),
        (9, 27, "Světový den cestovního ruchu", "✈️"),
        // Říjen
        (10,  1, "Mezinárodní den seniorů", "👴"),
        (10,  5, "Světový den učitelů", "🍎"),
        (10, 10, "Světový den duševního zdraví", "🧠"),
        (10, 16, "Světový den výživy", "🌾"),
        (10, 31, "Halloween", "🎃"),
        // Listopad
        (11, 11, "Světový den origami", "🦢"),
        (11, 13, "Světový den laskavosti", "💛"),
        (11, 19, "Světový den mužů", "👨"),
        (11, 20, "Světový den dětí (OSN)", "🌈"),
        // Prosinec
        (12,  1, "Světový den boje proti AIDS", "🔴"),
        (12, 10, "Mezinárodní den lidských práv", "⚖️"),
        (12, 21, "Zimní slunovrat", "❄️"),
    ]

    func internationalDays(forMonth month: Int, day: Int) -> [(name: String, emoji: String)] {
        intlDaysList
            .filter { $0.month == month && $0.day == day }
            .map { (name: $0.name, emoji: $0.emoji) }
    }

    // MARK: – Helpers

    private func normalize(_ string: String) -> String {
        // Odstraň emoji a ponech pouze písmena a mezery
        let lettersOnly = string.unicodeScalars.filter { scalar in
            let cat = scalar.properties.generalCategory
            return cat == .lowercaseLetter || cat == .uppercaseLetter ||
                   cat == .titlecaseLetter || cat == .modifierLetter ||
                   cat == .otherLetter || scalar.value == 32 // mezera
        }
        .reduce("") { $0 + String($1) }
        .trimmingCharacters(in: .whitespaces)

        return lettersOnly
            .lowercased()
            .folding(options: [.diacriticInsensitive], locale: Locale(identifier: "cs_CZ"))
    }
}

import Foundation

struct NameOrigin {
    let language: String
    let meaning: String
    let funFact: String
}

final class NameOriginService {
    static let shared = NameOriginService()
    private init() {}

    func origin(for name: String) -> NameOrigin? {
        let normalized = normalize(name)
        if let o = origins[normalized] { return o }
        if let canonical = NameDayService.shared.canonicalCalendarName(for: name) {
            return origins[normalize(canonical)]
        }
        return nil
    }

    private func normalize(_ s: String) -> String {
        s.unicodeScalars.filter {
            let c = $0.properties.generalCategory
            return c == .lowercaseLetter || c == .uppercaseLetter || c == .titlecaseLetter ||
                   c == .modifierLetter  || c == .otherLetter     || $0.value == 32
        }
        .reduce("") { $0 + String($1) }
        .trimmingCharacters(in: .whitespaces)
        .lowercased()
        .folding(options: .diacriticInsensitive, locale: Locale(identifier: "cs_CZ"))
    }

    // MARK: - Data (klice jsou normalizovane - bez diakritiky, mala pismena)

    private let origins: [String: NameOrigin] = [

        // ═══ MUZSKA JMENA ═══

        "alois": .init(
            language: "Germánský (provensálský)",
            meaning: "Slavný válečník (hlud = sláva + wig = boj)",
            funFact: "Alois je provensálská forma jména Ludvík (Louis). Nositelem byl Alois Senefelder, který roku 1796 vynalezl litografii - techniku tisku, jež změnila reprodukci obrazů."
        ),
        "benedikt": .init(
            language: "Latinský",
            meaning: "Požehnaný, blahořečený (bene + dicere = dobře mluvit)",
            funFact: "Sv. Benedikt z Nursie (480-547) je zakladatelem západního mnišství. Jméno neslo 16 papežů - více než jakékoliv jiné jméno kromě Jana."
        ),
        "ctibor": .init(
            language: "Slovanský",
            meaning: "Čest a boj, bojující za čest (cti + bor)",
            funFact: "Dvousložkové slovanské jméno z cti (čest, úcta) a boriti (bojovat). Kníže Czcibor z rodu Piastovců byl bratrem prvního polského křesťanského vládce Mieszka I."
        ),
        "cyril": .init(
            language: "Řecký",
            meaning: "Pán, vladař (Kyrillos, od kyrios = pán)",
            funFact: "Sv. Cyril (původním jménem Konstantin) spolu s bratrem Metodějem sestavil hlaholici - první slovanské písmo. Cyrilice, používaná pro ruštinu či srbštinu, nese jeho jméno."
        ),
        "ignac": .init(
            language: "Latinský (etruský původ)",
            meaning: "Ohnivý (lidová etymologie od ignis = oheň); původ nejasný",
            funFact: "Sv. Ignác z Loyoly, bývalý voják, po zranění se stal mystikem a roku 1540 založil jezuitský řád. Jezuité vybudovali po celém světě stovky univerzit a škol."
        ),
        "ivan": .init(
            language: "Slovanský (z hebrejského)",
            meaning: "Bůh je milostivý (slovanská forma Jana / Johanna)",
            funFact: "Ivan je nejrozšířenější variantou jména Jan ve slovanském světě. Nesli ho ruští caři Ivan III. Veliký i Ivan IV. Hrozný, kteří zásadně formovali ruský stát."
        ),
        "jindrich": .init(
            language: "Germánský",
            meaning: "Vládce domova, hospodář (heim = domov + rihhi = vládce)",
            funFact: "Jindřich je česká forma německého jména Heinrich. Jméno Henry bylo v Anglii tak rozšířené, že fráze Tom, Dick and Harry označuje kohokoliv z ulice."
        ),
        "kamil": .init(
            language: "Latinský (etruský původ)",
            meaning: "Pomocník při obřadech (camillus = ministrant)",
            funFact: "Sv. Kamil de Lellis (16. stol.) byl zakladatelem řádu pečujícího o nemocné a jeho bratři nosili červený kříž na hábitu - předobraz symbolu dnešního Červeného kříže."
        ),
        "ladislav": .init(
            language: "Slovanský",
            meaning: "Vládnoucí slávou (vladeti + slava)",
            funFact: "Jméno nosil sv. Ladislav I. Uherský, patron Polska a Maďarska. V Čechách byl populární jako Ladislava Pohrobek - poslední Lucemburk na českém trůně."
        ),
        "lubomir": .init(
            language: "Slovanský",
            meaning: "Milující mír, láska a mír (lub = milovat + mir = mír)",
            funFact: "Krásné dvousložkové slovanské jméno. Kořen mir (mír, svět) nese i Miroslav nebo Vladimir - je jedním z nejplodnějších základů slovanských jmen."
        ),
        "miloslav": .init(
            language: "Slovanský",
            meaning: "Milostivá sláva, sláva laskavosti (milŭ + slava)",
            funFact: "Kombinace mil- (milý, laskavý) a slávy je typická pro slovanské dvousložkové jméno. Tvoří ho stejný základ jako Milena, Milan nebo Miroslav."
        ),
        "metodej": .init(
            language: "Řecký",
            meaning: "Ten, kdo jde správnou cestou, metodický (meta + hodos = cesta)",
            funFact: "Sv. Metoděj spolu s bratrem Cyrilem přeložil liturgické texty do staroslověnštiny a vytvořil první slovanské písmo. Jejich svátek 5. 7. je státním svátkem ČR i SR."
        ),
        "prokop": .init(
            language: "Řecký",
            meaning: "Pokrok, průkopník, úspěch (prokope = pokrok)",
            funFact: "Sv. Prokop Sázavský (11. stol.) je patron Čech a zakladatel Sázavského kláštera. Byl posledním slovanským světcem používajícím staroslověnštinu v bohoslužbě."
        ),
        "radoslav": .init(
            language: "Slovanský",
            meaning: "Radostná sláva, slavný radostí (rad + slava)",
            funFact: "Jméno nese kořen rad- vyjadřující radost, který se vyskytuje i v jménech Radim, Radek nebo Radovan. Nejstarší známý Radoslav byl srbský vládce 9. století."
        ),
        "slavomir": .init(
            language: "Slovanský",
            meaning: "Slavný mír, sláva a mír (slava + mir)",
            funFact: "Jméno Slavomír nosili panovníci Obodritů a Moravanů v 9. století. Je dokladem starobylé tradice slovanských dvousložkových jmen."
        ),
        "vit": .init(
            language: "Latinský",
            meaning: "Živý, plný života (vita = život)",
            funFact: "Sv. Vít je patronem Čech a jemu je zasvěcena katedrála na Pražském hradě. Zajímavě: sv. Václav vybral tohoto patrona i proto, že Svatý Vít zněl podobně jako jméno slovanského boha Svantovíta."
        ),
        "zbynek": .init(
            language: "Slovanský",
            meaning: "Ten, kdo odstraňuje hněv, zaháněč zlého (zbyti + hněv)",
            funFact: "Zbyněk je česká zkrácenina jména Zbyhněv, polsky Zbigniew. Jméno bylo doloženo již ve 13. století a patří k typicky středoevropským slovanským jménům."
        ),

        "adam": .init(
            language: "Hebrejský",
            meaning: "Stvořený ze země, člověk",
            funFact: "Adam je podle Bible prvním člověkem. V češtině se říká od Adama - tedy od úplného začátku. Ve světě existuje přes 40 jazykových variant tohoto jména."
        ),
        "ales": .init(
            language: "Řecký",
            meaning: "Obránce, ochránce lidí",
            funFact: "Zkrácenina jména Alexej (Alexandr). Jméno Alexandr neslo přes 300 panovníků - od Alexandra Makedonského po cara Alexandra III."
        ),
        "antonin": .init(
            language: "Latinský (etruský původ)",
            meaning: "Jméno slavného římského rodu Antoniů",
            funFact: "Jméno proslavil Marcus Aurelius Antoninus - filosof na trůně. V Čechách ho oblíbil sv. Antonín Paduánský, patron těch, kdo hledají ztracené věci."
        ),
        "bohuslav": .init(
            language: "Slovanský",
            meaning: "Chválit Boha, Bohu slávou",
            funFact: "Dvousložkové slovanské jméno. Hrdě ho nosil Bohuslav Martinů - jeden z nejhranějších českých skladatelů na světě."
        ),
        "borivoj": .init(
            language: "Slovanský",
            meaning: "Ten, kdo bojuje vpřed",
            funFact: "Jméno prvního historicky doloženého přemyslovského knížete. Bořivoj I. byl pokřtěn samotným sv. Metodějem kolem roku 883."
        ),
        "bretislav": .init(
            language: "Slovanský",
            meaning: "Ten, jehož sláva zahřmí (bře = hrom, třesk)",
            funFact: "Přemyslovský kníže Břetislav I. byl zvaný Český Achilles. V roce 1039 přenesl ostatky sv. Vojtěcha z Hnězdna do Prahy."
        ),
        "ctirad": .init(
            language: "Slovanský",
            meaning: "Ten, kdo ctí radu a moudrost",
            funFact: "Podle staré pověsti byl Ctirad oklamán krásnou Šárkou uvázanou ke stromu. Byl vlákán do léčky dívčí války a zabit. Odtud název Divoká Šárka v Praze."
        ),
        "dalibor": .init(
            language: "Slovanský",
            meaning: "Ten, kdo bojuje v dáli",
            funFact: "Rytíř Dalibor z Kozojed byl uvězněn v Daliborce na Pražském hradě. Prý se naučil hrát na housle tak krásně, že se Pražané chodili poslouchat. Smetana ho uchoval v opeře."
        ),
        "daniel": .init(
            language: "Hebrejský",
            meaning: "Bůh je můj soudce",
            funFact: "Biblický Daniel přežil jámu se lvy a vyložil babylonský nápis na zdi. Odtud číst nápis na zdi jako varování. Jméno je oblíbené na všech kontinentech."
        ),
        "david": .init(
            language: "Hebrejský",
            meaning: "Milovaný, drahý",
            funFact: "Král David porazil obra Goliáše s prakem a kamenem. Davidova hvězda je symbolem judaismu dodnes."
        ),
        "dominik": .init(
            language: "Latinský",
            meaning: "Patřící Pánu, Boží (dominicus)",
            funFact: "Jméno nese zakladatel dominikánského řádu sv. Dominik. Dominikáni jsou přezdíváni Domini canes - Boží psi. Oblíbené jméno papeže Františka."
        ),
        "dusan": .init(
            language: "Slovanský",
            meaning: "Duše, duchaplný",
            funFact: "Jméno odvozené od slovanského slova duše. Je velmi rozšířené v Čechách a na Slovensku, ale téměř neznámé mimo slovanský svět."
        ),
        "filip": .init(
            language: "Řecký",
            meaning: "Milovník koní (philos + hippos)",
            funFact: "Jméno nesl Alexandrův otec Filip II. Makedonský. Dnes ho nosí celá řada evropských korunních princů - španělský král, belgický král, britský princ."
        ),
        "frantisek": .init(
            language: "Germánský (franský)",
            meaning: "Svobodný muž, příslušník kmene Franků",
            funFact: "František z Assisi se vzdal bohatství, kázal ptákům a je patronem zvířat a ekologie. Aktuální papež přijal toto jméno jako první v historii."
        ),
        "havel": .init(
            language: "Latinský (Gallus)",
            meaning: "Kohout, galský - pocházející z Galie",
            funFact: "Sv. Havel byl irský mnich, který odešel do Švýcarska. Na sv. Havla (16. 10.) prý nastane zima - lidé to tradičně dodnes sledují."
        ),
        "igor": .init(
            language: "Severský (skandinávský)",
            meaning: "Válečník boha Ing (Freyr) - ze staronorského Ingvarr",
            funFact: "Jméno přišlo do slovanského světa s Varjažskými obchodníky (Vikingy). Kyjevský kníže Igor byl manželem sv. Olgy."
        ),
        "jakub": .init(
            language: "Hebrejský",
            meaning: "Ten, kdo drží za patu, nebo Bůh chrání (Yaakov)",
            funFact: "Apoštol Jakub je pohřbený v Santiagu de Compostela - cíli nejslavnější poutní trasy světa. Česká zdrobnělina Kuba je světově unikátní."
        ),
        "jan": .init(
            language: "Hebrejský",
            meaning: "Bůh je milostivý (Yochanan)",
            funFact: "Jméno neslo 23 papežů - žádné jiné papežské jméno nedosáhlo takové oblíbenosti. Existuje přes 60 variant: John, Hans, Jean, Giovanni, Juan, Ivan, Sean..."
        ),
        "jaroslav": .init(
            language: "Slovanský",
            meaning: "Jarý (jiskrný, živý) + sláva",
            funFact: "Jméno nosili Jaroslav Hašek (Švejk), Jaroslav Seifert (Nobelova cena) i Jaroslav Foglar (Rychlé šípy). Typicky slovanské jméno bez ekvivalentu na Západě."
        ),
        "jiri": .init(
            language: "Řecký",
            meaning: "Zemědělec, rolník (georgos)",
            funFact: "Sv. Jiří je patronem Anglie, Katalánska, Gruzie (Jiříkova zem), Litvy a mnoha dalších zemí. Je zobrazován na koni jak zabíjí draka - symbol dobra nad zlem."
        ),
        "jonas": .init(
            language: "Hebrejský",
            meaning: "Holubice (yonah)",
            funFact: "Biblický Jonáš strávil tři dny v břiše velryby a pak kázal v Ninive. Holubice jako symbol míru pochází z tohoto příběhu."
        ),
        "josef": .init(
            language: "Hebrejský",
            meaning: "Bůh přidá, Bůh rozmnožuje (Yosef)",
            funFact: "Biblický Josef byl prodán bratry za 20 stříbrných a stal se egyptským místokrálem. Česká zdrobnělina Pepa/Pepík je celosvětově unikátní."
        ),
        "karel": .init(
            language: "Germánský (franský)",
            meaning: "Svobodný, silný muž (Karlaz)",
            funFact: "Karel Veliký byl tak slavný, že jeho jméno dalo základ slovu král ve slovanských jazycích. Čtyři čeští králové nesli toto jméno."
        ),
        "krystof": .init(
            language: "Řecký",
            meaning: "Nositel Krista (Christos + phoros)",
            funFact: "Sv. Kryštof prý přenesl malého Ježíška přes rozvodněnou řeku. Je patronem cestovatelů, řidičů a horolezců. Jeho medailonky visí v milionech aut po celém světě."
        ),
        "libor": .init(
            language: "Latinský / Slovanský",
            meaning: "Svobodný (liber) - nebo ze slovanského libý",
            funFact: "Jméno má dvojí etymologii. Sv. Libor je patronem německého Paderbornu. V Čechách se jméno rozšířilo ve středověku."
        ),
        "lukas": .init(
            language: "Latinský / Řecký",
            meaning: "Ze světla, nebo z Lukánie (oblast jižní Itálie)",
            funFact: "Sv. Lukáš byl lékař, malíř a evangelista. Je patronem lékařů, malířů a řezníků. Napsal třetí evangelium a Skutky apoštolů."
        ),
        "marek": .init(
            language: "Latinský",
            meaning: "Patřící bohu Martovi (Marcus), válečný",
            funFact: "Sv. Marek napsal nejstarší evangelium. Jeho symbolem je lev. Benátky mají na počest sv. Marka chrám San Marco a na znaku okřídleného lva."
        ),
        "martin": .init(
            language: "Latinský",
            meaning: "Patřící bohu Martovi (Martinus)",
            funFact: "Sv. Martin přepůlil plášť a dal půlku žebráku - symbol štědrosti. 11. 11. je svatomartinská husa a první svatomartinské víno."
        ),
        "matous": .init(
            language: "Hebrejský",
            meaning: "Boží dar (Mattityahu)",
            funFact: "Apoštol Matouš byl celníkem - profese tehdy velmi nepopulární. Napsal první evangelium. Jeho symbolem je andělský člověk."
        ),
        "michal": .init(
            language: "Hebrejský",
            meaning: "Kdo je jako Bůh? (Mi-ka-El)",
            funFact: "Archanděl Michael velí nebeské armádě a váží duše zemřelých. Je patronem vojáků, policistů a zdravotníků. Jedno z nejrozšířenějších jmen na světě."
        ),
        "milan": .init(
            language: "Slovanský",
            meaning: "Milý, příjemný, drahý (mil-)",
            funFact: "Typicky slovanské jméno bez přímého protějšku na Západě. Milan Kundera uchoval jméno ve světovém povědomí."
        ),
        "miroslav": .init(
            language: "Slovanský",
            meaning: "Mír + sláva",
            funFact: "Krásné dvousložkové slovanské jméno. Nosil ho Miroslav Tyrš - zakladatel Sokola. Zdrobnělina Míra/Mirek je oblíbená v celém středoevropském prostoru."
        ),
        "oldrich": .init(
            language: "Germánský",
            meaning: "Vládce dědičného majetku (Uodal + rich)",
            funFact: "Přemyslovský kníže Oldřich je znám legendou o Boženě - prosté selce, kterou si vzal za manželku. Jméno přišlo ze západní Evropy přes Německo."
        ),
        "ondrej": .init(
            language: "Řecký",
            meaning: "Mužný, statečný, chrabrý (andreios)",
            funFact: "Sv. Ondřej byl prvním apoštolem Ježíše. Je patronem Skotska, Ruska, Řecka a Rumunska. Ondřejský kříž má tvar X."
        ),
        "pavel": .init(
            language: "Latinský",
            meaning: "Malý, skromný (paulus)",
            funFact: "Apoštol Pavel původně jako Saul pronásledoval křesťany. Po zjevení na cestě do Damašku se obrátil a napsal 13 listů v Novém zákoně."
        ),
        "petr": .init(
            language: "Řecký",
            meaning: "Skála, kámen (petros)",
            funFact: "Toto jméno dal Šimonovi sám Ježíš: Na té skále postavím svou církev. Sv. Petr je prvním papežem. Petrova bazilika je největší kostel na světě."
        ),
        "radek": .init(
            language: "Slovanský",
            meaning: "Radostný, šťastný (rad-)",
            funFact: "Česká a slovenská zdrobnělina jmen jako Radoslav, Radmír nebo Radovan. Kořen rad- vyjadřující radost je typický pro slovanské jazyky."
        ),
        "radim": .init(
            language: "Slovanský",
            meaning: "Radostný, příjemný",
            funFact: "Sv. Radim (Gaudentius) byl vlastním bratrem sv. Vojtěcha a prvním hnězdenským arcibiskupem v Polsku. Jeho jméno je výhradně slovanské."
        ),
        "roman": .init(
            language: "Latinský",
            meaning: "Říman, pocházející z Říma (romanus)",
            funFact: "Jméno se šířilo spolu s křesťanstvím, které přišlo z Říma. Románské jazyky - francouzština, španělština, italština - nesou stejný základ."
        ),
        "stanislav": .init(
            language: "Slovanský",
            meaning: "Stát si za svou slávou (stan + sláva)",
            funFact: "Sv. Stanislav byl krakovský biskup, mučedník a patron Polska. Je pohřben na Wawelu - symbolickém srdci Polska."
        ),
        "stepan": .init(
            language: "Řecký",
            meaning: "Koruna, věnec (stephanos)",
            funFact: "Sv. Štěpán byl prvním křesťanským mučedníkem (protomartyrem). Jeho svátek je 26. 12. Anglický Boxing Day je vlastně svátek sv. Štěpána."
        ),
        "tomas": .init(
            language: "Aramejský",
            meaning: "Dvojče (Te'oma)",
            funFact: "Apoštol Tomáš uvěřil Kristovu zmrtvýchvstání až po vložení prstů do ran - odtud nevěřící Tomáš. Poté šel šířit evangelium až do Indie."
        ),
        "vaclav": .init(
            language: "Slovanský",
            meaning: "Více slávy, slavnější (věnce + sláva)",
            funFact: "Sv. Václav je patronem Čech. Korunovační klenoty jsou uloženy v zámku s deseti zámky - klíče drží deset různých institucí."
        ),
        "viktor": .init(
            language: "Latinský",
            meaning: "Vítěz (victor)",
            funFact: "Latinský kořen victoria dal jméno britské královně Viktorii, jejíž éra se jmenuje viktoriánská. Jméno Viktor bylo oblíbené u římských vojevůdců."
        ),
        "vladimir": .init(
            language: "Slovanský",
            meaning: "Vladař světa (vlád + mir/svět)",
            funFact: "Kníže Vladimír I. Veliký christianizoval Kyjevskou Rus v roce 988 - jeden z nejvýznamnějších milníků v dějinách východní Evropy."
        ),
        "vojtech": .init(
            language: "Slovanský",
            meaning: "Ten, kdo těší vojsko (voj + těch)",
            funFact: "Sv. Vojtěch byl pražský biskup, který odešel šířit víru k pohanským Prusům u Baltského moře a byl zabit. Je patronem Čech, Polska a Maďarska."
        ),
        "zdenek": .init(
            language: "Slovanský / Latinský",
            meaning: "Z latinského Sidonius - stvořený ze Sidonie",
            funFact: "Jméno je výhradně české - v jiných jazycích ekvivalent nenajdete. Vzniklo z latinského Sidonius přes Sezima, Zdenco, Zdeněk."
        ),

        // ═══ ZENSKA JMENA ═══

        "adela": .init(
            language: "Germánský",
            meaning: "Vznešená, šlechtická (adal = vznešený rod)",
            funFact: "Oblíbené jméno v královských rodinách. Varianta Adelaide dala jméno australskému městu Adelaide."
        ),
        "alena": .init(
            language: "Řecký",
            meaning: "Zářivá, světlá, krásná",
            funFact: "Česká a slovenská varianta jména Helena. Jinde ve světě se Alena skoro nevyskytuje - je to ryze středoevropská forma."
        ),
        "alice": .init(
            language: "Germánský",
            meaning: "Vznešeného rodu (zkrácenina jména Adelheid)",
            funFact: "Jméno světově proslavila Alenka v říši divů Lewise Carrolla (1865). V češtině se používá Alenka pro pohádkovou postavu, Alice pro skutečné osoby."
        ),
        "andrea": .init(
            language: "Řecký",
            meaning: "Statečná, mužná (andreios)",
            funFact: "Ženská forma Ondřejova jména. Zajímavost: v Itálii je Andrea výhradně mužské jméno. V české tradici je to naopak ženské jméno."
        ),
        "anna": .init(
            language: "Hebrejský",
            meaning: "Milost, laskavost (Channa)",
            funFact: "Jedno z nejrozšířenějších jmen vůbec - nosí ho nebo nosilo přes 300 milionů žen. V Čechách se říká, že každá druhá babička je Anna."
        ),
        "barbora": .init(
            language: "Řecký",
            meaning: "Cizinka, nesrozumitelně mluvící (barbaros)",
            funFact: "Sv. Barbora je patronkou havířů a dělostřelců. Na Barbory (4. 12.) se dávají do vázy větvičky - rozkvetou-li do Vánoc, bude se dívce dařit v lásce."
        ),
        "blanka": .init(
            language: "Germánský",
            meaning: "Světlá, bílá, zářivá (blank)",
            funFact: "Ve francouzštině Blanche, italsky Bianca - vše znamená bílá. Blanka z Valois byla první manželkou Karla IV."
        ),
        "bozena": .init(
            language: "Slovanský",
            meaning: "Bohem daná, božská",
            funFact: "Božena Němcová napsala Babičku - nejčtenější české literární dílo všech dob. Její portrét je na stokorunové bankovce."
        ),
        "cecilie": .init(
            language: "Latinský",
            meaning: "Slepá (caecus); nebo z rodu Caeciliů",
            funFact: "Sv. Cecílie je patronkou hudby, protože prý zpívala Bohu, když ji vedli na popravu. Každý rok 22. 11. slaví svůj den hudebníci po celém světě."
        ),
        "dana": .init(
            language: "Hebrejský / Slovanský",
            meaning: "Soudkyně (dan), nebo zkrácenina jmen Daniela či Dagmar",
            funFact: "V keltské mytologii Dana je matkou bohů. V hebrejštině Dan = soudce. Jméno je velmi rozšířené ve středoevropských zemích."
        ),
        "diana": .init(
            language: "Latinský",
            meaning: "Božská, bohyně měsíce a lovu (div = záře)",
            funFact: "Řecky Artemis, latinsky Diana. Bohyně lovu lovila v lese s lukem a šípy. Jméno dnes proslavila princezna Diana."
        ),
        "edita": .init(
            language: "Anglosaský (germánský)",
            meaning: "Bohatá bojovnice (ead = bohatství + gyth = boj)",
            funFact: "Anglosaské jméno z doby před normanským výbojem. Sv. Edita Anglická byla dcerou krále Edgara Mírumilovného."
        ),
        "eliska": .init(
            language: "Hebrejský",
            meaning: "Bohem zaslíbená, Bůh je moje přísaha (Elisheba)",
            funFact: "Eliška Přemyslovna, manželka Jana Lucemburského a matka Karla IV., je jednou z nejvýznamnějších českých královen. Bez ní by nebyl Karel IV."
        ),
        "eva": .init(
            language: "Hebrejský",
            meaning: "Živoucí, matka života (Chava)",
            funFact: "Podle Bible Eva byla první žena - matka veškerého lidstva. Ve středověkém myšlení byl anagram Ave (pozdrav Marii) přepisem Eva."
        ),
        "gabriela": .init(
            language: "Hebrejský",
            meaning: "Boží žena, Bůh je moje síla (Gavriel)",
            funFact: "Ženská forma archanděla Gabriela, který zvěstoval Marii početí Ježíše. Gabriela Mistral (Chile) byla první latinskoamerická nositelka Nobelovy ceny za literaturu."
        ),
        "hana": .init(
            language: "Hebrejský",
            meaning: "Milost, přízeň, laskavost (Channa)",
            funFact: "Zkrácenina jmen Anna nebo Johanna. Biblická Hana trpěla neplodností a porodila proroka Samuela. V japonštině Hana nezávisle znamená květ."
        ),
        "helena": .init(
            language: "Řecký",
            meaning: "Zářivá, světlá (helene)",
            funFact: "Helena Trojská prý byla nejkrásnější žena světa, kvůli níž propukla trojská válka. Sv. Helena, matka Konstantina Velikého, prý nalezla Kristův kříž v Jeruzalémě."
        ),
        "ilona": .init(
            language: "Řecký / Maďarský",
            meaning: "Zářivá, světlá - maďarská varianta Heleny",
            funFact: "Jméno přišlo do Čech přes Maďarsko ve středověku. V maďarské mytologii Ilona je víla žijící ve zlatém zámku."
        ),
        "irena": .init(
            language: "Řecký",
            meaning: "Mír (eirene)",
            funFact: "Eirene byla řecká bohyně míru. Irena Sendlerová zachránila přes 2 500 dětí z varšavského ghetta za 2. světové války."
        ),
        "jana": .init(
            language: "Hebrejský",
            meaning: "Bůh je milostivý - ženská forma Jana",
            funFact: "Nejslavnější nositelkou je Johanka z Arku - francouzská národní hrdinka, která vedla armádu ve věku 17 let. V 19 letech byla upálena. Svatořečena 1920."
        ),
        "jarmila": .init(
            language: "Slovanský",
            meaning: "Milující jaro, jarní a milá (jaro + milá)",
            funFact: "Typicky česko-slovenské jméno bez ekvivalentu v jiných jazycích. Jarní nálada v něm vibruje doslova."
        ),
        "jitka": .init(
            language: "Hebrejský",
            meaning: "Judejka, žena z Judeje (Judith)",
            funFact: "Biblická Judita zachránila svůj lid tím, že sťala asyrského vojevůdce Holoferna. Motiv zpracoval Klimt ve slavném obraze."
        ),
        "jolana": .init(
            language: "Řecký / Francouzský",
            meaning: "Fialka (ion) - nebo varianta jména Violanta",
            funFact: "Ve Francii bylo Yolande oblíbené šlechtické jméno. Jolana Kyjevská byla sestrou Oldřicha III. Přemyslovce. Fialka jako symbol skromnosti a věrnosti."
        ),
        "karolina": .init(
            language: "Germánský (latinizovaný)",
            meaning: "Svobodná žena - ženská forma Karla (Karolus)",
            funFact: "Americké státy Severní a Jižní Karolína jsou pojmenovány po anglickém králi Karlu II."
        ),
        "katerina": .init(
            language: "Řecký",
            meaning: "Čistá, neposkvrněná (katharos)",
            funFact: "Sv. Kateřina Alexandrijská přemohla v disputaci 50 pohanských filosofů. Je patronkou studentů, vědců a filosofů. Zdrobněliny Katka, Kačka, Káťa jsou typicky české."
        ),
        "klara": .init(
            language: "Latinský",
            meaning: "Jasná, zářivá, slavná (clara)",
            funFact: "Sv. Klára z Assisi byla nejbližší přítelkyní Františka z Assisi a zakladatelkou řádu klarisek. Prý odradila útočníky od Assisi tím, že jim vyšla vstříc s Nejsvětější svátostí."
        ),
        "kristyna": .init(
            language: "Řecký / Latinský",
            meaning: "Křesťanka, Kristova (Christiana)",
            funFact: "Švédská královna Kristýna (17. stol.) abdikovala z trůnu, konvertovala ke katolicismu a odešla do Říma. Česká zdrobnělina Kristýnka je ve světě zcela unikátní."
        ),
        "lenka": .init(
            language: "Slovanský / Řecký",
            meaning: "Krásná - česká domácká forma Heleny nebo Magdalény",
            funFact: "Jméno Lenka je téměř výhradně české a slovenské. Je to výborný příklad toho, jak si čeština přizpůsobila cizí jméno."
        ),
        "linda": .init(
            language: "Germánský / Španělský",
            meaning: "Měkká jako lípová kůra (lind); ve španělštině krásná",
            funFact: "V germánských jazycích pochází od lind (měkký, hadí štít). Ve španělštině linda = krásná. Obě etymologie jsou nezávislé. Dnes je Linda celosvětově rozšířené jméno."
        ),
        "lucie": .init(
            language: "Latinský",
            meaning: "Světlá, zářivá (lux = světlo)",
            funFact: "Sv. Lucie (13. 12.) je patronkou zraku a slepých. Ve Skandinávii se svátek slaví průvodem dívek se svícemi - připomínka světla v temnotě předvánočního času."
        ),
        "ludmila": .init(
            language: "Slovanský",
            meaning: "Milá lidem, lidu milá (ľud + milá)",
            funFact: "Sv. Ludmila, babička sv. Václava, je první česká světice a mučednice. Byla uškrcena na hradě Tetíně na příkaz Drahomíry."
        ),
        "magdalena": .init(
            language: "Hebrejský",
            meaning: "Z Magdaly - města na břehu Genezaretského jezera",
            funFact: "Marie Magdalena první spatřila vzkříšeného Krista. Je patronkou hříšníků a kajícníků."
        ),
        "marketa": .init(
            language: "Řecký",
            meaning: "Perla (margarites)",
            funFact: "Jméno je jednou z nejrozšířenějších jmenných rodin světa: Margaret, Marguerite, Margareta, Greta, Maggie, Peggy. Sv. Markéta je patronkou těhotných žen."
        ),
        "martina": .init(
            language: "Latinský",
            meaning: "Patřící bohu Martovi, válečná - ženská forma Martina",
            funFact: "Sv. Martina je patronkou Říma. Slavná tenistka Martina Navrátilová je jednou z největších sportovkyní všech dob - vyhrála 18 grandslamů."
        ),
        "marie": .init(
            language: "Hebrejský",
            meaning: "Milovaná Bohem, vyvýšená; nebo hořká (Mirjam)",
            funFact: "Nejrozšířenější ženské jméno v historii - odhadem přes 70 milionů nositelek jen v přímé formě Marie/Maria. Panna Maria je patronkou desítek zemí."
        ),
        "michaela": .init(
            language: "Hebrejský",
            meaning: "Kdo je jako Bůh? - ženská forma Michala",
            funFact: "Archanděl Michael velí nebeské armádě. V judaismu, křesťanství i islámu je jedním z nejvýznamnějších andělů."
        ),
        "monika": .init(
            language: "Latinský / Řecký",
            meaning: "Osamělá (monos); nebo poradkyně (monere)",
            funFact: "Sv. Monika je matkou sv. Augustina. Ten byl zprvu bohém, pak nejvýznamnější filosof raného křesťanství. Říká se, že za jeho obrácením stály Moničiny slzy."
        ),
        "natalie": .init(
            language: "Latinský",
            meaning: "Narozená o Vánocích (natalis dies Domini)",
            funFact: "Jméno bylo původně dáváno dívkám narozeným 25. 12. nebo v době Vánoc. V Rusku populární jako Nataša - proslavila ji hrdinka Tolstého Vojny a míru."
        ),
        "nikola": .init(
            language: "Řecký",
            meaning: "Vítěz lidu (nike = vítězství + laos = lid)",
            funFact: "Ženská forma Mikuláše/Nikolase. Sv. Mikuláš z Myry je předobrazem Santy Clause. V Čechách je Nikola populární od 90. let."
        ),
        "olga": .init(
            language: "Severský (skandinávský)",
            meaning: "Posvátná, blahoslavená (Helga)",
            funFact: "Jméno přišlo přes varjažské obchodníky (Vikingy) do Kyjevské Rusi. Sv. Olga Kyjevská jako první ruská panovnice přijala křest (957)."
        ),
        "pavlina": .init(
            language: "Latinský",
            meaning: "Malá, skromná - ženská forma Pavla (Paulina)",
            funFact: "Paulina Borghese, sestra Napoleona Bonaparta, nechala vytvořit slavnou mramorovou sochu od Canovy. Dnes je v Galerii Borghese v Římě."
        ),
        "petra": .init(
            language: "Řecký",
            meaning: "Skalní, pevná jako skála (petra = kámen)",
            funFact: "Petra je také antické město v Jordánsku vytesané do červených skal - jedno ze sedmi divů světa a sídlo Nabatejců."
        ),
        "radka": .init(
            language: "Slovanský",
            meaning: "Radostná, šťastná (rad-)",
            funFact: "Zdrobnělina jmen Radmila, Radoslava. Typicky česká a slovenská forma bez ekvivalentu na Západě."
        ),
        "renata": .init(
            language: "Latinský",
            meaning: "Znovuzrozená, obrozená (renata)",
            funFact: "Jméno symbolizuje křesťanský křest jako znovuzrození. Bylo oblíbené v italské renesanci. Renesance sama = znovuzrození (rinascimento)."
        ),
        "romana": .init(
            language: "Latinský",
            meaning: "Římanská, pocházející z Říma",
            funFact: "Ženská forma Romana. Románské jazyky - francouzština, španělština, italština - nesou stejný základ jako toto jméno."
        ),
        "sara": .init(
            language: "Hebrejský",
            meaning: "Kněžna, šlechtičná, princezna (sarah)",
            funFact: "Biblická Sára porodila Izáka ve věku 90 let - zázrak plodnosti. Je matkou všech věřících tří abrahamských náboženství."
        ),
        "simona": .init(
            language: "Hebrejský",
            meaning: "Ta, která slyší (shama = slyšet)",
            funFact: "Ženská forma Šimona. Simone de Beauvoir - francouzská filosofka - zásadně ovlivnila feminismus knihou Druhé pohlaví (1949)."
        ),
        "tereza": .init(
            language: "Řecký",
            meaning: "Letní, žnec (therizein = žnout, sklízet)",
            funFact: "Dvě slavné světice: Sv. Tereza z Ávily je první žena prohlášená Doktorem církve. Sv. Tereza z Lisieux je patronka misií a nejoblíbenější světice 20. stol."
        ),
        "vera": .init(
            language: "Latinský / Slovanský",
            meaning: "Pravdivá (vera); nebo Víra (věra) ve slovanském výkladu",
            funFact: "Jméno má dvojí nezávislý původ. V Rusku bylo oblíbené u carevičen. Vera Wang je slavná návrhářka. Vera Lynn zpívala britským vojákům za 2. světové války."
        ),
        "veronika": .init(
            language: "Řecký / Latinský",
            meaning: "Přinášející vítězství (phero + nike); nebo Pravý obraz (vera icon)",
            funFact: "Sv. Veronika utřela Ježíšovi tvář rouškou - na níž se otiskl jeho obraz. Je patronkou fotografů. Slavná Rouška Veroničina je uchována ve Vatikánu."
        ),
        "zita": .init(
            language: "Germánský / Italský",
            meaning: "Dívka, panna; nebo hledaná (z gótu zito)",
            funFact: "Sv. Zita z Lukky je patronkou hospodyněk a sluhů - prý tajně dávala chudým chléb, který se přeměnil v květiny. Poslední rakouská císařovna nesla toto jméno."
        ),
        "zlata": .init(
            language: "Slovanský",
            meaning: "Zlatá, zlatavá - od slova zlato",
            funFact: "Typicky slovanské jméno symbolizující vzácnost. Zlatá Praha - tak se říká hlavnímu městu Čech kvůli zlatým chrámovým střechám."
        ),
        "zofie": .init(
            language: "Řecký",
            meaning: "Moudrost (sophia)",
            funFact: "Hagia Sophia v Konstantinopoli (dnes Istanbul) = Boží moudrost. Tento chrám byl po tisíc let největší stavbou světa. Filosofie = láska k moudrosti (philo + sophia)."
        ),
        "zuzana": .init(
            language: "Hebrejský",
            meaning: "Lilie (shoshan)",
            funFact: "Biblická Zuzana odolala nátlaku starců a byla osvobozena prorokem Danielem. Lilie je symbolem čistoty a nevinnosti."
        ),
        "aneta": .init(
            language: "Hebrejský",
            meaning: "Milost, přízeň (zdrobnělina Anny z hebrejského Channa)",
            funFact: "Aneta je slovanská zdrobnělá forma Anny. Jméno Anna je jedno z nejrozšířenějších na světě - odhaduje se, že ho nosí nebo nosilo přes 300 milionů žen."
        ),
        "denisa": .init(
            language: "Řecký",
            meaning: "Zasvěcená Dionýsovi, bohu vína a veselí (Dionysios)",
            funFact: "Jméno Denisa pochází od Dionýsa, řeckého boha vína a divadla. Dionýsos byl jediný olympský bůh narozený ze smrtelné matky, přesto dosáhl plného božství."
        ),
        "dorota": .init(
            language: "Řecký",
            meaning: "Boží dar (doron = dar + theos = bůh)",
            funFact: "Dorota je polská, česká a slovenská forma Dorothey. Zajímavostí je, že Dorothy a Theodora jsou anagramy - obsahují stejná řecká slova, jen v opačném pořadí."
        ),
        "emilie": .init(
            language: "Latinský",
            meaning: "Soupeřivá, snaživá, pilná (aemulus = soupeř)",
            funFact: "Jméno pochází z římského rodu Aemiliů. Via Aemilia - slavná římská silnice v severní Itálii - dala jméno celé oblasti Emilia-Romagna."
        ),
        "ivana": .init(
            language: "Slovanský (z hebrejského)",
            meaning: "Bůh je milostivý - ženská forma Ivana/Jana",
            funFact: "Ivana je ženská podoba slovanského Ivan. V Chorvatsku bylo jméno Ivana nejoblíbenějším ženským jménem po celou epochu 1970-1999."
        ),
        "iveta": .init(
            language: "Slovanský (z hebrejského)",
            meaning: "Bůh je milostivý - zdrobnělá forma Ivany/Jany",
            funFact: "Iveta je česká a slovenská zdrobnělina Ivany, tedy vzdálená příbuzná hebresjkého Yochanan přes řecký Ioannes a slovanský Ivan. Svátek slaví spolu s Ivanou."
        ),
        "jirina": .init(
            language: "Řecký",
            meaning: "Zemědělka, rolnice - ženská forma Jiřího (georgos = zemědělec)",
            funFact: "Jiřina je česká forma Georginky. Jméno Jiří/Georgios nosili patroni Anglie, Gruzie, Španělska i Litvy - Jiří je tedy patrně nejuniverzálnějším patronem světa."
        ),
        "kamila": .init(
            language: "Latinský (etruský původ)",
            meaning: "Pomocnice při obřadech, vznešená dívka (camilla)",
            funFact: "Camilla je v Aeneidě Vergilia statečná válečná dívka, bojovnice kmene Volsků. Jméno nese i manželka britského krále Karla III."
        ),
        "lada": .init(
            language: "Slovanský",
            meaning: "Harmonie, soulad, krása (lad = řád, harmonie)",
            funFact: "Lada je ve slovanské mytologii bohyně lásky a krásy. Česká lidová píseň Lada, lada, lada opěvuje jaro a probouzení přírody."
        ),
        "lea": .init(
            language: "Hebrejský",
            meaning: "Unavená nebo divoká kráva (le'ah); v jiných tradicích louka",
            funFact: "Biblická Lea byla první manželkou Jákoba a matkou šesti z dvanácti praotců Izraele. Přestože Jákob miloval více její sestru Ráchel, Lea mu dala více synů."
        ),
        "libuse": .init(
            language: "Slovanský",
            meaning: "Milá, příjemná, milovaná (libý = příjemný, lubiti = milovat)",
            funFact: "Podle pověsti kněžna Libuše prorokovala založení Prahy slovy: Vidím město veliké... a provdala se za oráče Přemysla, zakladatele první české dynastie. Smetana ji oslavil operou."
        ),
        "lubomira": .init(
            language: "Slovanský",
            meaning: "Milující mír, láska a mír (lub + mir)",
            funFact: "Ženská forma Lubomíra. Kořen mir (mír, svět) je sdílen s Miroslavou, Vladimírou i Slavomírou - patří k nejvýraznějším prvkům slovanské jmenné tradice."
        ),
        "marcela": .init(
            language: "Latinský",
            meaning: "Malá válečnice, zasvěcená bohu Martovi (Marcellus = zdrobnělina Marca)",
            funFact: "Marcel/Marcela jsou zdrobněliny Marca, odvozené od Marta - boha války. Sv. Marcela Římská (4. stol.) prodala veškerý majetek a věnovala výtěžek chudým."
        ),
        "marta": .init(
            language: "Aramejský",
            meaning: "Paní, milenka, hospodyně (marta = paní domu)",
            funFact: "Biblická Marta z Betánie se starala o domácnost, zatímco sestra Marie poslouchala Ježíše. Odtud přídavné jméno martovský pro prakticky zaměřeného člověka."
        ),
        "milena": .init(
            language: "Slovanský",
            meaning: "Milá, laskavá, drahá (milŭ = milý, příjemný)",
            funFact: "Jméno nese kořen mil-, z něhož vycházejí desítky slovanských jmen: Milan, Miloslav, Milada. Milena Jesenská byla česká novinářka a velká láska Franze Kafky."
        ),
        "miloslava": .init(
            language: "Slovanský",
            meaning: "Slavná laskavostí, milostivá sláva (milŭ + slava)",
            funFact: "Ženská forma Miloslava. Dvousložková jména s mil- a slav- jsou typickým znakem slovanské jmenné tradice sahající do raného středověku."
        ),
        "nora": .init(
            language: "Latinský / Irský",
            meaning: "Čestná, uctivá - zkrácenina Honory (honor = čest) nebo Eleonory",
            funFact: "Nora je proslavená jako hlavní postava Ibsenovy hry Nora aneb domeček pro panenky (1879), která je považována za jedno ze zakladatelských děl moderního dramatu."
        ),
        "patricie": .init(
            language: "Latinský",
            meaning: "Šlechtična, příslušnice patricijů (patricius = šlechtic, od pater = otec)",
            funFact: "Patriciové byli nejvyšší vrstvou starořímské společnosti. Slova patronát, patron i patriarchát pocházejí ze stejného latinského základu pater (otec)."
        ),
        "pavla": .init(
            language: "Latinský",
            meaning: "Malá, skromná - ženská forma Pavla (paulus = malý)",
            funFact: "Pavla je ženská forma apoštola Pavla, původně Saula z Tarsu. Apoštol Pavel napsal 13 listů Nového zákona a podnikl tři misijní cesty po celém Středomoří."
        ),
        "ruzena": .init(
            language: "Slovanský (z latinského)",
            meaning: "Růže (od latinského rosa přes slovanské růže)",
            funFact: "Růžena je česká forma Rosalie. Růže je symbolem Panny Marie a ve středověku bylo pěstování růží soustředěno v klášterních zahradách - mnohé odrůdy tak přežily díky mnichům."
        ),
        "sabina": .init(
            language: "Latinský",
            meaning: "Sabinka, žena ze Sabinů - antický italický národ (Sabinus)",
            funFact: "Sabinové byli starořímský lid, jehož ženy Římané v legendě unesli. Sabinky pak zastavily válku tím, že se postavily mezi bojující muže - symbol smíření."
        ),
        "sylva": .init(
            language: "Latinský",
            meaning: "Lesní, z lesa (silva = les)",
            funFact: "Sylva/Sylvie pochází od latinského silva (les). Silvanus byl římský bůh lesů a polí. Francouzská forma Sylvie inspirovala básníky romantismu - např. Nervalovu báseň Sylvie."
        ),
        "vendula": .init(
            language: "Slovanský",
            meaning: "Domácká forma Václavy - slavnější, více slávy (věnce + sláva)",
            funFact: "Vendula vznikla jako domácká zkrácenina Václavy, ženské formy jména Václav. Václav je patronem Čech, a tak Vendula nese ve svém původu odkaz na nejdůležitějšího českého světce."
        ),
        "viola": .init(
            language: "Latinský",
            meaning: "Fialka (viola = fialový květ)",
            funFact: "Viola označuje v latině fialku i hudební nástroj violu. Shakespearova hrdinka Viola v Večeru tříkrálovém se přestrojila za muže - patří k nejoblíbenějším shakespearovským postavám."
        ),
        "vlasta": .init(
            language: "Slovanský",
            meaning: "Vlast, moc, vláda (vlast = rodná zem, vlast = moc)",
            funFact: "Podle staré pověsti vedla bojovnice Vlasta rebelii dívek proti mužské nadvládě - tzv. Dívčí válka. Místo jejích bojů Divoká Šárka je dnes přírodní rezervací v Praze."
        ),
        "zdislava": .init(
            language: "Slovanský",
            meaning: "Vytvořená slávou, budující slávu (zídati = budovat + slava = sláva)",
            funFact: "Sv. Zdislava Berková (13. stol.) byla česká šlechtična proslulá péčí o nemocné a chudé. Svatořečena Janem Pavlem II. v Olomouci v roce 1995, je patronkou rodin."
        ),

        // MARK: - Vybrane zdrobneliny a varianty

        "anezka": .init(
            language: "Řecký",
            meaning: "Čistá, nevinná, posvátná (hagnos)",
            funFact: "Sv. Anežka Česká byla Přemyslovna, která odmítla nabídky císaře a papeže a stala se řeholnicí. Svatořečena Janem Pavlem II. v roce 1989 - 39 dní před Sametovou revolucí."
        ),
        "agata": .init(
            language: "Řecký",
            meaning: "Dobrá, laskavá (agathos = dobrý)",
            funFact: "Sv. Agáta je patronkou Sicílie. Agatha Christie je nejprodávanější autorkou detektivek v historii."
        ),
        "alzbeta": .init(
            language: "Hebrejský",
            meaning: "Bohem zaslíbená, Bůh je moje přísaha (Elisheba)",
            funFact: "Nejslavnější Alžbětou je Alžběta II. - nejdéle vládnoucí britská panovnice (70 let). Alžbětinská éra = zlatý věk anglické literatury (Shakespeare)."
        ),
        "beata": .init(
            language: "Latinský",
            meaning: "Blahoslavená, šťastná (beata)",
            funFact: "Kořen beatus/beata dal základ slovům beatifikace (blahořečení) a beatitudo (blaženost). V Dantově Božské komedii jsou duše v nebi označovány jako beati."
        ),
        "brigita": .init(
            language: "Keltský (irský)",
            meaning: "Vznešená, silná, vysoká (Brigid/Brighid)",
            funFact: "Sv. Brigita Irská je jednou ze tří patronů Irska. Keltská bohyně Brigid byla bohyní ohně, poezie a řemesla. Brigitský kříž je symbolem Irska."
        ),
        "hedvika": .init(
            language: "Germánský",
            meaning: "Bojovnice, válčí moc (hadu + wig = boj + válka)",
            funFact: "Sv. Hedvika Slezská (13. stol.) je patronkou Polska a Slezska. Polský král Vladislav II. Jagellonský se oženil s Hedvikou a vznikl polsko-litevský stát."
        ),
        "ingrid": .init(
            language: "Severský (skandinávský)",
            meaning: "Krásná jako bůh Ing (Ing + fridhr = krásný)",
            funFact: "Skandinávské jméno, které se rozšířilo do celé Evropy. Ingrid Bergman - švédská herečka - ztvárnila Casablanku a získala tři Oscary."
        ),

        // MARK: - Dalsi muzska jmena

        "arnost": .init(
            language: "Germánský",
            meaning: "Vážný, houževnatý, bojovný orel (Arnust = arn + ust)",
            funFact: "Arnošt z Pardubic byl v roce 1344 jmenován prvním arcibiskupem pražským - Praha se tak stala arcibiskupstvím nezávislým na Mohuči. Bez Arnošta by nebyl ani Karel IV."
        ),
        "bartolomej": .init(
            language: "Hebrejský / Aramejský",
            meaning: "Syn Talmaie (bar + Talmai = ten, kdo brázdí)",
            funFact: "Apoštol Bartoloměj byl podle tradice stažen z kůže zaživa - je patronem koželuhů. Masakr na svátek sv. Bartoloměje (24. 8. 1572) v Paříži si vyžádal tisíce hugenottských životů."
        ),
        "bedrich": .init(
            language: "Germánský",
            meaning: "Mírumilovný vládce (frid = mír + ric = vládce)",
            funFact: "Bedřich Smetana složil Vltavu - nejznámější českou orchestrální skladbu světa. Psal ji, když byl zcela hluchý. Friedrich Nietzsche i Friedrich Schiller nesli toto slavné jméno."
        ),
        "blazej": .init(
            language: "Latinský / Řecký",
            meaning: "Koktající nebo zářící (blaisos)",
            funFact: "Sv. Blažej (3. 2.) je patronem krční nemocí - kněží v tento den žehnají hrdlům věřících dvěma zkříženými svícemi. Legenda říká, že zachránil dítě, jemuž uvízla kost v hrdle."
        ),
        "bohumil": .init(
            language: "Slovanský",
            meaning: "Bohu milý, Bohem milovaný (bohu + milý)",
            funFact: "Bohumil Hrabal je jedním z nejpřekládanějších českých prozaiků - napsal Ostře sledované vlaky a Příliš hlučnou samotu. Psal v hospodách, zejména v pražském Zlatém tygru."
        ),
        "ferdinand": .init(
            language: "Germánský (vizigótský)",
            meaning: "Odvážný cestovatel (ferd = cesta + nand = odvaha)",
            funFact: "Ferdinand Magellan jako první obeplul zeměkouli (1519-1522). Jméno neslo pět španělských králů a řada habsburských císařů, kteří vládli i Čechám."
        ),
        "gabriel": .init(
            language: "Hebrejský",
            meaning: "Bůh je má síla (Gavriel = Bůh + el)",
            funFact: "Archanděl Gabriel zvěstoval Marii početí Ježíše a v islámu diktoval Mohammedovi Korán. Je patronem komunikace - dnes i telekomunikací a novinářů."
        ),
        "gustav": .init(
            language: "Severský (švédský)",
            meaning: "Opora Gótů (Gautr + stafr = hůl, opora)",
            funFact: "Slavní nositelé: Gustav Klimt maloval zlatem, Gustave Eiffel postavil věž v Paříži a Gustav Mahler složil 10 symfonií. Jméno neslo šest švédských králů od 16. století."
        ),
        "herman": .init(
            language: "Germánský",
            meaning: "Válečník, muž vojska (heri = vojsko + man = muž)",
            funFact: "Germánský Arminius (Heřman) porazil v roce 9 n. l. tři římské legie v bitvě v Teutoburském lese a zastavil expanzi Říma do Germánie. Herman Melville napsal Moby Dicka."
        ),
        "hubert": .init(
            language: "Germánský",
            meaning: "Zářivý duch, světlá mysl (hug = duch + beraht = zářivý)",
            funFact: "Sv. Hubert je patronem myslivců - prý při lovu spatřil jelena se zářícím křížem mezi parohy a obrátil se na víru. Hubertovy jízdy a mše jsou v Evropě tradicí dodnes."
        ),
        "jachym": .init(
            language: "Hebrejský",
            meaning: "Bůh ustanoví, Bůh pozdvihne (Yehoyaqim)",
            funFact: "Jáchym je tradičně považován za otce Panny Marie. České město Jáchymov dalo svým stříbrným tolarem základ slovu dollar - tolar pochází z Joachimsthaler."
        ),
        "jaromir": .init(
            language: "Slovanský",
            meaning: "Jarý mír, mír jara (jaro + mír)",
            funFact: "Přemyslovský kníže Jaromír vládl Čechám třikrát - pokaždé byl vyhnán a pokaždé se vrátil. Jméno nese i nejslavnější český hokejista všech dob - Jaromír Jágr."
        ),
        "kazimir": .init(
            language: "Slovanský",
            meaning: "Ten, kdo hlásá mír (kazati = kázat + mír)",
            funFact: "Kazimír Veliký převzal Polsko dřevěné a zanechal kamenné - je nejslavnějším polským středověkým králem. Kazimír Malevič namaloval Černý čtverec - první ryze abstraktní obraz."
        ),
        "klement": .init(
            language: "Latinský",
            meaning: "Mírný, milosrdný, laskavý (clemens)",
            funFact: "Sv. Klement I. byl čtvrtým papežem - jeho jméno neslo 14 dalších papežů. Klement Gottwald byl prvním komunistickým prezidentem Československa od února 1948."
        ),
        "leos": .init(
            language: "Slovanský / Latinský",
            meaning: "Lev - domácká forma Leopoldova nebo ze slova lev",
            funFact: "Leoš Janáček je jedním z nejvýznamnějších českých skladatelů - opery Její pastorkyňa a Věc Makropulos patří k repertoáru světových scén. Svá nejslavnější díla složil po šedesátce."
        ),
        "leopold": .init(
            language: "Germánský",
            meaning: "Odvážný lid (leud = lid + bald = odvážný, smělý)",
            funFact: "Leopold Mozart byl otcem a učitelem Wolfganga Amadea - od útlého věku ho vozil po evropských dvorech. Jméno neslo mnoho habsburských císařů, kteří vládli i Čechám."
        ),
        "ludvik": .init(
            language: "Germánský (franský)",
            meaning: "Slavný válečník (hlud = sláva + wig = boj)",
            funFact: "Jméno neslo 18 francouzských králů - Ludvík XIV. si říkal Král Slunce a Versailles bylo vzorem pro všechny evropské dvory. Ludwig van Beethoven složil 9 symfonií v době, kdy byl zcela hluchý."
        ),
        "matyas": .init(
            language: "Hebrejský",
            meaning: "Boží dar (Mattityahu = dar od Jahveho)",
            funFact: "Matyáš Korvín byl nejslavnější uherský renesanční král - budoval Budín jako centrum vědy. Apoštol Matyáš byl losem vybrán za nástupce Jidáše - jediný apoštol určený tímto způsobem."
        ),
        "mikulas": .init(
            language: "Řecký",
            meaning: "Vítěz lidu (nike = vítězství + laos = lid)",
            funFact: "Sv. Mikuláš z Myry tajně házel zlaté váčky chudým dívkám oknem - odtud zvyk dávání dárků. Přes holandský Sinterklaas se stal Santou Clausem - nejslavnější dárkovou postavou světa."
        ),
        "milos": .init(
            language: "Slovanský",
            meaning: "Milostivý, laskavý (milŭ = milý)",
            funFact: "Miloš Forman je jediný Čech, který dvakrát získal Oscara za nejlepší režii - za Přelet nad kukaččím hnízdem (1975) a Amadea (1984)."
        ),
        "mojmir": .init(
            language: "Slovanský",
            meaning: "Můj mír, vlastní mír (moj = můj + mír)",
            funFact: "Mojmír I. (zemřel 846) byl zakladatelem Velkomoravské říše - prvního státního celku na území dnešní Moravy a Slovenska. Byl pokřtěn salcburskými kněžími."
        ),
        "norbert": .init(
            language: "Germánský",
            meaning: "Zář severu (nord = sever + beraht = zářivý)",
            funFact: "Sv. Norbert z Xanten (12. stol.) je zakladatelem premonstrátského řádu - bílých mnichů. Premonstrátský klášter Strahov v Praze patří k nejkrásnějším klášterům středoevropského baroka."
        ),
        "oskar": .init(
            language: "Severský / Anglosaský",
            meaning: "Boží kopí, božský válečník (os = bůh + gar = kopí)",
            funFact: "Oskar Schindler zachránil přes 1 200 Židů za druhé světové války. Filmová cena Oscar dostala přezdívku podle strýce jedné ze zakladatelek, který prý připomínal sochu."
        ),
        "patrik": .init(
            language: "Latinský",
            meaning: "Šlechtic, patricij (patricius = příslušník patricijského rodu)",
            funFact: "Sv. Patrik (17. 3.) vysvětlil Trojici pomocí trojlístku jetele - odtud irský symbol. Den sv. Patrika slaví stovky měst po celém světě, včetně řeky obarvené zeleně v Chicagu."
        ),
        "premysl": .init(
            language: "Slovanský",
            meaning: "Přemýšlivý, ten kdo vše promyslí (přemysl = promyšlenost)",
            funFact: "Přemysl Oráč je legendárním zakladatelem přemyslovské dynastie - Libuše si ho vybrala za manžela při orbě na poli. Přemyslovci vládli Čechám přes 400 let."
        ),
        "rastislav": .init(
            language: "Slovanský",
            meaning: "Rozrůstající se sláva (rasti = růst + slava)",
            funFact: "Kníže Rastislav Moravský pozval v roce 863 Cyrila a Metoděje, aby přinesli křesťanství ve slovanském jazyce - tím dal podnět ke vzniku první slovanské abecedy a literatury."
        ),
        "richard": .init(
            language: "Germánský",
            meaning: "Mocný vládce (ric = moc + hard = silný, tvrdý)",
            funFact: "Richard Lví srdce vedl třetí křížovou výpravu - přestože byl anglickým králem, v Anglii strávil pouhých šest měsíců. Richard Wagner složil čtyřdílný cyklus Prsten Nibelungů."
        ),
        "robert": .init(
            language: "Germánský",
            meaning: "Zářivou slávou proslulý (hrod = sláva + beraht = zářivý)",
            funFact: "Robert Bruce porazil Angličany v bitvě u Bannockburnu (1314) a vydobyl Skotsku nezávislost. Legenda říká, že mu k vytrvalosti pomohl pavouk, který znovu a znovu spřádal síť."
        ),
        "rudolf": .init(
            language: "Germánský",
            meaning: "Slavný vlk (hrod = sláva + ulf = vlk)",
            funFact: "Rudolf II. Habsburský přesídlil císařský dvůr do Prahy - ta se stala vědeckým centrem Evropy. Pozval Tychona de Brahe a Keplera, kteří zde formulovali zákony pohybu planet."
        ),
        "samuel": .init(
            language: "Hebrejský",
            meaning: "Bůh vyslyšel (shama = slyšet + El = Bůh)",
            funFact: "Prorok Samuel pomazal prvního i druhého izraelského krále - Saula i Davida. Jméno Sam je jednou z nejuniverzálnějších zkrácenin světa - oblíbené od Anglie po Japonsko."
        ),
        "simon": .init(
            language: "Hebrejský",
            meaning: "Ten, kdo slyší (shama = slyšet)",
            funFact: "Apoštol Šimon Petr dostal od Ježíše nové jméno Petros (Skála) a stal se prvním papežem. Šimon Mág - čaroděj z Nového zákona - dal základ slovu simonie (kupování církevních úřadů)."
        ),
        "tadeas": .init(
            language: "Hebrejský / Aramejský",
            meaning: "Chválopěv, odvážné srdce (Thaddaeus)",
            funFact: "Apoštol Tadeáš je patronem beznadějných situací - říká se, že modlitby k němu pomáhají, když vše ostatní selže. Na Karlově mostě v Praze stojí jeho socha."
        ),
        "tibor": .init(
            language: "Latinský",
            meaning: "Od řeky Tibery (Tiberius = ten od Tibery)",
            funFact: "Tiberius byl druhý římský císař - nástupce Augusta. Řeka Tiber protéká přímo centrem Říma a Vatikánem, kolem Andělského hradu postaveného jako Hadriánovo mauzoleum."
        ),
        "valentin": .init(
            language: "Latinský",
            meaning: "Zdravý, silný, statný (valens = silný)",
            funFact: "Sv. Valentýn (14. 2.) byl popravený křesťanský kněz. Spojení s láskou pochází ze středověku - básníci věřili, že ptáci si v tento den vybírají partnera. Dnes je svátek oslavován ve stovkách zemí."
        ),
        "vavrinec": .init(
            language: "Latinský",
            meaning: "Z Laurentu, vavřínový (Laurentius)",
            funFact: "Sv. Vavřinec byl upečen na roštu a podle legendy polohu svého těla otočil slovy: Tato strana je hotova, obrante mě. Je patronem kuchařů a komiků. Jméno Lorenzo je italskou formou."
        ),
        "vilem": .init(
            language: "Germánský",
            meaning: "Ochránce vůle (wil = vůle + helm = přilba, ochrana)",
            funFact: "Vilém Dobyvatel ovládl Anglii v roce 1066 - bitva u Hastingsu přidala do angličtiny tisíce francouzských slov. Jméno neslo 4 anglické, 3 německé a 2 holandské krále."
        ),
        "vincenc": .init(
            language: "Latinský",
            meaning: "Vítězící, dobyvatel (vincere = vítězit)",
            funFact: "Vincent van Gogh prodal za života jediný obraz - přesto patří k nejdražším umělcům historie. Sv. Vincenc de Paul je patronem charitativní práce a pomocníků chudých."
        ),
        "vladislav": .init(
            language: "Slovanský",
            meaning: "Slavný vládce (vladeti = vládnout + slava)",
            funFact: "Vladislavský sál na Pražském hradě - největší gotický sál střední Evropy - dal postavit Vladislav II. Jagellonský. Byl tak rozlehlý, že se v něm konaly rytířské turnaje na koních."
        ),
        "vratislav": .init(
            language: "Slovanský",
            meaning: "Navracející se sláva (vrata = návrat + slava)",
            funFact: "Přemyslovský Vratislav II. byl v roce 1085 korunován prvním českým králem. Polské město Wroclaw (německy Breslau) nese jeho jméno - středověký latinský název byl Wratislavia."
        ),
        "zikmund": .init(
            language: "Germánský",
            meaning: "Vítězná ochrana (sieg = vítězství + mund = ochrana)",
            funFact: "Císař Zikmund svolal kostnický koncil (1414-1418), kde byl Jan Hus odsouzen a upálen. Zikmund mu přislíbil ochranu - tato zrada patří k nejcitlivějším místům českých dějin."
        ),

        // MARK: - Dalsi zenska jmena

        "amalie": .init(
            language: "Germánský",
            meaning: "Pracovitá, pilná (amal = práce, rod Amalů)",
            funFact: "Jméno bylo oblíbené v německých a skandinávských královských rodinách. Amálie van Oranje je současná holandská korunní princezna. Z tohoto jména vznikla zkrácenina Emma."
        ),
        "dagmar": .init(
            language: "Severský (dánský)",
            meaning: "Denní dívka, záře dne (dagr = den + maer = dívka)",
            funFact: "Dagmar z Čech (česky Markéta Přemyslovna) se provdala za dánského krále Valdemara II. a stala se milovanou dánskou královnou. Dodnes je v Dánsku symbolem ideální královny."
        ),
        "drahomira": .init(
            language: "Slovanský",
            meaning: "Drahá světu, vzácný mír (drahý + mír)",
            funFact: "Drahomíra byla matka sv. Václava a nechala zavraždit jeho babičku Ludmilu - dodnes symbol matky stojící v cestě dítěti. Přesto sama vychovala patrona Čech."
        ),
        "eleonora": .init(
            language: "Starofrancouzský / Provensálský",
            meaning: "Záře, světlo (alienor); nebo varianta Heleny",
            funFact: "Eleonora Akvitánská (12. stol.) byla nejmocnější žena středověku - nejprve královna Francie, poté Anglie. Sama vedla křížovou výpravu a mezi jejíma synama byl Richard Lví srdce."
        ),
        "ema": .init(
            language: "Germánský",
            meaning: "Celá, úplná, všeobsahující (ermen/emma = celek)",
            funFact: "Emma Bovaryová od Flauberta (1856) je jednou z nejslavnějších románových postav světové literatury. Jméno je dlouhodobě v top 10 nejoblíbenějších jmen v Anglii, Francii i Čechách."
        ),
        "emma": .init(
            language: "Germánský",
            meaning: "Celá, úplná, všeobsahující (ermen/emma = celek)",
            funFact: "Emma Bovaryová od Flauberta (1856) je jednou z nejslavnějších románových postav světové literatury. Jméno je dlouhodobě v top 10 nejoblíbenějších jmen v Anglii, Francii i Čechách."
        ),
        "evzenie": .init(
            language: "Řecký",
            meaning: "Vznešená, dobře zrozená (eu = dobře + genos = rod)",
            funFact: "Evženie Montijová byla manželkou Napoleona III. a poslední francouzská císařovna. Jméno Eugenia dala řada šlechtičen - od španělských vévodkyň po ruské carevičny."
        ),
        "julie": .init(
            language: "Latinský",
            meaning: "Z rodu Iuliů (Julius gens)",
            funFact: "Shakespearova Julie zemřela ve věku 13 let - asi nejznámější literární postava všech dob. Julius Caesar pocházel ze stejného rodu - slovo Caesar dalo základ slovům Kaiser i Car."
        ),
        "laura": .init(
            language: "Latinský",
            meaning: "Vavřínová, věnec ze vavřínu (laurus = vavřín)",
            funFact: "Petrarch se do Laury zamiloval pohledem v kostele (1327) a věnoval jí 366 sonetů sbírky Canzoniere. Laureát = ověnčený vavřínem - od Laury pochází titul pro nositele literárního ocenění."
        ),
        "leona": .init(
            language: "Latinský",
            meaning: "Lvice, ženský lev (leona od leo = lev)",
            funFact: "Lev je od starověku symbolem královské moci a odvahy. Zlatý lev je symbolem českého státního znaku - poprvé se objevil na pečeti Přemysla Otakara I. ve 12. století."
        ),
        "nadezda": .init(
            language: "Slovanský",
            meaning: "Naděje (naděje = Spes)",
            funFact: "Naděžda je slovanský překlad křesťanské ctnosti Spes - spolu s Vírou a Láskou tvoří trojici nejvyšších ctností. Naděžda Krupská byla manželkou a spolupracovnicí Vladimíra Lenina."
        ),
        "nela": .init(
            language: "Latinský / Hebrejský",
            meaning: "Zdrobnělina Daniely, Petronely nebo Cornélie",
            funFact: "Nela je oblíbená česká a slovenská domácká forma hned několika jmen. Cornelia, dcera Scipiona Africana, vychovala slavné římské reformátory Gracchy a odmítla nabídku k sňatku od egyptského krále."
        ),
        "rozalie": .init(
            language: "Latinský",
            meaning: "Růžová, z růží (rosalia = svátek růží)",
            funFact: "Sv. Rozálie je patronkou Palerma na Sicílii - prý zastavila morovou epidemii v roce 1625. Rosalia byl římský svátek, kdy se hroby zdobily růžemi a věřilo se v ochranu zemřelých."
        ),
        "sandra": .init(
            language: "Řecký",
            meaning: "Obránkyně lidí - zkrácenina Alexandry (alexein + aner)",
            funFact: "Sandra je italská zkrácenina Alessandry/Alexandry. Alexandr Makedonský dobyl největší říši starověku - jeho jméno v ženské podobě nosí miliony žen od Evropy po Japonsko."
        ),
        "sarka": .init(
            language: "Slovanský / Hebrejský",
            meaning: "Malá kněžna - nebo z hebrejského Sarah (kněžna)",
            funFact: "Podle staré pověsti se bojovnice Šárka dala uvázat ke stromu, lákadlem svedla Ctirada do léčky a spustila Dívčí válku. Přírodní rezervace Divoká Šárka v Praze nese její jméno dodnes."
        ),
        "tatana": .init(
            language: "Latinský (sabinský původ)",
            meaning: "Z kmene Tatiani - sabinský kmen žijící v Latiu",
            funFact: "Sv. Taťána (25. 1.) je patronkou ruských studentů - na Lomonosovově univerzitě se slaví Tatyanin den jako velký svátek. Taťána z Puškinova Evžena Oněgina je dodnes vzorem ruského ženství."
        ),
        "vilma": .init(
            language: "Germánský",
            meaning: "Ochránkyně vůle - ženská forma Viléma (wil + helm)",
            funFact: "Vilma je česká forma Wilhelminy. Holandská královna Wilhelmina odmítla kapitulovat před Hitlerem a z Londýna vedla odboj - stala se symbolem holandského odporu za 2. světové války."
        ),
        "zaneta": .init(
            language: "Francouzský (z hebrejského)",
            meaning: "Bůh je milostivý - francouzská zdrobnělina Jany (Jeannette)",
            funFact: "Žaneta je česká forma francouzského Jeannette - laskavé zdrobněliny jména Jeanne (Jana). Johanka z Arku ve věku 17 let vedla francouzskou armádu a zachránila Francii."
        ),
        "zora": .init(
            language: "Slovanský",
            meaning: "Ranní záře, úsvit (zora = jitřní červánky)",
            funFact: "Zora je slovanský ekvivalent latinské Aurory - bohyně jitřní záře. Ve slovanské mytologii přinášela Zora světlo do světa každé ráno, stejně jako Aurora otvírala bránu slunci."
        ),
    ]
}

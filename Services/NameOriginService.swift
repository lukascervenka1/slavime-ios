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

        // MARK: - Další doplněná jména

        "zacharias": .init(
            language: "Hebrejský",
            meaning: "Bůh si vzpomněl, Bůh pamatuje (Zekharyah)",
            funFact: "Zachariáš je biblický prorok i otec Jana Křtitele. Jméno proslavil i Zachariáš - postava ze Starého zákona, které přišel anděl Gabriel oznámit narození syna v jeho stáří. V Čechách je toto jméno vzácné, ale v anglofonním světě se Zachary/Zach těší velké oblibě."
        ),
        "zak": .init(
            language: "Hebrejský",
            meaning: "Zkrácenina jména Zachariáš - Bůh si vzpomněl",
            funFact: "Zak je moderní anglická zkrácenina hebrejského Zachariáš. Zachariáš byl starozákonní prorok, jehož kniha předpovídá příchod Mesiáše na oslu - naplněno Ježíšovým vjezdem do Jeruzaléma na Květnou neděli."
        ),
        "hynek": .init(
            language: "Germánský",
            meaning: "Vládce domova (česká forma jména Jindřich/Heinrich)",
            funFact: "Hynek je ryze česká podoba německého jména Heinrich. Neslavněji ho proslavil Hynek Otta z Boků - literární postava básně Máj od Karla Hynka Máchy. Sám básník Mácha byl Karlem, ale přidáním druhého jména Hynek vzdával hold starobylé češtině."
        ),
        "tamara": .init(
            language: "Hebrejský",
            meaning: "Palmový strom (tamar = palma, symbol krásy a plodnosti)",
            funFact: "Tamara je oblíbené jméno v gruzínském a ruském prostředí. Gruzínská královna Tamara Veliká (12.-13. stol.) vládla v době zlatého věku Gruzie - za její vlády vznikly eposy jako Vítěz v plášti tygří kůže."
        ),
        "radomir": .init(
            language: "Slovanský",
            meaning: "Šťastný mír, radostný a mírumilovný (rad + mír)",
            funFact: "Radomír byl přemyslovský kníže - syn Boleslava II. Byl zabit pouhých osm měsíců po nastoupení na trůn. Jméno spojuje radost (rad-) a mír - dva nejvyšší ideály slovanské kultury."
        ),
        "otakar": .init(
            language: "Germánský (ostrogótský)",
            meaning: "Střežící majetek, hlídač bohatství (aud = majetek + hari = strážce)",
            funFact: "Přemysl Otakar II. byl nazýván Železný a zlatý král - ovládal území od Baltu po Jaderské moře. Zahynul v bitvě na Moravském poli (1278) v boji s Rudolfem Habsburským - porážka změnila dějiny střední Evropy."
        ),
        "augustyn": .init(
            language: "Latinský",
            meaning: "Vznešený, posvátný (augustus = velebný, posvátný)",
            funFact: "Sv. Augustýn z Hippo je jedním z největších filosofů křesťanství - jeho Vyznání jsou první autobiografií v dějinách literatury. Říká se, že bez Augustýna by nebyl ani Descartes, ani moderní filosofie."
        ),
        "bronislav": .init(
            language: "Slovanský",
            meaning: "Slavný zbroj, zbraní slavný (bronja = zbroj + slava)",
            funFact: "Slovanské jméno kombinující bron (zbroj, pancíř) a slávu - typická válečnická symbolika. Zbroj jako ochrana při boji byla v raném středověku nejvzácnějším a nejcennějším majetkem válečníka."
        ),
        "boris": .init(
            language: "Turkický / Slovanský",
            meaning: "Vlk nebo bojovník (z turkického böri = vlk); v slovanském výkladu: bojovník",
            funFact: "Sv. Boris je patronem Ruska - spolu s bratrem Glebem byli první kanonizovaní slovanští světci (1072). Boris Jelcin se stal prvním prezidentem Ruské federace. Jméno je oblíbené od Bulharska po Japonsko."
        ),
        "dalimil": .init(
            language: "Slovanský",
            meaning: "Darující z dálky, laskavý z dálky (dali + mil)",
            funFact: "Dalimil je autorem nejstarší české kroniky psané česky - Dalimilovy kroniky (kolem 1314). Byl prvním českým autorem, který psal v národním jazyce a prosazoval češtinu nad latinu. Jeho identita dodnes zůstává záhadou."
        ),
        "radomila": .init(
            language: "Slovanský",
            meaning: "Milostivá radostí, milá a radostná (rad + milá)",
            funFact: "Typicky slovanské dvousložkové jméno. Kořen rad- vyjadřující radost najdeme v desítkách slovanských jmen: Radek, Radoslav, Radmila, Radovan - starobylá vrstva slovanské jmenné tradice."
        ),
        "vlastimil": .init(
            language: "Slovanský",
            meaning: "Milující vlast, vlasti milý (vlast + milý)",
            funFact: "Jméno vyjadřuje lásku k rodné zemi - vlast = rodná země (od vlad = vládnout). Slovanský kořen vlast je příbuzný s vladatem (vládnout) a dal základ jménům Vladimír, Vladislav i Vlasta."
        ),
        "valdemar": .init(
            language: "Severský (germánský)",
            meaning: "Slavný vládce (Waldemar: wald = vládce + mari = slavný)",
            funFact: "Jméno nosili čtyři dánští králové. Valdemar II. Vítězný dobyl Estonsko a podle legendy mu z nebe spadl červenobílý prapor Dannebrog - nejstarší stále používaná státní vlajka světa."
        ),
        "maxmilian": .init(
            language: "Latinský",
            meaning: "Největší (maximus) - jméno vymyslel císař Friedrich III. spojením Maximus a Aemilianus",
            funFact: "Jméno vymyslel habsburský císař Friedrich III. pro svého syna - spojil dvě slavná římská jména. Habsburk Maxmilián I. byl zvaný Poslední rytíř. Mexický císař Maxmilián I. byl zastřelen v roce 1867."
        ),
        "kvido": .init(
            language: "Germánský (italský)",
            meaning: "Dřevo, les (wido = les, dřevo)",
            funFact: "Kvido je česká forma italského Guido. Guido z Arezza (11. stol.) vynalezl notový systém, který používáme dodnes - pojmenoval noty do, re, mi, fa, sol, la, si podle počátečních slabik latinského hymnu k sv. Janu Křtiteli."
        ),
        "svatopluk": .init(
            language: "Slovanský",
            meaning: "Slavné vojsko nebo posvátný lid (svat + pluk = posvátný + vojsko)",
            funFact: "Svatopluk I. byl nejmocnějším vládcem Velké Moravy - za jeho vlády dosáhla říše největšího rozsahu. Přijal Cyrila a Metoděje a zažil zlatý věk slovanské kultury. Pověst o prutech vypráví o jednotě jako síle."
        ),
        "rostislav": .init(
            language: "Slovanský",
            meaning: "Rozrůstající se sláva (rosti = růst + slava)",
            funFact: "Kníže Rastislav Moravský pozval v roce 863 Cyrila a Metoděje, aby přinesli křesťanství ve slovanském jazyce - tím dal podnět ke vzniku první slovanské abecedy a literatury. Rostislav je česká forma tohoto starobylého jména."
        ),
        "ota": .init(
            language: "Germánský",
            meaning: "Majetek, bohatství (aud/od = majetný)",
            funFact: "Ota I. Veliký byl prvním císařem Svaté říše římské (962) - obnovil říši Karla Velikého. Oto II. si vzal byzantskou princeznu Theofanu a spojil východní a západní kulturu středověkého světa."
        ),
        "otto": .init(
            language: "Germánský",
            meaning: "Majetek, bohatství (aud/od = majetný)",
            funFact: "Otto I. Veliký byl prvním císařem Svaté říše římské (962). Otto von Bismarck sjednotil Německo v roce 1871. Otto Wichterle vynalezl v Praze měkké kontaktní čočky - dnes je nosí přes 100 milionů lidí."
        ),
        "hugo": .init(
            language: "Germánský",
            meaning: "Mysl, duch, rozum (hug = mysl, duch)",
            funFact: "Victor Hugo napsal Bídníky a Chrám Matky Boží v Paříži - dvě nejpřekládanější francouzská díla. Jeho pohřeb (1885) přilákal přes 2 miliony lidí - největší shromáždění v dějinách Paříže té doby."
        ),
        "lubos": .init(
            language: "Slovanský",
            meaning: "Milovaný, milý (lub = milovat)",
            funFact: "Luboš je domácká česká forma jmen Luboslav nebo Lubomír. Kořen lub- (milovat, mít rád) je příbuzný se staroslovanským ljubiti - odtud ruské ljubov (láska) i polské lubić (mít rád)."
        ),
        "adrian": .init(
            language: "Latinský",
            meaning: "Pocházející z Adrie (Hadrianus - od antického města Adria)",
            funFact: "Jméno proslavil císař Hadrianus, který postavil Hadriánův val v Británii a Pantheon v Římě. Adriatické moře nese jméno starověkého etruského města Adria. Jediný anglický papež byl Hadrián IV. (12. stol.)."
        ),

        // MARK: - Doplnění chybějících jmen

        "dobroslav": .init(
            language: "Slovanský",
            meaning: "Dobrá sláva, slavný dobrotou (dobrý + slava)",
            funFact: "Dobroslav je starobylé slovanské jméno kombinující dobrotu a slávu. Kořen dobr- je jedním z nejstarších slovanských výrazů — v ruštině добро znamená dobro i laskavost. Jméno je dnes vzácné, čímž je o to originálnější."
        ),
        "radmila": .init(
            language: "Slovanský",
            meaning: "Radostná a milá, milá radostí (rad + milá)",
            funFact: "Krásné slovanské jméno kombinující radost (rad-) a laskavost (mil-). Kořen rad- najdeme i v jménech Radek, Radoslav a Radovan. Je typicky ženským jménem středoevropského prostoru bez přímého protějšku na Západě."
        ),
        "cestmir": .init(
            language: "Slovanský",
            meaning: "Ten, kdo ctí mír, slavný ctí (čest + mír)",
            funFact: "Čestmír je starobylé slovanské dvousložkové jméno kombinující čest a mír. V kronikách se vyskytuje jako jméno přemyslovských bojovníků a udatných rytířů. Patří ke vzácnějším, ryze českým jménům bez ekvivalentu na Západě."
        ),
        "radovan": .init(
            language: "Slovanský",
            meaning: "Ten, kdo raduje, radující se (rad + ván = radovat)",
            funFact: "Jméno ze starobylé slovanské tradice vyjadřující radost a veselí. Je oblíbené v českém, srbském a chorvatském prostředí. Kořen rad- je jedním z nejproduktivnějších slovanských jmenných základů, najdeme ho v desítkách jmen od Radmily po Rostislava."
        ),
        "drahoslav": .init(
            language: "Slovanský",
            meaning: "Drahá sláva, slavný drahocenností (drahý + slava)",
            funFact: "Staroslovanské dvousložkové jméno spojující drahý (vzácný, milovaný) a slávu. Kořen drah- přenesl svůj původní význam vzácný i do moderní češtiny — drahoušek, drahota, drahokam. Je jedním z typicky staroslovanských jmen bez překladu do jiných jazyků."
        ),
        "valentyn": .init(
            language: "Latinský",
            meaning: "Zdravý, silný, statný (valens = silný)",
            funFact: "Sv. Valentýn (14. 2.) byl kněz, který tajně oddával vojáky, přestože císař Claudius II. manželství vojákům zakazoval. Spojení s láskou vzniklo v anglické středověké literatuře — básník Chaucer věřil, že ptáci si v tento den vybírají partnera. Dnes je svátek oslavován ve stovkách zemí."
        ),
        "valentyna": .init(
            language: "Latinský",
            meaning: "Zdravá, silná, statná — ženská forma Valentýna (valens = silný)",
            funFact: "Valentýna Těreškovová byla v roce 1963 první ženou ve vesmíru — obletěla Zemi 48krát na palubě Vostoku 6. Svátek 14. 2. (Valentýn) je pojmenován po sv. Valentýnovi, který tajně oddával vojáky navzdory císařovu zákazu."
        ),
        "milada": .init(
            language: "Slovanský",
            meaning: "Milá, příjemná, laskavá (milŭ = milý, příjemný)",
            funFact: "Milada Horáková byla česká právnička a politička — v roce 1950 ji komunistický režim popravil jako jedinou ženu v politickém procesu. Je symbolem odboje a nespravedlnosti totalitního režimu. Nadace Milady Horákové dodnes oceňuje odvahou vyznačující se lidi."
        ),
        "matej": .init(
            language: "Hebrejský",
            meaning: "Boží dar (Mattityahu = dar od Jahveho)",
            funFact: "Apoštol Matyáš/Matěj byl losem vybrán jako náhrada za Jidáše Iškariotského — jediný apoštol určený tímto způsobem. Přímý los jako způsob výběru pak zanikl. Matěj je českou formou, Matyáš slovenskou a Matthias německou variantou tohoto starozákonního jména."
        ),
        "lumir": .init(
            language: "Slovanský",
            meaning: "Světlý, jasný, svítivý (lum = světlo, zář)",
            funFact: "Lumír je jméno legendárního slovanského barda, který zpíval na dvoře knížete Hostivíta. Lumírova škola — literární hnutí 19. stol. kolem časopisu Lumír — prosazovala českou literaturu světové úrovně. Julius Zeyer a Jaroslav Vrchlický byli jejími hlavními představiteli."
        ),
        "horymir": .init(
            language: "Slovanský",
            meaning: "Hora a mír, ten kdo přináší mír z hor",
            funFact: "Rytíř Horymír z Neumětel přeskočil s koněm Šemíkem nepřekonatelné hradby Vyšehradu — slavná česká pověst z přemyslovských dob. Za tento čin mu kníže Křesomysl daroval svobodu. Svátek Horymíra připadá na přestupný den 29. 2. — den, který se opakuje jednou za čtyři roky."
        ),
        "rehor": .init(
            language: "Latinský / Řecký",
            meaning: "Bdělý, ostražitý, pozorný (gregorios = bdělý)",
            funFact: "Řehoř Veliký (6. stol.) zavedl gregoriánský chorál — vícehlasý zpěv, jenž po 15 staletí zní v kostelích celého světa. Jméno neslo 16 papežů. Řehoř XIII. zavedl v roce 1582 gregoriánský kalendář, který používáme dodnes — opravil chybu juliánského o 10 dní."
        ),
        "sona": .init(
            language: "Řecký",
            meaning: "Moudrost — slovanská zdrobnělina Sofie (sophia = moudrost)",
            funFact: "Soňa je domácká slovanská forma Sofie. Soňa z Tolstého Vojny a míru je jednou z nejsympatičtějších postav světové literatury — symbol obětavé lásky. Filosofie (filo + sofia = milovat moudrost) nese tentýž základ jako toto jméno."
        ),
        "sonja": .init(
            language: "Řecký",
            meaning: "Moudrost — skandinávská a balkánská forma Sofie (sophia)",
            funFact: "Sonja je skandinávská varianta Sofie/Soni. Norská korunní princezna Sonja si vzala Haralda navzdory odporu královského dvora — byl to jeden z prvních modernizačních kroků norské monarchie: sňatek prince s dívkou z prostého lidu. Dnes je norskou královnou."
        ),
        "sonia": .init(
            language: "Řecký",
            meaning: "Moudrost — internacionální forma Sofie (sophia = moudrost)",
            funFact: "Sonia je anglická a španělská varianta Sofie. Sonia Gandhi, rodačka z Itálie, se provdala do indické politické dynastie Néhrú-Gándhí a stala se jednou z nejmocnějších žen Indie. Filosofie = milovat moudrost (filo + sofia) nese tentýž základ."
        ),
        "emanuel": .init(
            language: "Hebrejský",
            meaning: "Bůh s námi (Immanuel = El + imanu = Bůh + s námi)",
            funFact: "Jméno Emanuel je prorocké jméno Mesiáše z knihy Izaiáš: Hle, panna počne a porodí syna a dá mu jméno Immanuel. Immanuel Kant — největší novověký filosof — napsal Kritiku čistého rozumu a Kritiku praktického rozumu. V Čechách jméno nosil Emanuel z Valdštejna."
        ),
        "dita": .init(
            language: "Germánský / Hebrejský",
            meaning: "Zdrobnělina Judity nebo Edity — bojovná žena",
            funFact: "Dita je česká domácká forma Judity nebo Edity. Dita Saxová je název novely Arnošta Lustiga o dívce přeživší holocaust — symbolická postava české literatury 20. století. Dita von Teese je světoznámá burlesque umělkyně, která toto jméno proslavila v populární kultuře."
        ),
        "erika": .init(
            language: "Severský / Germánský",
            meaning: "Věčná vládkyně (ei = věčně + ríkr = mocný, vládce)",
            funFact: "Erika je ženská forma Erika. Leif Eriksson dosáhl jako první Evropan Ameriky kolem roku 1000 — 500 let před Kolumbem. Erika je také rod vřesu — v Německu symbol kvetoucí odolnosti. Píseň Erika z 2. světové války je dodnes kontroverzní německou vojenskou písní."
        ),
        "julius": .init(
            language: "Latinský",
            meaning: "Z rodu Iuliů, prvně narozený nebo zasvěcený Jovovi",
            funFact: "Julius Caesar je jednou z nejznámějších postav světových dějin. Slova Kaiser a Car — základ ruského titulu — pocházejí přímo od jeho jména. Juliánský kalendář, zavedený Caesarem v roce 46 př. n. l., byl v Evropě používán přes 1 600 let."
        ),
        "anastazie": .init(
            language: "Řecký",
            meaning: "Vzkříšení, nové povstání (anastasis = vzkříšení, vstání)",
            funFact: "Anastázie Nikolajevna, nejmladší dcera cara Mikuláše II., byla popravena v roce 1918. Záhada kolem jejího osudu inspirovala desítky knih a filmů. DNA analýza z roku 2009 nakonec potvrdila, že zahynula spolu s celou carskou rodinou — po 91 letech nejistoty."
        ),
        "blahoslav": .init(
            language: "Slovanský",
            meaning: "Šťastná sláva, slavný blažeností (blaho + slava)",
            funFact: "Jan Blahoslav byl biskupem jednoty bratrské a přeložil Nový zákon do češtiny (1564) — jeho překlad se stal základem pro slavnou Bibli kralickou. Jako jazykovědec napsal i první českou gramatiku s praktickými pravidly. Bez něj by nevznikl nejkrásnější český literární překlad Bible."
        ),
        "pankrac": .init(
            language: "Řecký",
            meaning: "Vládce všeho, všemocný (pan = vše + kratos = moc)",
            funFact: "Sv. Pankrác byl 14letý chlapec umučený za víru kolem roku 304. Spolu se Servácem a Bonifácem tvoří tzv. Železné muže — jejich svátky kolem 12.–14. 5. přinášejí podle lidové tradice pozdní jarní mrazíky. Plavci a zemědělci se na ně tradičně připravují dodnes."
        ),
        "servac": .init(
            language: "Latinský / Germánský",
            meaning: "Ten, kdo zachraňuje (servare = zachránit)",
            funFact: "Sv. Servác je patronem Maastrichtu. Spolu s Pankrácem a Bonifácem tvoří Železné muže — jejich svátky 12.–14. 5. jsou spojeny s lidovou předpovědí pozdních mrazíků. Lidová říkanka: Pankrác, Servác, Bonifác — tři mrazivci, zahradníkovi škůdci."
        ),
        "bonifac": .init(
            language: "Latinský",
            meaning: "Dobré předurčení, šťastný osud (bonus fatum = dobrý osud)",
            funFact: "Sv. Bonifác Mohučský (8. stol.) byl apoštol Germánů — porazil posvátný dub boha Thora a z jeho dřeva postavil kapli. Je patronem Německa. Tvoří trojici Železných mužů s Pankrácem a Servácem, jejichž svátky 12.–14. 5. jsou spojeny s pozdními jarními mrazíky."
        ),
        "emil": .init(
            language: "Latinský",
            meaning: "Z rodu Aemiliů, soupeřivý, pilný (aemulus = soupeř)",
            funFact: "Emil Zátopek je největší český sportovec všech dob — na olympiádě v Helsinkách 1952 vyhrál 5 000 m, 10 000 m i maraton. Přeběhl i svou ženu Danu na zlatou v hodu oštěpem. Vítěz čtyřnásobné zlaté na jedné olympiádě — výkon, jenž se pravděpodobně již nezopakuje."
        ),
        "medard": .init(
            language: "Germánský",
            meaning: "Mocná síla, velká energie (megin = síla + hard = silný)",
            funFact: "Sv. Medard (8. 6.) je v Čechách i Německu neoficiálním meteorologem: Medard dá-li pršet, prší 40 dní celých. Tento lidový prorok deštivého léta je dodnes populárním barometrem. Legenda říká, že jako dítě ho chránil před deštěm orel svými křídly pro jeho zbožnost."
        ),
        "bruno": .init(
            language: "Germánský",
            meaning: "Hnědý, temný, brunátný (brun = hnědý)",
            funFact: "Giordano Bruno (16. stol.) hájil heliocentrismus a teorii nekonečného vesmíru s mnoha světy. Byl upálen jako kacíř na římském Campo de' Fiori — dnes tam stojí jeho socha jako symbol svobody myšlení. Sv. Bruno Querfurtský přinesl křesťanství Prusům a padl při misii."
        ),
        "roland": .init(
            language: "Germánský",
            meaning: "Slavný v zemi, proslavený vlasti (hrod = sláva + land = země)",
            funFact: "Roland je hrdina středověkého francouzského eposu Píseň o Rolandovi — padl v bitvě u Roncevaux (778) bránit říši Karla Velikého. Je symbolem rytířské cti a věrnosti. Sochy Rolanda stojí dodnes v mnoha německých a polských městech jako symboly svobody a spravedlnosti."
        ),
        "cenek": .init(
            language: "Latinský",
            meaning: "Vítěz — česká forma Vincence (vincere = vítězit)",
            funFact: "Čeněk je ryze česká forma latinského Vincenc. Čeněk z Vartemberka byl vůdcem české šlechty v husitských dobách a bojoval za náboženská práva. V Čechách je Čeněk vzácným, ale tradičně doloženým jménem od středověku, kdy ho nosili i šlechtici i měšťané."
        ),
        "ilja": .init(
            language: "Hebrejský / Slovanský",
            meaning: "Jahve je Bůh (Eliyahu = slovanská forma Eliáše)",
            funFact: "Ilja je slovanská forma hebrejského Eliáše. V ruské tradici je Ilja Muromec — bohatýr z bylin — nejvýznamnějším slovanským epickým hrdinem, analogie Herkula nebo Achilla. Prorok Eliáš svolal na hoře Karmel oheň z nebes — jeden z nejdramatičtějších biblických příběhů."
        ),
        "borek": .init(
            language: "Slovanský",
            meaning: "Bojovník, ten, kdo si razí cestu (boriti = bojovat)",
            funFact: "Bořek je česká domácká forma jmen jako Bořivoj nebo Bořislav. Bořek Stavitel je populární česká animovaná série pro děti, inspirovaná britským Bobem Stavitelem. Kořen bor- se vyskytuje i ve jméně Bořivoj — prvního historicky doloženého přemyslovského knížete."
        ),
        "bernard": .init(
            language: "Germánský",
            meaning: "Silný jako medvěd (berin = medvěd + hard = silný, odvážný)",
            funFact: "Sv. Bernard z Clairvaux (12. stol.) byl největší duchovní autorita středověké Evropy — kázal 2. křížovou výpravu. Sv. Bernard z Mentonu dal jméno průsmyku Sv. Bernarda a psímu plemenu bernardýn — tato záchranná horská zvířata byla proslulá sudičkou koňaku pro ztracené cestovatele ve Alpách."
        ),
        "johana": .init(
            language: "Hebrejský",
            meaning: "Bůh je milostivý — ženská forma Jana (Yochanan)",
            funFact: "Johana z Arku (Jeanne d'Arc) je nejslavnější nositelka tohoto jména — 17letá dívka vedla francouzskou armádu a přelomila stoletou válku. Byla upálena v Rouenu (1431) ve věku 19 let. V roce 1920 ji církev kanonizovala a dnes je francouzskou národní hrdinkou a symbolem odvahy."
        ),
        "sobeslav": .init(
            language: "Slovanský",
            meaning: "Slavný sobě, získávající slávu (sobě + slava)",
            funFact: "Přemyslovský kníže Soběslav I. porazil v bitvě u Chlumce (1126) německou armádu císaře Lothara — jedna z největších vojenských výher českých knížat. Po vítězství přinesl na bojiště ostatky sv. Václava jako poděkování za ochranu. Bitva zastavila německou expanzi do Čech."
        ),
        "boleslav": .init(
            language: "Slovanský",
            meaning: "Mnohem více slavný, velká sláva (bole = více + slava)",
            funFact: "Boleslav I. — Boleslav Ukrutný — nechal zavraždit svého bratra sv. Václava (935). Přesto byl zdatným vladařem, jenž rozšířil českou říši. Jeho syn Boleslav II. Pobožný dokončil christianizaci Čech — historický paradox, že náboženská tradice pokračovala v dynastii bratrova vraha."
        ),
        "jeronym": .init(
            language: "Řecký",
            meaning: "Posvátné jméno, ten s posvátným jménem (hieros + onyma)",
            funFact: "Sv. Jeroným ze Stridonu přeložil Bibli do latiny — Vulgata se stala standardním textem Církve na 1 500 let. Jeroným Pražský byl stoupenec Jana Husa, popravený v Kostnici (1416) — druhý po svém mistru. Je po Husovi nejvýznamnějším mučedníkem českých reformačních dějin."
        ),
        "oleg": .init(
            language: "Severský (skandinávský)",
            meaning: "Posvátný, blahoslavený (Helgi = posvátný)",
            funFact: "Oleg Kyjevský (9.–10. stol.) byl varjažský vůdce, který sjednotil Novgorod a Kyjev a položil základ Kyjevské Rusi. Prý přibil štít na bránu Cařihradu jako symbol moci. Jméno přišlo do slovanského světa s Vikingy — varanžskými obchodníky z Pobaltí."
        ),
        "teodor": .init(
            language: "Řecký",
            meaning: "Boží dar (theos = bůh + doron = dar)",
            funFact: "Teodor je řecká verze jména — stejný základ má i Dorota (dar Boha, přehozeně). Byzantská císařovna Theodora (6. stol.) z tanečnice stala se nejmocnější ženou tehdejšího světa. Když vypukla povstání, odmítla uprchnout se slovy: Purpur je nejlepší rubáš — a trůn zachránila."
        ),
        "nina": .init(
            language: "Hebrejský / Gruzínský",
            meaning: "Milost Boží — varianta Anny; nebo gruzínská světice",
            funFact: "Sv. Nina přinesla křesťanství do Gruzie v 5. stol. — je patronkou Gruzie. Nesla ji i Nina Simone, legendární americká jazzová zpěvačka. V češtině je Nina oblíbenou domáckou formou jmen jako Antonína nebo Janina. Jméno je krátké, melodické a oblíbené po celém světě."
        ),
        "erik": .init(
            language: "Severský (skandinávský)",
            meaning: "Věčný vládce (ei = věčně + ríkr = mocný, vládce)",
            funFact: "Erik Rudý byl vikingský průzkumník, který kolem roku 985 osnoval grónskou kolonii. Jeho syn Leif Eriksson dosáhl jako první Evropan Severní Ameriky — přibližně roku 1000, celých 492 let před Kolumbem. Švédský král Erik IX. Světec je patronem Švédska."
        ),
        "zoe": .init(
            language: "Řecký",
            meaning: "Život (zoe = život)",
            funFact: "Zoe je přímý řecký překlad hebrejského jména Eva (Chava = živoucí). Byzantská císařovna Zoe (11. stol.) vládla Konstantinopoli a sama si vybírala manžely-císaře — vládla jako rovnocenná spoluregentka. Jméno je dnes celosvětově populární pro svou jednoduchost a silný životní význam."
        ),
        "felix": .init(
            language: "Latinský",
            meaning: "Šťastný, blažený, úspěšný (felix = šťastný)",
            funFact: "Felix je latinský protějšek řeckého Makarios a hebrejského Ašer — všechna tato jména znamenají šťastný. Felix Mendelssohn je jedním z nejhranějších romantických skladatelů — napsal Svatební pochod ze Snu noci svatojánské, který zní na svatbách po celém světě dodnes."
        ),
        "miriam": .init(
            language: "Hebrejský",
            meaning: "Milovaná Bohem nebo hořká (Miryam) — nejstarší forma jména Marie",
            funFact: "Miriam je nejstarší dochovaná forma jména Marie. Miriam, sestra Mojžíše, zpívala vítěznou píseň po přechodu Rudého moře — jedna z prvních žen v Bibli obdařených proroctvím. Marie / Miriam je nejrozšířenějším ženským jménem v historii — odhaduje se přes 70 milionů nositelek."
        ),
        "bohdan": .init(
            language: "Slovanský",
            meaning: "Bohém daný, dar od Boha (boh + dan = Bohem daný)",
            funFact: "Bohdan je slovanský překlad latinského Donatus nebo řeckého Theodoros — Bohem daný. Bohdan Chmelnický byl vůdce kozácké revoluce v 17. stol. a zakladatel kozácké státnosti na Ukrajině. Jméno je oblíbené na Ukrajině, v Polsku i v Čechách."
        ),
        "albert": .init(
            language: "Germánský",
            meaning: "Ušlechtile zářivý, vznešeně jasný (adal + beraht = vznešený + zářivý)",
            funFact: "Albert Einstein formuloval teorii relativity a rovnici E=mc² — nejznámější vědec 20. století. Albert je zkrácenina Adalbert — v češtině totéž jako Vojtěch. Belgický král Albert I. odmítl v roce 1914 německé ultimátum a osobně vedl obranu země — stal se symbolem belgické národní hrdosti."
        ),
        "artur": .init(
            language: "Keltský",
            meaning: "Medvěd, medvědí síla (arth = medvěd)",
            funFact: "Král Artuš s rytíři Kulatého stolu je nejslavnější mýtus západní Evropy — symbolizuje ideál rytířství, spravedlnosti a jednoty. Arthur Conan Doyle stvořil Sherlocka Holmese — nejpřekládanější fiktivní postavu světové literatury. Artušovské legendy inspirovaly opery, filmy i muzikály po celém světě."
        ),
        "rene": .init(
            language: "Latinský",
            meaning: "Znovuzrozený, obrozený (renatus = znovu narozený)",
            funFact: "René Descartes vyslovil Cogito ergo sum — Myslím, tedy jsem — základ novověké filosofie. Je zakladatelem analytické geometrie a kartézských souřadnic (kartézský = od Cartesius = latinizace Descartes). Jméno symbolizovalo v renesanci duchovní obrodu skrze křest — renesance sama znamená znovuzrození."
        ),
        "zina": .init(
            language: "Řecký",
            meaning: "Zkrácenina Zinajdy — Zeusova dcera (Zinais = patřící Diovi)",
            funFact: "Zina je domácká forma řeckého jména Zinaida. Populárně ji proslavila Xena: Princezna válečnice — americký seriál z 90. let, kde hlavní hrdinka Xena/Zina bojovala za spravedlnost ve starověku. Jméno je oblíbené v ruském a česko-slovenském prostředí."
        ),
        "iva": .init(
            language: "Germánský / Slovanský",
            meaning: "Vrba nebo tis (iva = vrba); nebo zdrobnělina Ivany",
            funFact: "Iva je česká domácká forma Ivany nebo samostatné jméno (iva = vrba). Ve slovanské tradici byla vrba symbolem plodnosti a znovuzrození — vrbové proutky jsou základem velikonočních pomlázek dodnes. Jméno bylo v 60.–80. letech velmi populární v Čechách a na Slovensku."
        ),
        "benjamin": .init(
            language: "Hebrejský",
            meaning: "Syn pravé ruky, syn jižní strany (ben = syn + jamin = pravice, jih)",
            funFact: "Benjamín byl nejmladší syn biblického Jákoba a nejoblíbenější — odtud výraz benjamínek rodiny. Benjamin Franklin vynalezl bleskosvod, bifokální brýle a jako první vědecky dokázal elektrický charakter blesku. Jeho portrét je na americké stodalerové bankovce."
        ),
        "ambroz": .init(
            language: "Latinský / Řecký",
            meaning: "Nesmrtelný, božský (ambrotos = nesmrtelný)",
            funFact: "Ambrosia byl nápoj nesmrtelnosti olympských bohů. Sv. Ambrož Milánský (4. stol.) je patronem Milána a zavedl ambrozianský chorál — systém liturgického zpěvu. Milan je pojmenován po sv. Ambrožovi (Mediolanum). Byl prvním biskupem, jehož kázání přivedla sv. Augustýna ke konverzi."
        ),
        "judita": .init(
            language: "Hebrejský",
            meaning: "Judejka, žena z Judeje (Yehudit)",
            funFact: "Biblická Judita zachránila svůj lid tím, že svůdně přilákala asyrského vojevůdce Holoferna a v noci mu sťala hlavu. Tento čin inspiroval malíře Klimta, Caravaggia i Artemisii Gentileschi — patří k nejčastěji zobrazovaným biblickým scénám. Judita je vzorem statečné ženy v celé světové kultuře."
        ),
        "radana": .init(
            language: "Slovanský",
            meaning: "Radostná, šťastná (rad = radost)",
            funFact: "Radana je česká ženská forma s kořenem rad-, jenž vyjadřuje radost a veselí. Najdeme ho v desítkách slovanských jmen — Radmila, Radoslav, Radovan, Radek. Je to typicky středoevropské jméno bez přímého protějšku v germánských nebo románských jazycích."
        ),
        "ester": .init(
            language: "Hebrejský / Perský",
            meaning: "Hvězda (esther = hvězda); nebo perská bohyně Ištar",
            funFact: "Biblická Ester zachránila židovský národ před genocidou na perském dvoře — svátek Purim připomíná tuto záchranu dodnes. Ester Ledecká je česká sportovkyně, která na ZOH 2018 v Pchjongčchangu vyhrála zlaté medaile v snowboardu i v alpském lyžování — unikátní double na jedněch hrách."
        ),
        "alexandr": .init(
            language: "Řecký",
            meaning: "Obránce lidí (alexein = obránce + aner = muž)",
            funFact: "Alexandr Makedonský dobyl do 33 let největší říši starověku — od Řecka po Indii. Na jeho počest bylo pojmenováno přes 70 měst Alexandrie. Alexandre Dumas napsal Tři mušketýry a Hraběte Monte Kristo — jedny z nejpřekládanějších dobrodružných románů světa."
        ),
        "alan": .init(
            language: "Keltský",
            meaning: "Harmonie, klid (alan = kamenný; nebo ze starokeltského = harmonie)",
            funFact: "Alan Turing byl matematik, který rozluštil německou šifru Enigma za druhé světové války a zachránil miliony životů. Zároveň je otcem informatiky — Turingův test pro umělou inteligenci je dodnes standardem. Byl pronásledován za homosexualitu a zemřel tragicky ve 41 letech."
        ),
        "ivo": .init(
            language: "Germánský",
            meaning: "Tisový luk, válečník s tisovým lukem (iv = tis, druh stromu)",
            funFact: "Sv. Ivo Bretaňský (14. stol.) byl právník, který bezplatně zastupoval chudé — je patronem právníků a advokátů. V románských jazycích existuje jako Yves — módní návrhář Yves Saint Laurent proslavil toto jméno ve světě módy. Je rozšířen od Bretaně přes Itálii až po Čechy."
        ),
        "ludek": .init(
            language: "Germánský",
            meaning: "Slavný bojovník — česká domácká forma Ludvíka (hlud + wig = sláva + boj)",
            funFact: "Luděk je česká domácká forma jména Ludvík. Jméno Ludwig/Ludvík neslo 18 francouzských králů. Ludwig van Beethoven složil svou devátou symfonii (Ódu na radost) absolutně hluchý — dirigoval premiéru a neslyšel ani hlas ani aplaus. Dnes je Óda na radost hymnou Evropské unie."
        ),
        "vanda": .init(
            language: "Germánský / Slovanský",
            meaning: "Z kmene Vendů nebo Vandalů; nebo slovansky: kdo se vrací",
            funFact: "Vanda je jméno polské královny z pověsti — dcery Kroka, která se raději hodila do Visly, než by se provdala za německého nápadníka. Vandové — germánský kmen — dali slovům vandalismus a vandal přezdívku ničitelů kultury po vyplenění Říma v roce 455."
        ),
        "apolena": .init(
            language: "Řecký",
            meaning: "Patřící bohu Apollónovi (Apollonia)",
            funFact: "Sv. Apolena (Apollonie) byla mučednice, které byly vytrhány zuby — proto je patronkou zubařů a lidí trpících bolestmi zubů. Na svátek sv. Apoleny (9. 2.) si lékaři připomínají tuto patronku. Apolineion bylo v antice Apollónův chrám."
        ),
        "jarmil": .init(
            language: "Slovanský",
            meaning: "Jarý a milý, jarem milovaný (jaro + milý)",
            funFact: "Jarmil je mužská forma jména Jarmila — oba sdílejí základ jaro a milý. Svátky slaví 2. června, blízko letního slunovratu. Kombinace jarní energie a laskavosti dělá z tohoto jména typický příklad starobylých slovanských dvousložkových jmen bez ekvivalentu v jiných jazykových rodinách."
        ),
        "ida": .init(
            language: "Germánský / Řecký",
            meaning: "Pracovitá, pilná (id = práce); nebo z hory Ida na Krétě",
            funFact: "Hora Ida na Krétě je místem, kde byl podle mýtu vychován Zeus v tajnosti před svým otcem Kronem. Ida von Hahn-Hahn byla významná německá spisovatelka 19. stol. — přes ní se jméno rozšířilo do střední Evropy. Jméno je krátké, silné a oblíbené napříč kulturami."
        ),
        "venceslav": .init(
            language: "Slovanský",
            meaning: "Věnec slávy, ověnčený slávou (věnec + slava)",
            funFact: "Věnceslav je starší forma slavného jména Václav. Václav/Věnceslav byl patron Čech a jeho jméno dalo vzniknout říkance Good King Wenceslas — anglická vánoční píseň o českém světci, zpívaná po celém anglosaském světě každé Vánoce."
        ),
        "lumil": .init(
            language: "Slovanský",
            meaning: "Laskavý, světlý (lum + milý = světlý a milý)",
            funFact: "Lumil je vzácné starobylé jméno s kořenem lum- (světlo, jas) a mil- (milý, laskavý). Patří ke jménům, která jsou doložena v historických análech, ale v moderní době se téměř nepoužívají — nositelé tohoto jména jsou skutečnou raritou."
        ),

        // MARK: - Třetí dávka

        "kaspar": .init(
            language: "Perský / Aramejský",
            meaning: "Strážce pokladu (gizbar = správce pokladu)",
            funFact: "Kašpar, Melichar a Baltazar jsou tři králové, kteří přinesli dítěti Ježíšovi zlato, kadidlo a myrhu. Jejich jména nejsou v Bibli — přidala je tradice. Na svátek Tří králů (6. 1.) se na dveře píše K+M+B, tedy Caspar, Melchior, Balthasar — a v Čechách chodí Tříkrálová sbírka."
        ),
        "melichar": .init(
            language: "Hebrejský",
            meaning: "Král světla nebo král města (malkî = král + or = světlo)",
            funFact: "Melichar, spolu s Kašparem a Baltazarem, je jedním ze Tří králů. Tradičně je zobrazován jako starý muž přinášející zlato. Kostnický koncil (1414–1418) skončil i proto, že přišel Melichar z Melku — ale to je jen jazyková hříčka. Jméno je dnes v Čechách vzácné."
        ),
        "baltazar": .init(
            language: "Babylonský / Perský",
            meaning: "Nechť Bel chrání krále (Bel-šarra-usur)",
            funFact: "Baltazar je jedním z Tří králů — tradičně nejmladší, zobrazovaný s myrhou. Babylonský král Belšasar z Bible viděl na zdi nápis Mene mene tekel ufarsin — odkud pochází rčení číst nápis na zdi jako varování. Jméno je ikonické díky vánočním tradicím po celém světě."
        ),
        "doubravka": .init(
            language: "Slovanský",
            meaning: "Dubový háj, dubové listí (doubrava = dubový les)",
            funFact: "Doubravka (Dobrawa) Česká byla dcerou Boleslava I. a manželkou polského knížete Mieszka I. Přivedla křesťanství do Polska (966) — křest Polska je jednou z klíčových událostí středoevropských dějin. Bez Doubravky by nebylo polské království ani Polska jako křesťanské země."
        ),
        "bela": .init(
            language: "Slovanský / Maďarský",
            meaning: "Bílá, světlá (bělý = bílý); nebo maďarsky vnitřní, srdce",
            funFact: "Běla je česká zdrobnělina jmen jako Běloslav nebo Bělomír, nebo ženská forma maďarského Bély. Maďarský král Béla IV. přestavěl Uhersko po tatarském vpádu 1241–1242 — díky němu bylo Maďarsko zachráněno. V češtině je Běla také oblíbenou domáckou formou Alžběty."
        ),
        "vladan": .init(
            language: "Slovanský",
            meaning: "Ten, kdo vládne, vladař (vlad = vládnout)",
            funFact: "Vladan je zkrácenina jmen Vladimír nebo Vladislav — vychází ze slovanského kořene vlad (vládnout). Vladan Desnica byl významný jugoslávský spisovatel. Jméno je oblíbené v srbském a chorvatském prostředí, v Čechách je méně obvyklé."
        ),
        "pravoslav": .init(
            language: "Slovanský",
            meaning: "Pravdivě slavný, slavný pravdou (pravda + slava)",
            funFact: "Pravoslav kombinuje pravdu a slávu — je typickým příkladem slovanského dvousložkového jména s etickým nábojem. Pravoslaví — pravá sláva Boha — je odtud pojmenována větev křesťanství. Jméno je v Čechách vzácné, ale jeho kořeny sahají hluboko do slovanské tradice."
        ),
        "otylie": .init(
            language: "Germánský",
            meaning: "Majetek, jmění (aud/od = bohatství) — ženská forma Oty",
            funFact: "Otýlie nebo Ota jsou germánská jména s kořenem aud (majetek, bohatství). Sv. Odilie (Otýlie) je patronkou Alsaska — legendárně se narodila slepá a prozřela při křtu. Hora sv. Odilie v Alsasku je nejnavštěvovanějším poutním místem oblasti a nabízí úchvatný výhled na Rýnskou nížinu."
        ),
        "robin": .init(
            language: "Germánský",
            meaning: "Zářivou slávou proslulý — zkrácenina Roberta (hrod + beraht)",
            funFact: "Robin Hood je nejslavnější nositel tohoto jména — loupežník z Sherwoodského lesa, který bral bohatým a dával chudým. Je symbolem spravedlnosti a odvahy. Robin je v anglosaském světě oblíbenou domáckou formou Roberta — Robin Williams, Robin Wright."
        ),
        "marika": .init(
            language: "Hebrejský",
            meaning: "Milovaná Bohem — maďarská / středoevropská zdrobnělina Marie",
            funFact: "Marika je maďarská a středoevropská zdrobnělina jména Marie. Marie je nejrozšířenější ženské jméno v historii — odhaduje se přes 70 milionů nositelek. Marika Rökk byla populární maďarsko-německá herečka a tanečnice, hvězda německého filmu 30.–40. let."
        ),
        "dobromila": .init(
            language: "Slovanský",
            meaning: "Dobrá a milá, milá svou dobrotou (dobrý + milá)",
            funFact: "Dobromila je starobylé slovanské ženské jméno kombinující dobrotu a laskavost. Kořen dobr- (dobrý) je jedním z nejuniverzálnějších slovanských výrazů — dobro, dobrosrdečný, dobrotivý. Jméno bylo v Čechách oblíbené v 19. století a dnes je vzácnou raritou."
        ),
        "slavena": .init(
            language: "Slovanský",
            meaning: "Slavná, proslulá (slava = sláva)",
            funFact: "Slavěna je ženská forma mužských jmen jako Slavomír nebo Slavibor. Symbolizuje slávu a hrdost — kořen slav- je základem i slova Slovan, protože Slované se původně sami nazývali Sloveni (ti slavní nebo ti, co mluví jasně — slovo = řeč)."
        ),
        "gizela": .init(
            language: "Germánský",
            meaning: "Rukojmí, zástavní (gisel = rukojmí, zástava dobré víry)",
            funFact: "Gisela Bavorská se provdala za Štěpána I. Uherského a přinesla do Uher křesťanství — analogie Doubravky v Polsku. Její bratr byl císař Jindřich II. Jméno bylo oblíbené v německých a maďarských královských rodinách. Gisela je dnes jméno oblíbené i v Latinské Americe."
        ),
        "liliana": .init(
            language: "Latinský",
            meaning: "Lilie (lilium = lilie, symbol čistoty)",
            funFact: "Liliana je rozvinutá forma jména Lilie/Lily. Lilie je v křesťanské symbolice znakem Panny Marie a čistoty — anděl Gabriel ji drží na obrazech Zvěstování. Lily Allen, Lily James, Liliana Cavani — jméno je oblíbené napříč kulturami od Itálie po Latinskou Ameriku."
        ),
        "frantiska": .init(
            language: "Germánský (latinizovaný)",
            meaning: "Svobodná žena z kmene Franků — ženská forma Františka",
            funFact: "Františka je ženská forma Františka — jméno, jež proslavil sv. František z Assisi, který se vzdal veškerého majetku a kázal ptákům. Je patronem zvířat a ekologie. Dnes ho nese i papež František — první latinoamerický a první jezuitský pontifex v historii."
        ),
        "viktorie": .init(
            language: "Latinský",
            meaning: "Vítězství (victoria = vítězství)",
            funFact: "Viktorie — bohyně vítězství — je zobrazována s křídly a věncem. Dala jméno britské královně Viktorii, jejíž éra je dodnes vzorem průmyslového a kulturního rozmachu. Victoria Beckham, Victoria's Secret — jméno je celosvětově rozšířené a spojuje eleganci s úspěchem."
        ),
        "andela": .init(
            language: "Řecký",
            meaning: "Anděl, Boží posel (angelos = posel)",
            funFact: "Anděla je česká forma jména Angela/Angelina. Angela Merkel jako první žena vedla Německo 16 let — nejdéle sloužící demokratická vůdkyně v novodobé historii. Jméno vychází z řeckého angelos (posel) — odtud anglický angel i evangelium (dobrá zpráva)."
        ),
        "matylda": .init(
            language: "Germánský",
            meaning: "Mocná v bitvě, bojovná síla (maht = moc + hild = bitva)",
            funFact: "Matylda Anglická (12. stol.) bojovala o anglický trůn a vedla válku s Štěpánem z Blois — byl to první ženský nárok na anglický trůn. Waltzing Matilda — neoficiální australská hymna — opěvuje potulného dělníka. Jméno proslavila i Roaldova Dahl Matylda — nejčtenější dětský román o dívce s nadpřirozenými schopnostmi."
        ),
        "eduard": .init(
            language: "Anglosaský (germánský)",
            meaning: "Strážce majetku, bohatý ochránce (ead = bohatství + weard = strážce)",
            funFact: "Eduard VIII. abdikoval z britského trůnu v roce 1936 kvůli lásce k rozvedené Američance Wallis Simpsonové — největší romantický skandál 20. stol. Eduard Beneš byl druhý prezident Československa. Edvard Grieg složil suitu Peer Gynt — nejznámější norské orchestrální dílo."
        ),
        "svetlana": .init(
            language: "Slovanský",
            meaning: "Světlá, jasná, zářivá (svět = světlo)",
            funFact: "Světlana je slovanský překlad latinské Lucie nebo řecké Fóby — všechna tato jména znamenají světlo. Světlana Alexijevičová je běloruská novinářka a spisovatelka, nositelka Nobelovy ceny za literaturu (2015) — za svědectví o Černobylu, Afghánistánu a sovětském kolapsu."
        ),
        "ivona": .init(
            language: "Germánský / Keltský",
            meaning: "Tisové dřevo, tisový luk (iv = tis) — ženská forma Ivona",
            funFact: "Ivona/Yvona je francouzská ženská forma jména Yves (z germánského iv = tis). Yvonne de Gaulle byla manželkou francouzského prezidenta Charlese de Gaulla. Tisové dřevo bylo středověkými lučištnými ceněno jako nejlepší materiál pro luky — luk byl zbraní hrdinů."
        ),
        "herbert": .init(
            language: "Germánský",
            meaning: "Zářivá armáda, slavné vojsko (heri = vojsko + beraht = zářivý)",
            funFact: "Herbert George Wells napsal Stroj času a Válku světů — zakladatel vědeckofantastické literatury. Herbert von Karajan byl nejslavnějším dirigentem 20. stol. — dirigoval Berlínskou filharmonii 35 let. Prezident Herbert Hoover byl prvním americkým prezidentem narozeným západně od Mississipi."
        ),
        "radomil": .init(
            language: "Slovanský",
            meaning: "Radostný mír, mír radosti (rad + mír)",
            funFact: "Radomil je starobylé slovanské dvousložkové jméno kombinující radost a mír. Svátek slaví 21. března — na jarní rovnodennost, první den jara. Kombinace rad- (radost) a mír (mír, svět) vyjadřuje dvě nejvyšší slovanské hodnoty. V moderní češtině je Radomil vzácným jménem s hlubokými kořeny."
        ),
        "marian": .init(
            language: "Latinský / Hebrejský",
            meaning: "Patřící Mariovi nebo Marii; nebo zbožný k Marii",
            funFact: "Marián/Marian je ve střední Evropě oblíbené jméno s dvojím výkladem — buď forma latinského Marius, nebo zbožné jméno zasvěcené Panně Marii. Marián Hossa, slovák v NHL, vyhrál tři Stanley Cupy. Marian Anderson byla první Afroameričanka vystupující v newyorské Metropolitní opeře."
        ),
        "miroslava": .init(
            language: "Slovanský",
            meaning: "Mír a sláva — ženská forma Miroslava",
            funFact: "Miroslava je ženská podoba slavného slovanského jména Miroslav. Krásné dvousložkové slovanské jméno — mír a sláva. Miroslava Němcová byla předsedkyní Poslanecké sněmovny ČR. Jméno je oblíbené zejména v generaci narozené 1950–1980."
        ),
        "elenka": .init(
            language: "Řecký",
            meaning: "Zářivá, světlá — zdrobnělina Heleny",
            funFact: "Elena je mezinárodní forma Heleny — jméno rozšířené od Španělska po Rusko. Elena Ceaușescu, manželka rumunského diktátora, si přisvojovala vědecké tituly, jež nezasloužila — byl to jeden z největších akademických podvodů 20. stol. Elena je dnes oblíbenou formou v románských jazycích."
        ),
        "elena": .init(
            language: "Řecký",
            meaning: "Zářivá, světlá — románská/slovanská forma Heleny",
            funFact: "Elena je rozšířená mezinárodní forma jména Helena. Vyskytuje se ve španělštině, italštině, ruštině i češtině. Elena Ferrante, anonymní italská autorka, napsala sérii Neapolských románů — literární fenomén přeložený do 45 jazyků. Elena Bonner bojovala s Andrejem Sacharovem za lidská práva v SSSR."
        ),
        "alexej": .init(
            language: "Řecký",
            meaning: "Obránce, ochránce (alexein = chránit, bránit)",
            funFact: "Alexej je slovanská forma řeckého Alexandra. Carevič Alexej Nikolajevič trpěl hemofilií — nemocí, jíž trpěla celá rodina Romanovců a jež ovlivnila politiku Evropy. Léčitel Rasputin získal vliv nad carem právě díky zdánlivé pomoci chorému carevičovi."
        ),
        "ceslav": .init(
            language: "Slovanský",
            meaning: "Čest a sláva (čest + slava)",
            funFact: "Česlav je starobylé slovanské jméno kombinující čest a slávu — dvě nejvyšší středověké hodnoty. Patří ke jménům, která přežila přes tisíc let české historie. Bl. Česlav Odrowąż byl dominikánský kněz a apoštol Slezska ve 13. stol. — zakladatel klášterů v Krakově a Praze."
        ),
        "bohumira": .init(
            language: "Slovanský",
            meaning: "Bohu milý mír, Bohu milý (bohu + mír)",
            funFact: "Bohumír je mužská forma — Bohumira ženská. Slovanské jméno kombinující bohu (Bohu) a mír (mír, svět). Kořen mir (mír, svět) je jedním z nejplodnějších v slovanských jazycích — najdeme ho v Miroslavu, Vladimíru i Tikhomiru. Svátek slaví 8. listopadu."
        ),
        "bohumir": .init(
            language: "Slovanský",
            meaning: "Bohu milý mír, Bohu milý (bohu + mír)",
            funFact: "Bohumír je starobylé slovanské jméno propojující Boha a mír. Kořen mir (mír, svět) sdílí s Miroslavem, Vladimírem i Slavomírem. V legendě jsou Bohumír a Sláva prarodiče Slovanů — symbol starodávnosti tohoto jména."
        ),
        "ondrejka": .init(
            language: "Řecký",
            meaning: "Mužná, statečná — česká zdrobnělina Ondřeje (andreios)",
            funFact: "Ondřejka je ženská česká forma jména Ondřej. Sv. Ondřej byl prvním apoštolem Ježíše a patronem Skotska, Ruska, Řecka a Rumunska. Ondřejský kříž (tvar X) je na vlajce Skotska, Velké Británie i Ruského námořnictva."
        ),
        "rostislava": .init(
            language: "Slovanský",
            meaning: "Rozrůstající se sláva — ženská forma Rostislava (rosti = růst + slava)",
            funFact: "Rostislava je ženská forma Rostislava. Kníže Rastislav Moravský pozval v roce 863 Cyrila a Metoděje — tím dal podnět ke vzniku první slovanské abecedy a literatury. Svátek slaví 19. dubna spolu s mužskou formou Rostislavem."
        ),
        "stanislava": .init(
            language: "Slovanský",
            meaning: "Stát si za svou slávou — ženská forma Stanislava (stan + slava)",
            funFact: "Stanislava je ženská forma Stanislava. Sv. Stanislav byl krakovský biskup a mučedník, patron Polska. Stanislava Grycová nebo Stanislava Bartošová jsou nositelky tohoto jména v české historii. Svátek slaví 9. června."
        ),
        "xenie": .init(
            language: "Řecký",
            meaning: "Pohostinnost, cizinka (xenos = cizinec, host)",
            funFact: "Xenie pochází z řeckého xenia — posvátná pohostinnost, která v Řecku zavazovala hostitele chránit i cizince. Zeus jako Xenios (Pohostinný) trestal porušení pohostinnosti. Kořen xen- je v xenofobii (strach z cizinců) i xenotransplantaci (transplantace od jiného druhu)."
        ),
    ]
}

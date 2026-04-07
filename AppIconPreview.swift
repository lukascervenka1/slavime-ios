import SwiftUI
import UniformTypeIdentifiers

// MARK: – Light varianta

struct AppIconLight: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.97, blue: 0.92),
                    Color(red: 1.00, green: 0.90, blue: 0.78)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(RadialGradient(
                    colors: [Color.orange.opacity(0.18), Color.clear],
                    center: .center, startRadius: 0, endRadius: 420
                ))
                .frame(width: 840, height: 840)

            iconSparkles(bright: false)
            iconDots(bright: false)

            Image(systemName: "party.popper.fill")
                .font(.system(size: 400, weight: .regular))
                .foregroundStyle(LinearGradient(
                    colors: [
                        Color(red: 0.97, green: 0.78, blue: 0.20),
                        Color(red: 0.92, green: 0.52, blue: 0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: Color.orange.opacity(0.25), radius: 20, x: 0, y: 10)
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: 220))
    }
}

// MARK: – Dark varianta

struct AppIconDark: View {
    var body: some View {
        ZStack {
            // Tmavý charcoal – ne pure black (jako ostatní prémiové ikonky)
            Color(red: 0.09, green: 0.09, blue: 0.11)

            // Jemný středový glow
            Circle()
                .fill(RadialGradient(
                    colors: [Color.white.opacity(0.08), Color.clear],
                    center: .center, startRadius: 0, endRadius: 420
                ))
                .frame(width: 840, height: 840)

            iconSparkles(bright: true)
            iconDots(bright: true)

            // Silnější outline – .semibold místo .thin
            Image(systemName: "party.popper")
                .font(.system(size: 400, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.95))
                .shadow(color: Color.white.opacity(0.25), radius: 24, x: 0, y: 0)
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: 220))
    }
}

// MARK: – Sdílené dekorace

private func iconSparkles(bright: Bool) -> some View {
    let opacity = bright ? 0.85 : 0.55
    let color: Color = bright
        ? Color(red: 1.00, green: 0.88, blue: 0.45)
        : Color(red: 0.92, green: 0.65, blue: 0.20)
    return Group {
        iconSparkle(x: -220, y: -200, size: 28, color: color, opacity: opacity)
        iconSparkle(x:  200, y: -230, size: 40, color: color, opacity: opacity)
        iconSparkle(x: -230, y:  160, size: 22, color: color, opacity: opacity * 0.8)
        iconSparkle(x:  220, y:  180, size: 34, color: color, opacity: opacity)
        iconSparkle(x:   60, y: -260, size: 24, color: color, opacity: opacity * 0.85)
        iconSparkle(x: -140, y:  240, size: 30, color: color, opacity: opacity * 0.9)
        iconSparkle(x:  150, y:  250, size: 20, color: color, opacity: opacity * 0.75)
    }
}

private func iconDots(bright: Bool) -> some View {
    let alpha = bright ? 0.85 : 0.65
    let c1 = Color.orange.opacity(alpha)
    let c2 = Color(red: 0.97, green: 0.75, blue: 0.22).opacity(alpha)
    let c3 = Color(red: 0.97, green: 0.60, blue: 0.28).opacity(alpha)
    return Group {
        iconDot(x: -190, y: -100, size: 12, color: bright ? .white.opacity(0.45) : c1)
        iconDot(x:  185, y: -120, size:  9, color: bright ? .white.opacity(0.40) : c2)
        iconDot(x: -160, y:  125, size: 10, color: bright ? .white.opacity(0.38) : c3)
        iconDot(x:  175, y:  110, size: 13, color: bright ? .white.opacity(0.45) : c1)
        iconDot(x:    0, y: -230, size:  8, color: bright ? .white.opacity(0.35) : c2)
        iconDot(x: -240, y:   15, size:  7, color: bright ? .white.opacity(0.38) : c1)
        iconDot(x:  240, y:   30, size:  9, color: bright ? .white.opacity(0.40) : c3)
    }
}

private func iconSparkle(x: CGFloat, y: CGFloat, size: CGFloat, color: Color, opacity: Double) -> some View {
    Image(systemName: "sparkle")
        .font(.system(size: size, weight: .light))
        .foregroundStyle(color.opacity(opacity))
        .offset(x: x, y: y)
}

private func iconDot(x: CGFloat, y: CGFloat, size: CGFloat, color: Color) -> some View {
    Circle().fill(color).frame(width: size, height: size).offset(x: x, y: y)
}

// MARK: – Export ikony do Assets (spusť v Simulátoru)

struct PNGExport: Transferable {
    let url: URL
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .png) { SentTransferredFile($0.url) }
    }
}

struct IconExporterView: View {
    @State private var lightExport: PNGExport? = nil
    @State private var darkExport: PNGExport? = nil
    @State private var status = "Klikni pro vygenerování ikon"
    @State private var done = false

    var body: some View {
        VStack(spacing: 28) {
            // Náhled obou ikon
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    AppIconLight()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    Text("Light").font(.caption).foregroundStyle(.secondary)
                }
                VStack(spacing: 8) {
                    AppIconDark()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    Text("Dark").font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(.top, 20)

            // Status
            Text(status)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if done, let light = lightExport, let dark = darkExport {
                // Share tlačítka
                ShareLink(item: light, preview: SharePreview("icon-light.png")) {
                    Label("Sdílet Light ikonu", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.orange)
                }

                ShareLink(item: dark, preview: SharePreview("icon-dark.png")) {
                    Label("Sdílet Dark ikonu", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.black, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 4)

                Text("Ulož oba soubory do:\nAssets.xcassets → AppIcon.appiconset")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

            } else {
                Button { renderAndSave() } label: {
                    Label("Vygenerovat ikony", systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(.horizontal, 24)
        .onAppear { renderAndSave() }
    }

    @MainActor
    func renderAndSave() {
        status = "Renderuji…"

        // Zkusíme zapsat přímo na Mac Desktop (funguje v Simulátoru)
        let home = ProcessInfo.processInfo.environment["HOME"] ?? ""
        let assetsPath = home.isEmpty ? nil
            : "/Users/lukas.cervenka/Documents/Svatek/Assets.xcassets/AppIcon.appiconset"

        let tmpDir = FileManager.default.temporaryDirectory

        // Light
        let lightRenderer = ImageRenderer(content: AppIconLight().frame(width: 1024, height: 1024))
        lightRenderer.scale = 1.0
        if let data = lightRenderer.uiImage?.pngData() {
            // Zkus uložit do Assets přímo
            if let path = assetsPath {
                let url = URL(fileURLWithPath: path + "/icon-light.png")
                if (try? data.write(to: url)) != nil {
                    status = "Uloženo přímo do Assets!"
                }
            }
            // Vždy ulož i do temp pro Share
            let tmpURL = tmpDir.appendingPathComponent("icon-light.png")
            try? data.write(to: tmpURL)
            lightExport = PNGExport(url: tmpURL)
        }

        // Dark
        let darkRenderer = ImageRenderer(content: AppIconDark().frame(width: 1024, height: 1024))
        darkRenderer.scale = 1.0
        if let data = darkRenderer.uiImage?.pngData() {
            if let path = assetsPath {
                let url = URL(fileURLWithPath: path + "/icon-dark.png")
                try? data.write(to: url)
            }
            let tmpURL = tmpDir.appendingPathComponent("icon-dark.png")
            try? data.write(to: tmpURL)
            darkExport = PNGExport(url: tmpURL)
        }

        done = true
        if status == "Renderuji…" {
            status = "Ikony připraveny — sdílej nebo pošli AirDropem"
        }
    }
}

// MARK: – Previews

#Preview("Light") {
    AppIconLight().frame(width: 1024, height: 1024).ignoresSafeArea()
}

#Preview("Dark") {
    AppIconDark().frame(width: 1024, height: 1024).preferredColorScheme(.dark).ignoresSafeArea()
}

#Preview("Export") {
    IconExporterView()
}

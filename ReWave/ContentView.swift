//
//  ContentView.swift
//  ReWave
//
//  Created by syy on 9/10/26.
//

import SwiftUI
import ThemeKit

/// ThemeKit 主题库能力展示：双主题切换、浅深外观、全 Token 色板、字体与效果。
struct ContentView: View {
    @EnvironmentObject private var manager: ThemeManager
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: ThemeSpacing.xl) {
                header
                controlsCard
                paletteCard
                typographyCard
                effectsCard
            }
            .padding(ThemeSpacing.xl)
        }
        .background(theme.palette.background.base)
    }

    // MARK: - 头部

    private var header: some View {
        VStack(spacing: ThemeSpacing.xs) {
            Text("ThemeKit")
                .font(theme.typography.display)
                .foregroundColor(theme.palette.text.primary)
            Text("\(theme.displayName) · \(theme.colorScheme == .dark ? "深色" : "浅色")外观")
                .font(theme.typography.body)
                .foregroundColor(theme.palette.text.tertiary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 切换控制

    private var controlsCard: some View {
        DemoCard("主题与外观") {
            VStack(spacing: ThemeSpacing.md) {
                Picker("主题", selection: Binding(
                    get: { manager.currentTheme.id },
                    set: { manager.setTheme(id: $0) }
                )) {
                    ForEach(manager.themes, id: \.id) { item in
                        Text(item.displayName).tag(item.id)
                    }
                }
                .pickerStyle(.segmented)

                Picker("外观", selection: $manager.appearancePreference) {
                    ForEach(AppearancePreference.allCases) { preference in
                        Text(preference.displayName).tag(preference)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    // MARK: - 色板

    private var paletteCard: some View {
        DemoCard("色板 Token") {
            VStack(spacing: ThemeSpacing.lg) {
                SwatchGrid(items: [
                    .init(name: "50", color: theme.palette.primary.c50),
                    .init(name: "100", color: theme.palette.primary.c100),
                    .init(name: "200", color: theme.palette.primary.c200),
                    .init(name: "300", color: theme.palette.primary.c300),
                    .init(name: "400", color: theme.palette.primary.c400),
                    .init(name: "500", color: theme.palette.primary.c500),
                    .init(name: "600", color: theme.palette.primary.c600),
                    .init(name: "700", color: theme.palette.primary.c700),
                    .init(name: "purple", color: theme.palette.primary.purple),
                    .init(name: "purple-d", color: theme.palette.primary.purpleDark),
                ])
                SwatchGrid(items: [
                    .init(name: "base", color: theme.palette.background.base),
                    .init(name: "elevated", color: theme.palette.background.elevated),
                    .init(name: "elevated-2", color: theme.palette.background.elevated2),
                    .init(name: "surface-1", color: theme.palette.surface.s1),
                    .init(name: "surface-2", color: theme.palette.surface.s2),
                    .init(name: "surface-3", color: theme.palette.surface.s3),
                    .init(name: "surface-4", color: theme.palette.surface.s4),
                ])
                SwatchGrid(items: [
                    .init(name: "subtle", color: theme.palette.border.subtle),
                    .init(name: "default", color: theme.palette.border.standard),
                    .init(name: "strong", color: theme.palette.border.strong),
                    .init(name: "brand", color: theme.palette.border.brand),
                    .init(name: "success", color: theme.palette.semantic.success),
                    .init(name: "warning", color: theme.palette.semantic.warning),
                    .init(name: "error", color: theme.palette.semantic.error),
                    .init(name: "info", color: theme.palette.semantic.info),
                ])
                textSamples
            }
        }
    }

    private var textSamples: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.xs) {
            TextSample("text-primary", color: theme.palette.text.primary)
            TextSample("text-secondary", color: theme.palette.text.secondary)
            TextSample("text-tertiary", color: theme.palette.text.tertiary)
            TextSample("text-quaternary", color: theme.palette.text.quaternary)
            TextSample("text-disabled", color: theme.palette.text.disabled)
        }
    }

    // MARK: - 字体

    private var typographyCard: some View {
        DemoCard("字体 Token") {
            VStack(spacing: ThemeSpacing.sm) {
                FontRow(name: "display", font: theme.typography.display, sample: "ReWave")
                FontRow(name: "heading-1", font: theme.typography.heading1, sample: "重新塑造每一段波形")
                FontRow(name: "heading-2", font: theme.typography.heading2, sample: "区域标题")
                FontRow(name: "heading-3", font: theme.typography.heading3, sample: "导航栏标题")
                FontRow(name: "body-large", font: theme.typography.bodyLarge, sample: "引导页描述文字 16px")
                FontRow(name: "body", font: theme.typography.body, sample: "正文、列表项文字 14px")
                FontRow(name: "body-small", font: theme.typography.bodySmall, sample: "次要正文 13px")
                FontRow(name: "caption", font: theme.typography.caption, sample: "元信息、标签 12px")
                FontRow(name: "tiny", font: theme.typography.tiny, sample: "极小辅助 11px")
                FontRow(name: "micro", font: theme.typography.micro, sample: "Tab 标签 10px")
                FontRow(name: "mono-display", font: theme.typography.monoDisplay, sample: "00:12.480")
                FontRow(name: "mono-body", font: theme.typography.monoBody, sample: "44100Hz / 24bit")
                FontRow(name: "mono-small", font: theme.typography.monoSmall, sample: "3.2 MB · 320kbps")
            }
        }
    }

    // MARK: - 效果

    private var effectsCard: some View {
        DemoCard("渐变 / 阴影 / 图标") {
            VStack(spacing: ThemeSpacing.lg) {
                RoundedRectangle(cornerRadius: ThemeRadius.lg)
                    .fill(theme.effects.brandGradient)
                    .frame(height: 56)
                    .overlay(
                        Text("品牌渐变 · 主 CTA")
                            .font(theme.typography.bodyLarge)
                            .foregroundColor(theme.palette.text.onBrand)
                    )
                    .themeShadow(theme.effects.shadowBrand)

                HStack(spacing: ThemeSpacing.md) {
                    shadowChip("shadow-sm", theme.effects.shadowSm)
                    shadowChip("shadow-md", theme.effects.shadowMd)
                    shadowChip("shadow-lg", theme.effects.shadowLg)
                }

                HStack(spacing: ThemeSpacing.md) {
                    Image(systemName: "waveform")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(theme.palette.icon.foreground)
                        .frame(width: 48, height: 48)
                        .background(theme.palette.icon.background)
                        .cornerRadius(ThemeRadius.lg)
                    Text("功能图标：单色品牌底 + 品牌色图标")
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.palette.text.tertiary)
                }
            }
        }
    }

    private func shadowChip(_ name: String, _ shadow: ThemeShadow) -> some View {
        Text(name)
            .font(theme.typography.monoSmall)
            .foregroundColor(theme.palette.text.tertiary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, ThemeSpacing.md)
            .background(theme.palette.background.elevated2)
            .cornerRadius(ThemeRadius.sm)
            .themeShadow(shadow)
    }
}

// MARK: - 子组件

/// 展示卡片容器：区域小标题 + 内容。
private struct DemoCard<Content: View>: View {
    @Environment(\.theme) private var theme
    private let title: String
    private let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeSpacing.lg) {
            SectionLabel(title)
            content
        }
        .padding(ThemeSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.palette.background.elevated)
        .cornerRadius(ThemeRadius.lg)
    }
}

/// 色卡网格。
private struct SwatchGrid: View {
    @Environment(\.theme) private var theme
    private let items: [Item]

    struct Item {
        let name: String
        let color: Color
    }

    init(items: [Item]) {
        self.items = items
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 68), spacing: ThemeSpacing.sm)], spacing: ThemeSpacing.sm) {
            ForEach(items, id: \.name) { item in
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(item.color)
                        .frame(height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(theme.palette.border.standard))
                    Text(item.name)
                        .font(theme.typography.tiny)
                        .foregroundColor(theme.palette.text.tertiary)
                }
            }
        }
    }
}

/// 文字层级样例行。
private struct TextSample: View {
    @Environment(\.theme) private var theme
    private let name: String
    private let color: Color

    init(_ name: String, color: Color) {
        self.name = name
        self.color = color
    }

    var body: some View {
        HStack {
            Text(name).font(theme.typography.monoSmall)
            Spacer()
            Text("重新塑造每一段波形 Ag 012")
                .font(theme.typography.body)
                .foregroundColor(color)
        }
    }
}

/// 字体样例行。
private struct FontRow: View {
    @Environment(\.theme) private var theme
    private let name: String
    private let font: Font
    private let sample: String

    init(name: String, font: Font, sample: String) {
        self.name = name
        self.font = font
        self.sample = sample
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(theme.typography.monoSmall)
                .foregroundColor(theme.palette.text.quaternary)
            Text(sample)
                .font(font)
                .foregroundColor(theme.palette.text.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

//
//  EmberTheme.swift
//  ReWave
//
//  Created by syy on 9/10/26.
//

import SwiftUI
import ThemeKit

/// 示例第二主题（暖橙调）：演示其他 app 仅用一个文件、只依赖 ThemeKit 公开 API
/// 即可定义自己的品牌主题。字体族不指定，自动回退系统字体。
struct EmberTheme: Theme {
    let id = "ember"
    let displayName = "Ember"
    let typography = ThemeTypography()
    let light: ThemeAppearance
    let dark: ThemeAppearance

    init() {
        let primary = ThemePalette.PrimaryScale(
            c50: Color(hex: "FFF3EC"),
            c100: Color(hex: "FFE4D6"),
            c200: Color(hex: "FFC5AA"),
            c300: Color(hex: "FFA478"),
            c400: Color(hex: "FF8A55"),
            c500: Color(hex: "FF7A45"),
            c600: Color(hex: "E85D2F"),
            c700: Color(hex: "C44A22"),
            purple: Color(hex: "E0483E"),
            purpleDark: Color(hex: "C2352C")
        )
        let brandGradient = LinearGradient(
            colors: [Color(hex: "FF7A45"), Color(hex: "E0483E")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        dark = ThemeAppearance(
            palette: ThemePalette(
                primary: primary,
                background: .init(
                    base: Color(hex: "140F0B"),
                    elevated: Color(hex: "1C1510"),
                    elevated2: Color(hex: "241B14")
                ),
                surface: .init(
                    s1: .white.opacity(0.03),
                    s2: .white.opacity(0.06),
                    s3: .white.opacity(0.08),
                    s4: .white.opacity(0.12)
                ),
                border: .init(
                    subtle: .white.opacity(0.05),
                    standard: .white.opacity(0.08),
                    strong: .white.opacity(0.14),
                    brand: Color(hex: "FF7A45").opacity(0.40)
                ),
                text: .init(
                    primary: .white,
                    secondary: .white.opacity(0.72),
                    tertiary: .white.opacity(0.45),
                    quaternary: .white.opacity(0.28),
                    disabled: .white.opacity(0.16),
                    onBrand: .white
                ),
                semantic: .init(
                    success: Color(hex: "10B981"),
                    warning: Color(hex: "F59E0B"),
                    error: Color(hex: "EF4444"),
                    info: Color(hex: "06B6D4"),
                    successBg: Color(hex: "10B981").opacity(0.12),
                    warningBg: Color(hex: "F59E0B").opacity(0.12),
                    errorBg: Color(hex: "EF4444").opacity(0.12),
                    infoBg: Color(hex: "06B6D4").opacity(0.12)
                ),
                icon: .init(
                    background: Color(hex: "FF7A45").opacity(0.12),
                    foreground: Color(hex: "FF7A45")
                )
            ),
            effects: ThemeEffects(
                brandGradient: brandGradient,
                shadowSm: ThemeShadow(color: .black.opacity(0.2), radius: 8, y: 2),
                shadowMd: ThemeShadow(color: .black.opacity(0.4), radius: 20, y: 4),
                shadowLg: ThemeShadow(color: .black.opacity(0.6), radius: 40, y: 12),
                shadowBrand: ThemeShadow(color: Color(hex: "FF7A45").opacity(0.25), radius: 32, y: 8),
                shadowBrandStrong: ThemeShadow(color: Color(hex: "FF7A45").opacity(0.35), radius: 40, y: 12)
            )
        )

        light = ThemeAppearance(
            palette: ThemePalette(
                primary: primary,
                background: .init(
                    base: Color(hex: "FAF6F2"),
                    elevated: .white,
                    elevated2: .white
                ),
                surface: .init(
                    s1: .black.opacity(0.03),
                    s2: .black.opacity(0.06),
                    s3: .black.opacity(0.08),
                    s4: .black.opacity(0.12)
                ),
                border: .init(
                    subtle: .black.opacity(0.05),
                    standard: .black.opacity(0.08),
                    strong: .black.opacity(0.14),
                    brand: Color(hex: "FF7A45").opacity(0.40)
                ),
                text: .init(
                    primary: Color(hex: "140F0B"),
                    secondary: .black.opacity(0.72),
                    tertiary: .black.opacity(0.55),
                    quaternary: .black.opacity(0.40),
                    disabled: .black.opacity(0.25),
                    onBrand: .white
                ),
                semantic: .init(
                    success: Color(hex: "059669"),
                    warning: Color(hex: "D97706"),
                    error: Color(hex: "DC2626"),
                    info: Color(hex: "0891B2"),
                    successBg: Color(hex: "059669").opacity(0.10),
                    warningBg: Color(hex: "D97706").opacity(0.10),
                    errorBg: Color(hex: "DC2626").opacity(0.10),
                    infoBg: Color(hex: "0891B2").opacity(0.10)
                ),
                icon: .init(
                    background: Color(hex: "FF7A45").opacity(0.12),
                    foreground: Color(hex: "E85D2F")
                )
            ),
            effects: ThemeEffects(
                brandGradient: brandGradient,
                shadowSm: ThemeShadow(color: .black.opacity(0.06), radius: 8, y: 2),
                shadowMd: ThemeShadow(color: .black.opacity(0.08), radius: 20, y: 4),
                shadowLg: ThemeShadow(color: .black.opacity(0.12), radius: 40, y: 12),
                shadowBrand: ThemeShadow(color: Color(hex: "FF7A45").opacity(0.20), radius: 32, y: 8),
                shadowBrandStrong: ThemeShadow(color: Color(hex: "FF7A45").opacity(0.28), radius: 40, y: 12)
            )
        )
    }
}

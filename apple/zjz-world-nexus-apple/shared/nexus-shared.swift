import AuthenticationServices
import CoreText
import CryptoKit
import Foundation
import Security
#if os(iOS) || os(macOS)
import StoreKit
#endif
import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import WebKit

enum NexusSection: String, CaseIterable, Codable, Identifiable {
  case passwords
  case apiKeys
  case cards
  case subscriptions

  var id: String { rawValue }

  var title: String {
    switch self {
    case .passwords: return "PASSWORDS"
    case .apiKeys: return "API KEYS"
    case .cards: return "CARDS"
    case .subscriptions: return "RECURRINGS"
    }
  }

  var tabTitle: String {
    switch self {
    case .passwords: return "Passwords"
    case .apiKeys: return "Keys"
    case .cards: return "Cards"
    case .subscriptions: return "Recurrings"
    }
  }

  var navIconPath: String {
    switch self {
    case .passwords: return "/shared/icons/passwords.png"
    case .apiKeys: return "/shared/icons/keys.png"
    case .cards: return "/shared/icons/cards.png"
    case .subscriptions: return "/shared/icons/recurrings.png"
    }
  }

  var resourceId: String { rawValue }
}

enum NexusBottomTabItem: String, CaseIterable, Identifiable {
  case passwords
  case apiKeys
  case cards
  case subscriptions
  case settings

  var id: String { rawValue }

  var section: NexusSection? {
    switch self {
    case .passwords: return .passwords
    case .apiKeys: return .apiKeys
    case .cards: return .cards
    case .subscriptions: return .subscriptions
    case .settings: return nil
    }
  }

  var title: String {
    switch self {
    case .passwords: return NexusSection.passwords.tabTitle
    case .apiKeys: return NexusSection.apiKeys.tabTitle
    case .cards: return NexusSection.cards.tabTitle
    case .subscriptions: return NexusSection.subscriptions.tabTitle
    case .settings: return "Settings"
    }
  }

  var iconPath: String? {
    section?.navIconPath
  }
}

enum NexusTokens {
  static let gutter: CGFloat = 36
  static let control: CGFloat = gutter
  static let seam: CGFloat = 1
  static let modalActionGap: CGFloat = gutter
  static let modalLabelOffset: CGFloat = 8
  static let corner: CGFloat = 4
  static let grid: CGFloat = 32
  static let sidebarWidth: CGFloat = 220
  static let loggedOutBrandMin: CGFloat = 56
  static let loggedOutBrandMax: CGFloat = 88
  static let loggedOutBrandScale: CGFloat = 0.09
  static let loggedOutBrandTracking: CGFloat = -0.035
  static let loggedOutFieldWidth: CGFloat = 232
  static let loggedOutContentOffsetY: CGFloat = -25
  static let loggedOutActionGap: CGFloat = 39
  static let loggedOutSignInWidth: CGFloat = 94
  static let loggedOutCreateWidth: CGFloat = 98
  static let loggedOutFieldPadding: CGFloat = 14
  static let topBarHorizontalPadding: CGFloat = 18
  static let topBarVerticalPadding: CGFloat = 14
  static let toolbarRowGap: CGFloat = 8
  static let toolbarActionGap: CGFloat = 8
  static let mobileNavGap: CGFloat = 8
  static let mobileNavBottomPadding: CGFloat = 8
  static let mobileMetricsBottomPadding: CGFloat = seam
  static let bottomTabHeight: CGFloat = 64
  static let bottomTabHorizontalPadding: CGFloat = 18
  static let bottomTabVerticalPadding: CGFloat = 8
  static let bottomTabInnerPadding: CGFloat = 5
  static let bottomTabItemGap: CGFloat = 3
  static let bottomTabIconSize: CGFloat = 21.5
  static let IconSize: CGFloat = bottomTabIconSize
  static let bottomTabContentOffsetY: CGFloat = 0
  static let bottomTabLabelFont = NexusFont.regular(10.5)
  static let bottomTabSelectedVerticalPadding: CGFloat = 5
  static let bottomTabDragMinimumDistance: CGFloat = 0
  static let bottomTabPressScale: CGFloat = 1.02
  static let bottomTabDragSelectionWidthScale: CGFloat = 1.04
  static let bottomTabDragSelectionHeightScale: CGFloat = 1.04
  static let bottomTabSettingsIconViewBox: CGFloat = 24
  static let bottomTabSettingsIconOuterDiameter: CGFloat = 19
  static let bottomTabSettingsIconOpticalScale: CGFloat = 0.94
  static let bottomTabSettingsIconVisualScale: CGFloat = bottomTabSettingsIconViewBox / bottomTabSettingsIconOuterDiameter * bottomTabSettingsIconOpticalScale
  static let bottomTabSettingsIconStrokeWidth: CGFloat = bottomTabIconSize * (1.05 / 24)
  static let bottomTabGlassSpacing: CGFloat = 18
  static let bottomTabGlassBottomPadding: CGFloat = 8
  static let bottomTabGlassSurfaceOpacity: Double = liquidGlassFallbackOpacity
  static let navItemGap: CGFloat = 12
  static let navIconSize: CGFloat = 17
  static let buttonSymbolSize: CGFloat = 30
  static let toolbarIconStrokeWidth: CGFloat = 1.05
  static let toolbarIconInset: CGFloat = 1
  static let toolbarIconSize: CGFloat = IconSize * 1.18
  static let toolbarGlassButtonSize: CGFloat = 46
  static let toolbarGlassIconSize: CGFloat = IconSize * 1.18
  static let toolbarAccountWeightOffset: CGFloat = .zero
  static let toolbarIconColor = Color.black
  static let toolbarAddImageName = "toolbar-add"
  static let toolbarUserImageName = "toolbar-user"
  static let searchGlassHeight: CGFloat = 46
  static let searchGlassHorizontalPadding: CGFloat = 16
  static let searchGlassIconSize: CGFloat = 18
  static let pageDesktopHorizontalPadding: CGFloat = 28
  static let pageDesktopBottomPadding: CGFloat = 48
  static let pageMobileHorizontalPadding: CGFloat = 18
  static let pageMobileTopPadding: CGFloat = 0
  static let pageMobileBottomPadding: CGFloat = 40
  static let passwordsDesktopTopPadding: CGFloat = 34
  static let apiKeysDesktopTopPadding: CGFloat = 22
  static let defaultDesktopTopPadding: CGFloat = 30
  static let pageSectionGap: CGFloat = 30
  static let metricHorizontalGap: CGFloat = 48
  static let metricCompactGap: CGFloat = 16
  static let subscriptionsMetricGap: CGFloat = 38
  static let markerSize: CGFloat = 4
  static let metricBorderWidth: CGFloat = 2
  static let metricInset: CGFloat = 16
  static let subscriptionsMetricInset: CGFloat = 18
  static let metricValueBleedPadding: CGFloat = 8
  static let metricValueVerticalPadding: CGFloat = 5
  static let compactPasswordSectionGap: CGFloat = 12
  static let compactPasswordMetricGap: CGFloat = 0
  static let compactPasswordMetricHeight: CGFloat = 58
  static let compactPasswordMetricStackGap: CGFloat = 5
  static let compactPasswordMetricLabelHeight: CGFloat = 12
  static let compactPasswordMetricLabelTracking: CGFloat = 1.8
  static let compactPasswordMetricLabelFont = NexusFont.regular(9)
  static let compactPasswordMetricValueFont = NexusFont.bold(22)
  static let compactPasswordMetricValueFontWide = NexusFont.bold(22)
  static let compactPasswordMetricValueFontExtraWide = NexusFont.bold(18)
  static let compactPasswordMetricValueFontTwoLine = NexusFont.bold(20)
  static let compactPasswordMetricValueFontDense = NexusFont.bold(16)
  static let compactPasswordMetricValueLineSpacing: CGFloat = -2
  static let compactPasswordRowGap: CGFloat = seam
  static let compactPasswordRowMinHeight: CGFloat = 50
  static let compactPasswordRowPaddingInline: CGFloat = 10
  static let compactPasswordRowPaddingBlock: CGFloat = 4
  static let compactPasswordRowIconSize: CGFloat = 30
  static let compactPasswordRowBodyGap: CGFloat = 4
  static let compactPasswordRowServiceRatio: CGFloat = 0.4
  static let compactPasswordRowMetaHeight: CGFloat = 17
  static let compactPasswordRowInlineGap: CGFloat = 8
  static let compactPasswordRowSeparatorWidth: CGFloat = 12
  static let compactPasswordRowMetaFont = NexusFont.semibold(13)
  static let compactPasswordRowUsernameFont = NexusFont.bold(15)
  static let compactPasswordRowMaskFont = NexusFont.bold(13)
  static let compactPasswordRowMaskTracking: CGFloat = 1.6
  static let compactPasswordRowActionWidth: CGFloat = 22
  static let compactPasswordRowActionDotGap: CGFloat = 3
  static let compactAPIKeyRowMinHeight: CGFloat = compactPasswordRowMinHeight
  static let compactAPIKeyRowNameFont = compactPasswordRowMetaFont
  static let compactAPIKeyRowValueFont = compactPasswordRowUsernameFont
  static let compactAPIKeyRowValueTracking: CGFloat = -0.55
  static let compactAPIKeyNameRatio: CGFloat = 0.7
  static let compactResourceRowMinHeight: CGFloat = 54
  static let compactResourceRowIconSize: CGFloat = compactPasswordRowIconSize
  static let compactResourceRowSideGap: CGFloat = tableCellGap
  static let compactResourceRowTrailingWidth: CGFloat = 72
  static let compactResourceRowAuxWidth: CGFloat = 46
  static let compactRecurringTrailingWidth: CGFloat = 88
  static let compactResourceTagLineHeight: CGFloat = 22
  static let compactResourceDetailLineHeight: CGFloat = 18
  static let compactResourceRowRightDetailFont = compactPasswordRowMaskFont
  static let compactCardNameRatio: CGFloat = 0.6
  static let compactCardNumberRatio: CGFloat = 0.58
  static let compactCardExpiryRatio: CGFloat = 0.2
  static let compactCardDetailExpiryRatio: CGFloat = 0.48
  static let compactCardSecurityRatio: CGFloat = 0.22
  static let compactCardSecurityLeadingInset: CGFloat = compactPasswordRowInlineGap * 2
  static let compactRecurringNameRatio: CGFloat = 0.35
  static let compactRecurringTierRatio: CGFloat = 0.325
  static let compactRecurringCadenceRatio: CGFloat = 0.325
  static let compactRecurringAmountRatio: CGFloat = 0.5
  static let tableHeaderVerticalPadding: CGFloat = 14
  static let tableCellHorizontalPadding: CGFloat = 16
  static let tableCellVerticalPadding: CGFloat = 14.4
  static let tableRowMinHeight: CGFloat = 54
  static let tableIconSize: CGFloat = 30
  static let tableIconFallbackFontSize: CGFloat = 15
  static let tableIconFallbackFontWeight: CGFloat = 600
  static let tableCellGap: CGFloat = 8
  static let popupRowHeight: CGFloat = 48
  static let popupRowGap: CGFloat = 4
  static let popupRowPadding: CGFloat = 6
  static let boxedCellHeight: CGFloat = 28
  static let boxedCellHorizontalPadding: CGFloat = 10
  static let passwordsTableMinWidth: CGFloat = 960
  static let apiKeysTableMinWidth: CGFloat = 760
  static let cardsTableMinWidth: CGFloat = 980
  static let subscriptionsBoardMinWidth: CGFloat = 980
  static let subscriptionsBoardGap: CGFloat = 16
  static let subscriptionsRowGap: CGFloat = 13
  static let subscriptionsRowHorizontalPadding: CGFloat = 16
  static let subscriptionsRowVerticalPadding: CGFloat = 18
  static let editorOverlayPadding: CGFloat = 28
  static let editorPanelPadding: CGFloat = 36
  static let editorMobileOverlayPadding: CGFloat = 14
  static let editorMobilePanelHorizontalPadding: CGFloat = 18
  static let editorMobilePanelTopPadding: CGFloat = 24
  static let editorMobilePanelBottomPadding: CGFloat = 18
  static let editorActionGap: CGFloat = 12
  static let editorFieldWidth: CGFloat = 280
  static let editorFieldGap: CGFloat = 36
  static let editorIconSize: CGFloat = 52
  static let editorTextAreaHeight: CGFloat = 96
  static let editorChoiceGap: CGFloat = 1
  static let editorChoiceWidth: CGFloat = 140
  static let editorChoiceHorizontalPadding: CGFloat = 12
  static let editorDigitBoxWidth: CGFloat = 40
  static let editorDigitBoxGap: CGFloat = 10
  static let editorPinMaxDigits = 6
  static let editorActionIconScale: CGFloat = 1.08
  static let editorFieldBorder = Color.black.opacity(0.14)
  static let editorNavHeight: CGFloat = control + gutter
  static let editorNavSideWidth: CGFloat = control * 2.4
  static let editorNavHorizontalPadding: CGFloat = topBarHorizontalPadding
  static let editorNavTitleFont = NexusFont.regular(13)
  static let editorNavButtonFont = NexusFont.regular(13)
  static let editorNavTitleTracking: CGFloat = compactPasswordMetricLabelTracking
  static let editorNavButtonTracking: CGFloat = compactPasswordMetricLabelTracking
  static let editorPanelCornerRadius: CGFloat = 0
  static let editorRowHeightBoost: CGFloat = tableCellGap / 2
  static let editorControlHeight: CGFloat = control + editorRowHeightBoost
  static let editorTitleRowHeight: CGFloat = control + gutter + editorRowHeightBoost
  static let editorTitleIconSize: CGFloat = tableIconSize
  static let editorRowHeight: CGFloat = control + (tableCellGap * 2) + editorRowHeightBoost
  static let editorSecureIconSize: CGFloat = IconSize
  static let editorRowHorizontalPadding: CGFloat = topBarHorizontalPadding
  static let editorRowIconGap: CGFloat = tableCellGap
  static let editorFieldFont = NexusFont.regular(14)
  static let editorInlineFieldGap: CGFloat = tableCellGap
  static let editorFallbackIconFont = NexusFont.regular(tableIconFallbackFontSize)
  static let editorSectionHeaderHeight: CGFloat = editorControlHeight
  static let editorSectionHeaderFont = NexusFont.regular(10)
  static let editorSectionHeaderTracking: CGFloat = compactPasswordMetricLabelTracking
  static let editorPanelBackground = Color.white.opacity(0.72)
  static let editorRowBackground = Color.white.opacity(0.86)
  static let editorDivider = Color.black.opacity(0.12)
  static let editorPlaceholder = Color.black.opacity(0.42)
  static let editorSecureIconStrokeWidth: CGFloat = toolbarIconStrokeWidth
  static let editorChoiceHeight: CGFloat = chipMinHeight
  static let editorPasswordGeneratorDisplayHeight: CGFloat = editorControlHeight
  static let editorPasswordGeneratorOptionWidth: CGFloat = editorChoiceHeight * 2
  static let editorPasswordLengthWidth: CGFloat = editorControlHeight * 0.78
  static let editorPasswordLengthGroupWidth: CGFloat = editorControlHeight * 2.75
  static let editorPasswordLengthDefault = 12
  static let editorPasswordLengthMin = 4
  static let editorPasswordLengthMax = 64
  static let editorPasswordRequiredClassRatio = 0.25
  static let editorPasswordRequiredClassMin = 2
  static let editorMaskMinLength = 4
  static let editorMaskMaxLength = 12
  static let settingsToggleScale: CGFloat = 0.82
  static let editorDateValueMinWidth: CGFloat = control * 2.35
  static let editorAccent = Color(red: 0.32, green: 0.68, blue: 0.67)
  static let editorDanger = Color(red: 0.8, green: 0.08, blue: 0.08)
  static let statusSuccess = Color(red: 0.098, green: 0.529, blue: 0.329)
  static let statusSuccessTint = Color(red: 0.098, green: 0.529, blue: 0.329).opacity(0.12)
  static let liquidGlassTint = Color.white.opacity(0.2)
  static let liquidGlassSelectedTint = Color.white.opacity(0.38)
  static let liquidGlassStroke = Color.white.opacity(0.72)
  static let liquidGlassShadow = Color.black.opacity(0.12)
  static let liquidGlassFallbackOpacity: Double = 0.72
  static let liquidGlassSelectedFallbackOpacity: Double = 0.48
  static let liquidGlassStrokeWidth: CGFloat = 1
  static let liquidGlassShadowRadius: CGFloat = 18
  static let liquidGlassShadowYOffset: CGFloat = 8
  static let border = Color.black.opacity(0.12)
  static let softBorder = Color.black.opacity(0.05)
  static let outlineSoft = Color.black.opacity(0.1)
  static let base = Color(red: 0.976, green: 0.976, blue: 0.976)
  static let panel = Color.white.opacity(0.86)
  static let passwordPanel = Color.white.opacity(0.78)
  static let cardPanel = Color.white.opacity(0.88)
  static let tableHeader = Color(red: 0.933, green: 0.933, blue: 0.933).opacity(0.94)
  static let tableHeaderPassword = Color(red: 0.933, green: 0.933, blue: 0.933).opacity(0.82)
  static let mutedPanel = Color(red: 0.953, green: 0.953, blue: 0.957)
  static let section = Color(red: 0.933, green: 0.933, blue: 0.933)
  static let strong = Color(red: 0.039, green: 0.039, blue: 0.039)
  static let muted = Color(red: 0.427, green: 0.427, blue: 0.427)
  static let bottomTabMuted = Color(red: 0.56, green: 0.56, blue: 0.56)
  static let body = Color(red: 0.102, green: 0.11, blue: 0.11)
  static let inputFont = NexusFont.regular(13)
  static let labelFont = NexusFont.bold(10)
  static let editorLabelFont = NexusFont.bold(11)
  static let editorChoiceFont = NexusFont.regular(9)
  static let rowFont = NexusFont.regular(15)
  static let titleFont = NexusFont.semibold(42)
  static let tableHeaderFont = NexusFont.bold(10)
  static let tablePrimaryFont = NexusFont.bold(15)
  static let tableSecondaryFont = NexusFont.regular(14)
  static let tableMonoFont = NexusFont.regular(14)
  static let metricLabelFont = NexusFont.bold(10)
  static let metricValueFont = NexusFont.bold(42)
  static let metricCompactValueFont = NexusFont.bold(30)
  static let popupMetricTagFont = NexusFont.regular(9)
  static let popupMetricValueFont = NexusFont.bold(28)
  static let chipFont = NexusFont.bold(10)
  static let chipTracking: CGFloat = 0.9
  static let chipPaddingInline: CGFloat = 8
  static let chipMinHeight: CGFloat = 22
}

enum NexusMotion {
  static let page = Animation.smooth(duration: 0.22)
  static let tab = Animation.snappy(duration: 0.18)
  static let tabPress = Animation.snappy(duration: 0.16)
  static let modal = Animation.smooth(duration: 0.26)
  static let row = Animation.snappy(duration: 0.16)
}

struct NexusGlassContainer<Content: View>: View {
  let spacing: CGFloat
  @ViewBuilder let content: () -> Content

  var body: some View {
    #if os(iOS)
    if #available(iOS 26.0, *) {
      GlassEffectContainer(spacing: spacing) {
        content()
      }
    } else {
      content()
    }
    #else
    content()
    #endif
  }
}

private struct NexusLiquidGlassCapsuleModifier: ViewModifier {
  var interactive = false
  var tint = NexusTokens.liquidGlassTint
  var fallbackOpacity = NexusTokens.liquidGlassFallbackOpacity

  @ViewBuilder
  func body(content: Content) -> some View {
    #if os(iOS)
    if #available(iOS 26.0, *) {
      content
        .glassEffect(.regular.tint(tint).interactive(interactive), in: Capsule())
        .shadow(
          color: NexusTokens.liquidGlassShadow,
          radius: NexusTokens.liquidGlassShadowRadius,
          y: NexusTokens.liquidGlassShadowYOffset
        )
    } else {
      fallback(content: content)
    }
    #else
    fallback(content: content)
    #endif
  }

  private func fallback(content: Content) -> some View {
    content
      .background(.ultraThinMaterial, in: Capsule())
      .background(Color.white.opacity(fallbackOpacity), in: Capsule())
      .overlay(Capsule().stroke(NexusTokens.liquidGlassStroke, lineWidth: NexusTokens.liquidGlassStrokeWidth))
      .shadow(
        color: NexusTokens.liquidGlassShadow,
        radius: NexusTokens.liquidGlassShadowRadius,
        y: NexusTokens.liquidGlassShadowYOffset
      )
  }
}

private struct NexusLiquidGlassCircleModifier: ViewModifier {
  var interactive = false
  var tint = NexusTokens.liquidGlassTint

  @ViewBuilder
  func body(content: Content) -> some View {
    #if os(iOS)
    if #available(iOS 26.0, *) {
      content
        .glassEffect(.regular.tint(tint).interactive(interactive), in: Circle())
        .shadow(
          color: NexusTokens.liquidGlassShadow,
          radius: NexusTokens.liquidGlassShadowRadius,
          y: NexusTokens.liquidGlassShadowYOffset
        )
    } else {
      fallback(content: content)
    }
    #else
    fallback(content: content)
    #endif
  }

  private func fallback(content: Content) -> some View {
    content
      .background(.ultraThinMaterial, in: Circle())
      .background(Color.white.opacity(NexusTokens.liquidGlassFallbackOpacity), in: Circle())
      .overlay(Circle().stroke(NexusTokens.liquidGlassStroke, lineWidth: NexusTokens.liquidGlassStrokeWidth))
      .shadow(
        color: NexusTokens.liquidGlassShadow,
        radius: NexusTokens.liquidGlassShadowRadius,
        y: NexusTokens.liquidGlassShadowYOffset
      )
  }
}

private extension View {
  func nexusLiquidGlassCapsule(
    interactive: Bool = false,
    tint: Color = NexusTokens.liquidGlassTint,
    fallbackOpacity: Double = NexusTokens.liquidGlassFallbackOpacity
  ) -> some View {
    modifier(NexusLiquidGlassCapsuleModifier(
      interactive: interactive,
      tint: tint,
      fallbackOpacity: fallbackOpacity
    ))
  }

  func nexusLiquidGlassCircle(
    interactive: Bool = false,
    tint: Color = NexusTokens.liquidGlassTint
  ) -> some View {
    modifier(NexusLiquidGlassCircleModifier(interactive: interactive, tint: tint))
  }
}

enum NexusFont {
  static func regular(_ size: CGFloat) -> Font {
    NexusFontRegistry.register()
    return .custom("OpenAISans-Regular", size: size)
  }

  static func medium(_ size: CGFloat) -> Font {
    NexusFontRegistry.register()
    return .custom("OpenAISans-Medium", size: size)
  }

  static func semibold(_ size: CGFloat) -> Font {
    NexusFontRegistry.register()
    return .custom("OpenAISans-Semibold", size: size)
  }

  static func bold(_ size: CGFloat) -> Font {
    NexusFontRegistry.register()
    return .custom("OpenAISans-Bold", size: size)
  }
}

enum NexusFontRegistry {
  static func register() {
    _ = registeredFonts
  }

  private static let registeredFonts: Void = {
    for fileName in [
      "openai-sans-v2-regular",
      "openai-sans-v2-medium",
      "openai-sans-v2-semibold",
      "openai-sans-v2-bold"
    ] {
      guard let url = Bundle.main.url(forResource: fileName, withExtension: "ttf") else {
        continue
      }
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }()
}

struct NexusEnvelope<Value: Decodable>: Decodable {
  let ok: Bool?
  let data: Value?
  let error: String?
}

struct NexusSession: Codable, Hashable {
  let authenticated: Bool
  let email: String
  let token: String?
  let unlocked: Bool?
}

struct NexusItemsPayload<Item: Decodable>: Decodable {
  let items: [Item]
}

struct NexusItemPayload<Item: Decodable>: Decodable {
  let item: Item
}

struct NexusPassword: Codable, Identifiable, Hashable {
  let id: String
  let iconKey: String?
  let iconSource: String?
  let resolvedIconKey: String?
  let service: String?
  let username: String?
  let kinds: [String]?
  let rawSecret: String?
  let passwordMask: String?
  let website: String?
  let note: String?
  let resolvedIconUrl: String?
}

struct NexusAPIKey: Codable, Identifiable, Hashable {
  let id: String
  let keyName: String?
  let rawValue: String?
  let maskedValue: String?
  let environment: String?
  let note: String?
}

struct NexusCard: Codable, Identifiable, Hashable {
  let id: String
  let iconKey: String?
  let iconSource: String?
  let cardName: String?
  let network: String?
  let rawCardNumber: String?
  let maskedNumber: String?
  let creditCurrency: String?
  let creditLimit: Double?
  let expiry: String?
  let rawCvv: String?
  let cvvMask: String?
  let rawPin: String?
  let pinMask: String?
  let billingAnchorDate: String?
  let note: String?
  let resolvedIconUrl: String?
  let resolvedIconKey: String?
}

struct NexusRecurring: Codable, Identifiable, Hashable {
  let id: String
  let service: String?
  let iconKey: String?
  let iconSource: String?
  let tier: String?
  let cadence: String?
  let amountCurrency: String?
  let amount: Double?
  let billingAnchorDate: String?
  let status: String?
  let note: String?
  let resolvedIconUrl: String?
  let resolvedIconKey: String?
  let icon: String?
}

struct NexusMetricItem: Identifiable, Hashable {
  let label: String
  let value: String

  var id: String { label }
}

struct NexusEmptyPayload: Decodable {}

struct NexusSaveItemRequest<FormValues: Encodable>: Encodable {
  let resourceId: String
  let formValues: FormValues
}

struct NexusPasswordFormValues: Encodable {
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  let serviceName: String
  let userName: String
  let credentialMode: String
  let secretValue: String
  let website: String
  let note: String
}

struct NexusPasswordDraft: Hashable {
  let id: String
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  var serviceName: String
  var userName: String
  var credentialMode: String
  var secretValue: String
  var website: String
  var note: String

  init() {
    id = ""
    iconKey = ""
    iconSource = ""
    resolvedIconKey = ""
    serviceName = ""
    userName = ""
    credentialMode = "PASSWORD"
    secretValue = ""
    website = ""
    note = ""
  }

  init(row: NexusPassword) {
    id = row.id
    iconKey = emptyToBlank(row.iconKey)
    iconSource = clean(row.iconSource)
    resolvedIconKey = firstNonEmpty(row.resolvedIconKey, row.iconKey)
    serviceName = clean(row.service)
    userName = clean(row.username)
    credentialMode = passwordCredentialMode(row.kinds)
    secretValue = firstNonEmpty(row.rawSecret, row.passwordMask == "-" ? "" : row.passwordMask)
    website = clean(row.website)
    note = clean(row.note)
  }

  var formValues: NexusPasswordFormValues {
    NexusPasswordFormValues(
      iconKey: iconKey,
      iconSource: iconSource,
      resolvedIconKey: resolvedIconKey,
      serviceName: serviceName,
      userName: userName,
      credentialMode: credentialMode,
      secretValue: secretValue,
      website: website,
      note: note
    )
  }
}

struct NexusAPIKeyFormValues: Encodable {
  let keyName: String
  let keyValue: String
  let environment: String
  let note: String
}

struct NexusAPIKeyDraft: Hashable {
  let id: String
  var keyName: String
  var keyValue: String
  var environment: String
  var note: String

  init() {
    id = ""
    keyName = ""
    keyValue = ""
    environment = "ACTIVE"
    note = ""
  }

  init(row: NexusAPIKey) {
    id = row.id
    keyName = emptyToBlank(row.keyName)
    keyValue = emptyToBlank(row.rawValue)
    environment = normalizedAPIKeyEnvironment(row.environment)
    note = emptyToBlank(row.note)
  }

  var formValues: NexusAPIKeyFormValues {
    NexusAPIKeyFormValues(
      keyName: keyName,
      keyValue: keyValue,
      environment: environment,
      note: note
    )
  }
}

struct NexusCardFormValues: Encodable {
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  let cardName: String
  let network: String
  let creditCurrency: String
  let cardNumber: String
  let creditLimit: String
  let expiry: String
  let cvv: String
  let pin: String
  let nextBillingDate: String
  let note: String
}

struct NexusCardDraft: Hashable {
  var id: String
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  var cardName: String
  var network: String
  var creditCurrency: String
  var cardNumber: String
  var creditLimit: String
  var expiry: String
  var cvv: String
  var pin: String
  var nextBillingDate: String
  var note: String

  init() {
    id = ""
    iconKey = ""
    iconSource = ""
    resolvedIconKey = ""
    cardName = ""
    network = "VISA"
    creditCurrency = "USD"
    cardNumber = ""
    creditLimit = ""
    expiry = ""
    cvv = ""
    pin = ""
    nextBillingDate = ""
    note = ""
  }

  init(row: NexusCard) {
    id = row.id
    iconKey = emptyToBlank(row.iconKey)
    iconSource = emptyToBlank(row.iconSource)
    resolvedIconKey = firstNonEmpty(row.resolvedIconKey, row.iconKey)
    cardName = emptyToBlank(row.cardName)
    network = normalizedChoice(row.network, fallback: "VISA")
    creditCurrency = normalizedChoice(row.creditCurrency, fallback: "USD")
    cardNumber = emptyToBlank(row.rawCardNumber)
    creditLimit = decimalInputString(row.creditLimit, digits: 2)
    expiry = emptyToBlank(row.expiry)
    cvv = emptyToBlank(row.rawCvv)
    pin = emptyToBlank(row.rawPin)
    nextBillingDate = emptyToBlank(row.billingAnchorDate)
    note = emptyToBlank(row.note)
  }

  var formValues: NexusCardFormValues {
    NexusCardFormValues(
      iconKey: iconKey,
      iconSource: iconSource,
      resolvedIconKey: resolvedIconKey,
      cardName: cardName,
      network: network,
      creditCurrency: creditCurrency,
      cardNumber: cardNumber,
      creditLimit: creditLimit,
      expiry: expiry,
      cvv: cvv,
      pin: pin,
      nextBillingDate: nextBillingDate,
      note: note
    )
  }
}

struct NexusRecurringFormValues: Encodable {
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  let service: String
  let tier: String
  let cadence: String
  let amountCurrency: String
  let amount: String
  let nextBillingDate: String
  let status: String
  let note: String
}

struct NexusRecurringDraft: Hashable {
  let id: String
  let iconKey: String
  let iconSource: String
  let resolvedIconKey: String
  var service: String
  var tier: String
  var cadence: String
  var amountCurrency: String
  var amount: String
  var nextBillingDate: String
  var status: String
  var note: String

  init() {
    id = ""
    iconKey = ""
    iconSource = ""
    resolvedIconKey = ""
    service = ""
    tier = "PAID"
    cadence = "MONTHLY"
    amountCurrency = "USD"
    amount = ""
    nextBillingDate = ""
    status = "ACTIVE"
    note = ""
  }

  init(row: NexusRecurring) {
    id = row.id
    iconKey = clean(row.iconKey)
    iconSource = emptyToBlank(row.iconSource)
    resolvedIconKey = firstNonEmpty(row.resolvedIconKey, row.iconKey)
    service = emptyToBlank(row.service)
    tier = normalizedChoice(row.tier, fallback: "PAID")
    cadence = normalizedChoice(row.cadence, fallback: "MONTHLY")
    amountCurrency = normalizedChoice(row.amountCurrency, fallback: "USD")
    amount = decimalInputString(row.amount, digits: 2)
    nextBillingDate = emptyToBlank(row.billingAnchorDate)
    status = normalizedChoice(row.status, fallback: "ACTIVE")
    note = emptyToBlank(row.note)
  }

  var formValues: NexusRecurringFormValues {
    NexusRecurringFormValues(
      iconKey: iconKey,
      iconSource: iconSource,
      resolvedIconKey: resolvedIconKey,
      service: service,
      tier: tier,
      cadence: cadence,
      amountCurrency: amountCurrency,
      amount: amount,
      nextBillingDate: nextBillingDate,
      status: status,
      note: note
    )
  }
}

struct NexusTableColumn: Identifiable {
  let id: String
  let label: String
  let weight: CGFloat
  let alignment: Alignment

  init(_ id: String, _ label: String, weight: CGFloat, alignment: Alignment = .leading) {
    self.id = id
    self.label = label
    self.weight = weight
    self.alignment = alignment
  }
}

struct NexusVaultSnapshot: Codable, Hashable {
  var passwords: [NexusPassword] = []
  var apiKeys: [NexusAPIKey] = []
  var cards: [NexusCard] = []
  var subscriptions: [NexusRecurring] = []

  var sortedCards: [NexusCard] {
    cards.sorted(by: compareBillingDates)
  }

  var sortedSubscriptions: [NexusRecurring] {
    subscriptions.sorted(by: compareBillingDates)
  }

  var sortedPasswords: [NexusPassword] {
    passwords.sorted(by: comparePasswords)
  }

  var sortedAPIKeys: [NexusAPIKey] {
    apiKeys.sorted(by: compareAPIKeys)
  }

  var passwordMetrics: [NexusMetricItem] {
    let passwordBased = passwords.filter { $0.kinds?.contains("PASSWORD") == true }.count
    let oneTimeCodes = passwords.filter { row in
      row.kinds?.contains { $0 == "2FA" || $0 == "OTP" } == true
    }.count
    return [
      NexusMetricItem(label: "TOTAL ACCOUNTS", value: metricCount(passwords.count)),
      NexusMetricItem(label: "PASSWORD", value: metricCount(passwordBased)),
      NexusMetricItem(label: "ONE-TIME-CODE", value: metricCount(oneTimeCodes))
    ]
  }

  var apiKeyMetrics: [NexusMetricItem] {
    let active = apiKeys.filter { normalizedAPIKeyEnvironment($0.environment) == "ACTIVE" }.count
    let inactive = apiKeys.filter { normalizedAPIKeyEnvironment($0.environment) == "INACTIVE" }.count
    return [
      NexusMetricItem(label: "TOTAL KEYS", value: metricCount(apiKeys.count)),
      NexusMetricItem(label: "ACTIVE", value: metricCount(active)),
      NexusMetricItem(label: "INACTIVE", value: metricCount(inactive))
    ]
  }

  var cardMetrics: [NexusMetricItem] {
    let nextBilling = sortedCards.compactMap { nextCardBillingDate($0) }.first
    return [
      NexusMetricItem(label: "TOTAL CARDS", value: metricCount(cards.count)),
      NexusMetricItem(
        label: "TOTAL CREDIT",
        value: currencyLines(
          cards,
          amount: { isNoCreditNetwork($0.network) ? 0 : $0.creditLimit ?? 0 },
          currency: { $0.creditCurrency ?? "USD" },
          digits: 0
        )
      ),
      NexusMetricItem(label: "NEXT BILLING", value: nextBilling.map(NexusDate.formatShort) ?? "N/A")
    ]
  }

  var subscriptionMetrics: [NexusMetricItem] {
    let billable = subscriptions.filter(isBillableSubscription)
    let activeCount = subscriptions.filter { normalizedRecurringStatus($0.status) == "ACTIVE" }.count
    let nextBilling = sortedSubscriptions.compactMap { nextSubscriptionBillingDate($0) }.first
    return [
      NexusMetricItem(label: "TOTAL ACTIVE", value: metricCount(activeCount)),
      NexusMetricItem(
        label: "MONTHLY BURN",
        value: currencyLines(
          billable,
          amount: { monthlyAmount($0.amount ?? 0, cadence: $0.cadence) },
          currency: { $0.amountCurrency ?? "USD" },
          digits: 2
        )
      ),
      NexusMetricItem(label: "NEXT BILLING", value: nextBilling.map(NexusDate.formatShort) ?? "N/A")
    ]
  }
}

private func clean(_ value: String?) -> String {
  let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
  return normalized.isEmpty ? "-" : normalized
}

private func emptyToBlank(_ value: String?) -> String {
  let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
  return normalized
}

private func normalizedChoice(_ value: String?, fallback: String) -> String {
  let normalized = emptyToBlank(value).uppercased()
  return normalized.isEmpty ? fallback : normalized
}

private func digitsOnly(_ value: String) -> String {
  value.filter(\.isNumber)
}

private func formatExpiryDigits(_ value: String) -> String {
  let digits = String(digitsOnly(value).prefix(4))
  guard digits.count > 2 else { return digits }
  let splitIndex = digits.index(digits.startIndex, offsetBy: 2)
  return "\(digits[..<splitIndex])/\(digits[splitIndex...])"
}

private func formatISODateDigits(_ value: String) -> String {
  let digits = String(digitsOnly(value).prefix(8))
  guard digits.count > 4 else { return digits }
  let yearEnd = digits.index(digits.startIndex, offsetBy: 4)
  guard digits.count > 6 else {
    return "\(digits[..<yearEnd])-\(digits[yearEnd...])"
  }
  let monthEnd = digits.index(yearEnd, offsetBy: 2)
  return "\(digits[..<yearEnd])-\(digits[yearEnd..<monthEnd])-\(digits[monthEnd...])"
}

private func decimalInputString(_ value: Double?, digits: Int) -> String {
  guard let value else { return "" }
  let rounded = value.rounded()
  if abs(value - rounded) < 0.000_001 {
    return String(Int(rounded))
  }
  return String(format: "%.\(digits)f", value)
}

private func metricCount(_ value: Int) -> String {
  String(format: "%02d", max(0, value))
}

private func compareBillingDates(_ left: NexusCard, _ right: NexusCard) -> Bool {
  billingSortStamp(nextCardBillingDate(left)) < billingSortStamp(nextCardBillingDate(right))
}

private func compareBillingDates(_ left: NexusRecurring, _ right: NexusRecurring) -> Bool {
  billingSortStamp(nextSubscriptionBillingDate(left)) < billingSortStamp(nextSubscriptionBillingDate(right))
}

private func comparePasswords(_ left: NexusPassword, _ right: NexusPassword) -> Bool {
  compareTextChain(
    (left.service, right.service),
    (left.username, right.username),
    (left.website, right.website),
    (left.id, right.id)
  )
}

private func compareAPIKeys(_ left: NexusAPIKey, _ right: NexusAPIKey) -> Bool {
  compareTextChain(
    (left.keyName, right.keyName),
    (left.note, right.note),
    (left.id, right.id)
  )
}

private func compareTextChain(_ pairs: (String?, String?)...) -> Bool {
  for pair in pairs {
    let comparison = emptyToBlank(pair.0).localizedStandardCompare(emptyToBlank(pair.1))
    if comparison == .orderedAscending { return true }
    if comparison == .orderedDescending { return false }
  }
  return false
}

private func billingSortStamp(_ date: Date?) -> TimeInterval {
  date?.timeIntervalSince1970 ?? .greatestFiniteMagnitude
}

private func isNoCreditNetwork(_ value: String?) -> Bool {
  let normalized = clean(value).uppercased()
  return normalized == "DEBIT" || normalized == "VIRTUAL"
}

private func cadenceMonths(_ value: String?) -> Int {
  switch clean(value).uppercased() {
  case "QUARTERLY", "QUARTER":
    return 3
  case "YEARLY", "ANNUAL", "ANNUALLY":
    return 12
  case "MONTHLY":
    return 1
  default:
    return 0
  }
}

private func nextCardBillingDate(_ card: NexusCard, now: Date = Date()) -> Date? {
  guard !isNoCreditNetwork(card.network), let anchor = NexusDate.dateOnly(card.billingAnchorDate) else {
    return nil
  }
  return advanceBillingDate(anchorDate: anchor, cadenceMonths: 1, now: now)
}

private func nextSubscriptionBillingDate(_ recurring: NexusRecurring, now: Date = Date()) -> Date? {
  guard normalizedRecurringStatus(recurring.status) != "INACTIVE",
    let anchor = NexusDate.dateOnly(recurring.billingAnchorDate)
  else {
    return nil
  }
  let months = cadenceMonths(recurring.cadence)
  guard months > 0 else { return nil }
  return advanceBillingDate(anchorDate: anchor, cadenceMonths: months, now: now)
}

private func isBillableSubscription(_ recurring: NexusRecurring) -> Bool {
  guard normalizedRecurringStatus(recurring.status) == "ACTIVE" else { return false }
  guard clean(recurring.tier).uppercased() == "FREE TRIAL" else { return true }
  guard let anchor = NexusDate.dateOnly(recurring.billingAnchorDate) else { return false }
  return anchor <= Calendar(identifier: .gregorian).startOfDay(for: Date())
}

private func advanceBillingDate(anchorDate: Date, cadenceMonths: Int, now: Date) -> Date? {
  guard cadenceMonths > 0 else { return nil }
  let calendar = Calendar(identifier: .gregorian)
  let today = calendar.startOfDay(for: now)
  let anchorDay = calendar.component(.day, from: anchorDate)
  var current = calendar.startOfDay(for: anchorDate)
  while current < today {
    guard let next = anchoredDate(after: current, cadenceMonths: cadenceMonths, anchorDay: anchorDay) else {
      return nil
    }
    current = next
  }
  return current
}

private func anchoredDate(after date: Date, cadenceMonths: Int, anchorDay: Int) -> Date? {
  let calendar = Calendar(identifier: .gregorian)
  let monthStartComponents = calendar.dateComponents([.year, .month], from: date)
  guard let monthStart = calendar.date(from: monthStartComponents),
    let nextMonthStart = calendar.date(byAdding: .month, value: cadenceMonths, to: monthStart),
    let dayRange = calendar.range(of: .day, in: .month, for: nextMonthStart)
  else {
    return nil
  }
  var nextComponents = calendar.dateComponents([.year, .month], from: nextMonthStart)
  nextComponents.day = min(anchorDay, dayRange.count)
  return calendar.date(from: nextComponents).map { calendar.startOfDay(for: $0) }
}

private func monthlyAmount(_ amount: Double, cadence: String?) -> Double {
  switch String(cadence ?? "MONTHLY").uppercased() {
  case "YEARLY", "ANNUAL", "ANNUALLY":
    return amount / 12
  case "QUARTERLY", "QUARTER":
    return amount / 3
  default:
    return amount
  }
}

private func currencyLines<Item>(
  _ items: [Item],
  amount: (Item) -> Double,
  currency: (Item) -> String,
  digits: Int
) -> String {
  let totals = Dictionary(grouping: items, by: { NexusCurrency.normalizedCode(currency($0)) }).mapValues { rows in
    rows.reduce(0) { $0 + amount($1) }
  }
  let orderedCodes = NexusCurrency.editorOptions + totals.keys.filter { !NexusCurrency.editorOptions.contains($0) }.sorted()
  let ordered = orderedCodes.compactMap { code -> String? in
    guard let value = totals[code], abs(value) > 0.000_001 else { return nil }
    return NexusCurrency.format(value, currency: code, digits: digits)
  }
  return ordered.isEmpty ? NexusCurrency.format(0, currency: "USD", digits: digits) : ordered.joined(separator: "\n")
}

enum NexusCurrency {
  static let editorOptions = ["USD", "CAD", "CNY"]

  static func format(_ value: Double, currency: String, digits: Int) -> String {
    let code = normalizedCode(currency)
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = digits
    formatter.maximumFractionDigits = digits
    let amount = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    return "\(symbol(for: code))\(amount)"
  }

  static func normalizedCode(_ value: String?) -> String {
    let normalized = String(value ?? "USD").trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if normalized == "JPY" {
      return "CNY"
    }
    return normalized.isEmpty ? "USD" : normalized
  }

  static func symbol(for currency: String) -> String {
    switch normalizedCode(currency) {
    case "USD": return "$"
    case "CAD": return "CA$"
    case "CNY": return "CN¥"
    default: return "\(normalizedCode(currency)) "
    }
  }
}

enum NexusDate {
  static func stamp(_ value: String?) -> TimeInterval {
    guard let date = dateOnly(value) else { return .greatestFiniteMagnitude }
    return date.timeIntervalSince1970
  }

  static func formatShort(_ value: String) -> String {
    guard let date = dateOnly(value) else { return value }
    return formatShort(date)
  }

  static func formatShort(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MMM dd"
    return formatter.string(from: date).uppercased()
  }

  static func formatISO(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: date)
  }

  static func dateOnly(_ value: String?) -> Date? {
    let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    guard !normalized.isEmpty else { return nil }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: normalized)
  }
}

enum NexusHost {
  static func normalize(_ value: String?) -> String {
    let raw = NexusWebsiteList.primary(value).lowercased()
    guard !raw.isEmpty else { return "" }
    let url = URL(string: raw.contains("://") ? raw : "https://\(raw)")
    return removeCommonPrefix(url?.host ?? raw)
  }

  static func all(_ value: String?) -> [String] {
    var seen = Set<String>()
    return NexusWebsiteList.entries(value).map(normalize).filter { host in
      guard !host.isEmpty, !seen.contains(host) else { return false }
      seen.insert(host)
      return true
    }
  }

  private static func removeCommonPrefix(_ value: String) -> String {
    value.hasPrefix("www.") ? String(value.dropFirst(4)) : value
  }
}

enum NexusWebsiteList {
  static let separator = ";"

  static func entries(_ value: String?) -> [String] {
    String(value ?? "")
      .split(separator: Character(separator), omittingEmptySubsequences: true)
      .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
  }

  static func primary(_ value: String?) -> String {
    entries(value).first ?? ""
  }
}

actor NexusAPIClient {
  private let baseURL: URL
  private let decoder = JSONDecoder()

  init(baseURL: URL = NexusEnvironment.baseURL) {
    self.baseURL = baseURL
  }

  func session() async throws -> NexusSession {
    try await request("/api/session", method: "GET", body: Optional<Data>.none)
  }

  func login(email: String, password: String) async throws -> NexusSession {
    let body = try JSONEncoder().encode(["email": email, "password": password])
    let session: NexusSession = try await request("/api/auth/login", method: "POST", body: body)
    if let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return session
  }

  func register(email: String, password: String) async throws -> NexusSession {
    let body = try JSONEncoder().encode(["email": email, "password": password])
    let session: NexusSession = try await request("/api/auth/register", method: "POST", body: body)
    if let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return session
  }

  func logout() async throws {
    let _: NexusSession = try await request("/api/auth/logout", method: "POST", body: Optional<Data>.none)
    try? NexusSecureStore.delete(account: NexusSecureStore.sessionAccount)
    try? NexusCredentialCache.save([])
  }

  func vault() async throws -> NexusVaultSnapshot {
    let passwords: [NexusPassword] = try await items(.passwords)
    let apiKeys: [NexusAPIKey] = try await items(.apiKeys)
    let cards: [NexusCard] = try await items(.cards)
    let subscriptions: [NexusRecurring] = try await items(.subscriptions)
    return NexusVaultSnapshot(
      passwords: passwords,
      apiKeys: apiKeys,
      cards: cards,
      subscriptions: subscriptions
    )
  }

  func updatePassword(_ draft: NexusPasswordDraft) async throws -> NexusPassword {
    let body = try JSONEncoder().encode(
      NexusSaveItemRequest(resourceId: NexusSection.passwords.resourceId, formValues: draft.formValues)
    )
    let payload: NexusItemPayload<NexusPassword> = try await request(
      "/api/nexus/items/\(percentEncodePathComponent(draft.id))",
      method: "PATCH",
      body: body
    )
    return payload.item
  }

  func deletePassword(id: String) async throws {
    let path = "/api/nexus/items/\(percentEncodePathComponent(id))?resource=\(NexusSection.passwords.resourceId)"
    let _: NexusEmptyPayload = try await request(path, method: "DELETE", body: Optional<Data>.none)
  }

  func updateAPIKey(_ draft: NexusAPIKeyDraft) async throws -> NexusAPIKey {
    let body = try JSONEncoder().encode(
      NexusSaveItemRequest(resourceId: NexusSection.apiKeys.resourceId, formValues: draft.formValues)
    )
    let payload: NexusItemPayload<NexusAPIKey> = try await request(
      "/api/nexus/items/\(percentEncodePathComponent(draft.id))",
      method: "PATCH",
      body: body
    )
    return payload.item
  }

  func deleteAPIKey(id: String) async throws {
    let path = "/api/nexus/items/\(percentEncodePathComponent(id))?resource=\(NexusSection.apiKeys.resourceId)"
    let _: NexusEmptyPayload = try await request(path, method: "DELETE", body: Optional<Data>.none)
  }

  func createPassword(_ draft: NexusPasswordDraft) async throws -> NexusPassword {
    let item: NexusPassword = try await createItem(.passwords, formValues: draft.formValues)
    return item
  }

  func createAPIKey(_ draft: NexusAPIKeyDraft) async throws -> NexusAPIKey {
    let item: NexusAPIKey = try await createItem(.apiKeys, formValues: draft.formValues)
    return item
  }

  func createCard(_ draft: NexusCardDraft) async throws -> NexusCard {
    let item: NexusCard = try await createItem(.cards, formValues: draft.formValues)
    return item
  }

  func updateCard(_ draft: NexusCardDraft) async throws -> NexusCard {
    let body = try JSONEncoder().encode(
      NexusSaveItemRequest(resourceId: NexusSection.cards.resourceId, formValues: draft.formValues)
    )
    let payload: NexusItemPayload<NexusCard> = try await request(
      "/api/nexus/items/\(percentEncodePathComponent(draft.id))",
      method: "PATCH",
      body: body
    )
    return payload.item
  }

  func deleteCard(id: String) async throws {
    let path = "/api/nexus/items/\(percentEncodePathComponent(id))?resource=\(NexusSection.cards.resourceId)"
    let _: NexusEmptyPayload = try await request(path, method: "DELETE", body: Optional<Data>.none)
  }

  func updateRecurring(_ draft: NexusRecurringDraft) async throws -> NexusRecurring {
    let body = try JSONEncoder().encode(
      NexusSaveItemRequest(resourceId: NexusSection.subscriptions.resourceId, formValues: draft.formValues)
    )
    let payload: NexusItemPayload<NexusRecurring> = try await request(
      "/api/nexus/items/\(percentEncodePathComponent(draft.id))",
      method: "PATCH",
      body: body
    )
    return payload.item
  }

  func deleteRecurring(id: String) async throws {
    let path = "/api/nexus/items/\(percentEncodePathComponent(id))?resource=\(NexusSection.subscriptions.resourceId)"
    let _: NexusEmptyPayload = try await request(path, method: "DELETE", body: Optional<Data>.none)
  }

  func createRecurring(_ draft: NexusRecurringDraft) async throws -> NexusRecurring {
    let item: NexusRecurring = try await createItem(.subscriptions, formValues: draft.formValues)
    return item
  }

  private func items<Item: Decodable>(_ section: NexusSection) async throws -> [Item] {
    let path = "/api/nexus/items?resource=\(section.resourceId)"
    let payload: NexusItemsPayload<Item> = try await request(path, method: "GET", body: Optional<Data>.none)
    return payload.items
  }

  private func createItem<Item: Decodable, FormValues: Encodable>(
    _ section: NexusSection,
    formValues: FormValues
  ) async throws -> Item {
    let body = try JSONEncoder().encode(
      NexusSaveItemRequest(resourceId: section.resourceId, formValues: formValues)
    )
    let payload: NexusItemPayload<Item> = try await request(
      "/api/nexus/items",
      method: "POST",
      body: body
    )
    return payload.item
  }

  private func request<Value: Decodable>(_ path: String, method: String, body: Data?) async throws -> Value {
    let root = baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    let suffix = path.hasPrefix("/") ? path : "/\(path)"
    guard let url = URL(string: root + suffix) else {
      throw NexusError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = try? NexusSecureStore.readString(account: NexusSecureStore.sessionAccount), !token.isEmpty {
      request.setValue(token, forHTTPHeaderField: "x-session-token")
    }
    request.httpBody = body
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as? HTTPURLResponse else {
      throw NexusError.invalidResponse
    }
    let envelope = try decoder.decode(NexusEnvelope<Value>.self, from: data)
    guard (200..<300).contains(http.statusCode), envelope.ok != false, let value = envelope.data else {
      throw NexusError.requestFailed(envelope.error ?? "Request failed.")
    }
    if let session = value as? NexusSession, let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return value
  }
}

enum NexusError: LocalizedError {
  case invalidURL
  case invalidResponse
  case requestFailed(String)
  case secureStore(OSStatus)
  case locked

  var errorDescription: String? {
    switch self {
    case .invalidURL: return "Invalid URL."
    case .invalidResponse: return "Invalid response."
    case .requestFailed(let message): return message
    case .secureStore(let status): return "Keychain error \(status)."
    case .locked: return "Nexus is locked."
    }
  }
}

enum NexusEnvironment {
  static var baseURL: URL {
    let raw = Bundle.main.object(forInfoDictionaryKey: "NexusBaseURL") as? String
    return URL(string: raw ?? "https://zjz.world/nexus")!
  }

  static var appGroup: String? {
    cleanSetting(Bundle.main.object(forInfoDictionaryKey: "NexusAppGroup") as? String)
  }

  static var keychainAccessGroup: String? {
    cleanSetting(Bundle.main.object(forInfoDictionaryKey: "NexusKeychainAccessGroup") as? String)
  }

  private static func cleanSetting(_ value: String?) -> String? {
    let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    guard !normalized.isEmpty, !normalized.contains("$(") else { return nil }
    return normalized
  }
}

enum NexusSecureStore {
  static let sessionAccount = "session-token"
  static let credentialCacheAccount = "credential-cache"
  private static let service = "one.zjz.nexus"
  private static let missingEntitlementStatus: OSStatus = -34018

  static func saveString(_ value: String, account: String) throws {
    try save(Data(value.utf8), account: account)
  }

  static func readString(account: String) throws -> String? {
    guard let data = try read(account: account) else { return nil }
    return String(data: data, encoding: .utf8)
  }

  static func save(_ data: Data, account: String) throws {
    var lastStatus: OSStatus = errSecSuccess
    for var query in candidateQueries(account: account) {
      SecItemDelete(query as CFDictionary)
      query[kSecValueData as String] = data
      query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      let status = SecItemAdd(query as CFDictionary, nil)
      if status == errSecSuccess { return }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  static func read(account: String) throws -> Data? {
    var lastStatus: OSStatus = errSecSuccess
    for var query in candidateQueries(account: account) {
      query[kSecMatchLimit as String] = kSecMatchLimitOne
      query[kSecReturnData as String] = true
      var item: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &item)
      if status == errSecSuccess { return item as? Data }
      if status == errSecItemNotFound { return nil }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  static func delete(account: String) throws {
    var lastStatus: OSStatus = errSecSuccess
    for query in candidateQueries(account: account) {
      let status = SecItemDelete(query as CFDictionary)
      if status == errSecSuccess || status == errSecItemNotFound { return }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  private static func candidateQueries(account: String) -> [[String: Any]] {
    let scoped = baseQuery(account: account, includeAccessGroup: true)
    let unscoped = baseQuery(account: account, includeAccessGroup: false)
    return scoped.keys.count == unscoped.keys.count ? [unscoped] : [scoped, unscoped]
  }

  private static func baseQuery(account: String, includeAccessGroup: Bool) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]
    if includeAccessGroup, let accessGroup = NexusEnvironment.keychainAccessGroup {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    return query
  }
}

struct NexusCachedCredential: Codable, Identifiable, Hashable {
  let id: String
  let service: String
  let username: String
  let password: String
  let website: String

  var host: String { NexusHost.normalize(website) }
  var hosts: [String] { NexusHost.all(website) }
}

enum NexusCredentialCache {
  static func save(_ credentials: [NexusCachedCredential]) throws {
    let data = try JSONEncoder().encode(credentials)
    try NexusSecureStore.save(data, account: NexusSecureStore.credentialCacheAccount)
  }

  static func load() throws -> [NexusCachedCredential] {
    guard let data = try NexusSecureStore.read(account: NexusSecureStore.credentialCacheAccount) else {
      return []
    }
    return try JSONDecoder().decode([NexusCachedCredential].self, from: data)
  }

  static func credentials(from passwords: [NexusPassword]) -> [NexusCachedCredential] {
    passwords.compactMap { row in
      guard row.kinds?.contains("PASSWORD") == true else { return nil }
      let password = String(row.rawSecret ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
      guard !password.isEmpty else { return nil }
      return NexusCachedCredential(
        id: row.id,
        service: clean(row.service),
        username: clean(row.username),
        password: password,
        website: clean(row.website)
      )
    }
  }

  static func matches(for serviceIdentifiers: [ASCredentialServiceIdentifier]) throws -> [NexusCachedCredential] {
    let requestedHosts = serviceIdentifiers.map { NexusHost.normalize($0.identifier) }.filter { !$0.isEmpty }
    guard !requestedHosts.isEmpty else { return try load() }
    return try load().filter { credential in
      let credentialHosts = credential.hosts
      return requestedHosts.contains { requested in
        credentialHosts.contains { host in
          host == requested || host.hasSuffix(".\(requested)") || requested.hasSuffix(".\(host)")
        }
      }
    }
  }
}

enum NexusCredentialIdentityBridge {
  static func sync(_ credentials: [NexusCachedCredential]) async {
    let identities: [any ASCredentialIdentity] = credentials.flatMap { credential -> [ASPasswordCredentialIdentity] in
      credential.hosts.map { host in
        let service = ASCredentialServiceIdentifier(identifier: host, type: .domain)
        return ASPasswordCredentialIdentity(
          serviceIdentifier: service,
          user: credential.username,
          recordIdentifier: credential.id
        )
      }
    }
    try? await ASCredentialIdentityStore.shared.replaceCredentialIdentities(identities)
  }
}

@MainActor
final class NexusVaultModel: ObservableObject {
  @Published var selectedSection: NexusSection = .passwords
  @Published var snapshot = NexusVaultSnapshot()
  @Published var email = ""
  @Published var password = ""
  @Published var searchText = ""
  @Published var accountEmail = ""
  @Published var isAuthenticated = false
  @Published var isLoading = false
  @Published var errorMessage = ""
  @Published var editingPassword: NexusPassword?
  @Published var editingAPIKey: NexusAPIKey?
  @Published var editingCard: NexusCard?
  @Published var editingRecurring: NexusRecurring?
  @Published var creatingPassword = false
  @Published var creatingAPIKey = false
  @Published var creatingCard = false
  @Published var creatingRecurring = false
  @Published var showingSettings = false

  private let client = NexusAPIClient()

  func bootstrap() {
    Task {
      await loadSession()
    }
  }

  func open(_ section: NexusSection) {
    selectedSection = section
  }

  func filteredSnapshot(for section: NexusSection) -> NexusVaultSnapshot {
    let query = normalizedSearchQuery(searchText)
    guard !query.isEmpty else { return snapshot }
    var filtered = snapshot
    switch section {
    case .passwords:
      filtered.passwords = snapshot.passwords.filter { passwordMatchesSearch($0, query: query) }
    case .apiKeys:
      filtered.apiKeys = snapshot.apiKeys.filter { apiKeyMatchesSearch($0, query: query) }
    case .cards:
      filtered.cards = snapshot.cards.filter { cardMatchesSearch($0, query: query) }
    case .subscriptions:
      filtered.subscriptions = snapshot.subscriptions.filter { recurringMatchesSearch($0, query: query) }
    }
    return filtered
  }

  func editPassword(_ row: NexusPassword) {
    showingSettings = false
    editingPassword = row
    editingAPIKey = nil
    editingCard = nil
    editingRecurring = nil
    creatingPassword = false
    creatingAPIKey = false
    creatingCard = false
    creatingRecurring = false
  }

  func dismissPasswordEditor() {
    dismissEditor()
  }

  func editCard(_ row: NexusCard) {
    showingSettings = false
    editingPassword = nil
    editingAPIKey = nil
    editingCard = row
    editingRecurring = nil
    creatingPassword = false
    creatingAPIKey = false
    creatingCard = false
    creatingRecurring = false
  }

  func editAPIKey(_ row: NexusAPIKey) {
    showingSettings = false
    editingPassword = nil
    editingAPIKey = row
    editingCard = nil
    editingRecurring = nil
    creatingPassword = false
    creatingAPIKey = false
    creatingCard = false
    creatingRecurring = false
  }

  func editRecurring(_ row: NexusRecurring) {
    showingSettings = false
    editingPassword = nil
    editingAPIKey = nil
    editingCard = nil
    editingRecurring = row
    creatingPassword = false
    creatingAPIKey = false
    creatingCard = false
    creatingRecurring = false
  }

  func createEntry() {
    showingSettings = false
    editingPassword = nil
    editingAPIKey = nil
    editingCard = nil
    editingRecurring = nil
    creatingPassword = selectedSection == .passwords
    creatingAPIKey = selectedSection == .apiKeys
    creatingCard = selectedSection == .cards
    creatingRecurring = selectedSection == .subscriptions
  }

  func dismissEditor() {
    editingPassword = nil
    editingAPIKey = nil
    editingCard = nil
    editingRecurring = nil
    creatingPassword = false
    creatingAPIKey = false
    creatingCard = false
    creatingRecurring = false
  }

  func openSettings() {
    dismissEditor()
    showingSettings = true
  }

  func dismissSettings() {
    showingSettings = false
  }

  func loadSession() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let session = try await client.session()
      isAuthenticated = session.authenticated
      accountEmail = session.email
      if session.authenticated {
        try await refresh()
      }
    } catch {
      isAuthenticated = false
      errorMessage = error.localizedDescription
    }
  }

  func login() {
    Task {
      await authenticate(mode: .login)
    }
  }

  func createAccount() {
    Task {
      await authenticate(mode: .create)
    }
  }

  func refreshAction() {
    Task {
      try? await refresh()
    }
  }

  func logout() {
    Task {
      do {
        try await client.logout()
        snapshot = NexusVaultSnapshot()
        isAuthenticated = false
        accountEmail = ""
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  func createPassword(_ draft: NexusPasswordDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.createPassword(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func savePassword(_ draft: NexusPasswordDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.updatePassword(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func deletePassword(_ id: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await client.deletePassword(id: id)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func createAPIKey(_ draft: NexusAPIKeyDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.createAPIKey(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func saveAPIKey(_ draft: NexusAPIKeyDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.updateAPIKey(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func deleteAPIKey(_ id: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await client.deleteAPIKey(id: id)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func createCard(_ draft: NexusCardDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.createCard(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func saveCard(_ draft: NexusCardDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.updateCard(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func deleteCard(_ id: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await client.deleteCard(id: id)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func createRecurring(_ draft: NexusRecurringDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.createRecurring(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func saveRecurring(_ draft: NexusRecurringDraft) async {
    isLoading = true
    defer { isLoading = false }
    do {
      _ = try await client.updateRecurring(draft)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func deleteRecurring(_ id: String) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await client.deleteRecurring(id: id)
      dismissEditor()
      try await refresh()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  private func authenticate(mode: NexusAuthMode) async {
    isLoading = true
    defer { isLoading = false }
    do {
      let session = switch mode {
      case .login:
        try await client.login(email: email, password: password)
      case .create:
        try await client.register(email: email, password: password)
      }
      guard session.authenticated else {
        throw NexusError.requestFailed("Authentication failed.")
      }
      accountEmail = session.email
      isAuthenticated = session.authenticated
      password = ""
      do {
        try await refresh()
      } catch {
        errorMessage = error.localizedDescription
      }
    } catch {
      isAuthenticated = false
      errorMessage = error.localizedDescription
    }
  }

  private func refresh() async throws {
    let nextSnapshot = try await client.vault()
    snapshot = nextSnapshot
    let iconURLs = nexusIconURLs(from: nextSnapshot)
    Task(priority: .utility) {
      await NexusIconCache.shared.prefetch(iconURLs)
    }
    let credentials = NexusCredentialCache.credentials(from: nextSnapshot.passwords)
    try? NexusCredentialCache.save(credentials)
    await NexusCredentialIdentityBridge.sync(credentials)
  }
}

private enum NexusAuthMode {
  case login
  case create
}

struct NexusRootView: View {
  @StateObject private var model = NexusVaultModel()

  var body: some View {
    ZStack {
      Group {
        if model.isAuthenticated {
          NexusVaultView()
            .environmentObject(model)
        } else {
          NexusLoginView()
            .environmentObject(model)
        }
      }
      if let editingPassword = model.editingPassword {
        NexusPasswordEditorOverlay(row: editingPassword)
          .environmentObject(model)
          .transition(.opacity)
      }
      if model.creatingPassword {
        NexusPasswordEditorOverlay()
          .environmentObject(model)
          .transition(.opacity)
      }
      if let editingAPIKey = model.editingAPIKey {
        NexusAPIKeyEditorOverlay(row: editingAPIKey)
          .environmentObject(model)
          .transition(.opacity)
      }
      if model.creatingAPIKey {
        NexusAPIKeyEditorOverlay()
          .environmentObject(model)
          .transition(.opacity)
      }
      if let editingCard = model.editingCard {
        NexusCardEditorOverlay(row: editingCard)
          .environmentObject(model)
          .transition(.opacity)
      }
      if model.creatingCard {
        NexusCardEditorOverlay()
          .environmentObject(model)
          .transition(.opacity)
      }
      if let editingRecurring = model.editingRecurring {
        NexusRecurringEditorOverlay(row: editingRecurring)
          .environmentObject(model)
          .transition(.opacity)
      }
      if model.creatingRecurring {
        NexusRecurringEditorOverlay()
          .environmentObject(model)
          .transition(.opacity)
      }
      if model.showingSettings {
        NexusSettingsOverlay()
          .environmentObject(model)
          .transition(.opacity)
      }
    }
    .task {
      model.bootstrap()
      if let section = NexusRouteStore.consumePendingSection() {
        model.open(section)
      }
    }
    .onOpenURL { url in
      if let section = NexusRouteStore.section(from: url) {
        model.open(section)
      }
    }
  }
}

struct NexusLoginView: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    GeometryReader { proxy in
      let contentWidth = max(0, proxy.size.width - (NexusTokens.gutter * 2))
      let fieldWidth = min(contentWidth, NexusTokens.loggedOutFieldWidth)
      let brandSize = min(
        NexusTokens.loggedOutBrandMax,
        max(NexusTokens.loggedOutBrandMin, proxy.size.width * NexusTokens.loggedOutBrandScale)
      )
      VStack(spacing: NexusTokens.gutter) {
        NexusWordmark(size: brandSize)
        VStack(spacing: NexusTokens.gutter) {
          NexusLoggedOutField("Username", text: $model.email, width: fieldWidth)
          NexusLoggedOutSecureField("Password", text: $model.password, width: fieldWidth)
        }
        HStack(spacing: NexusTokens.loggedOutActionGap) {
          NexusButton("SIGN IN", variant: .primary, width: NexusTokens.loggedOutSignInWidth) { model.login() }
          NexusButton("CREATE", variant: .secondary, width: NexusTokens.loggedOutCreateWidth) { model.createAccount() }
        }
        if !model.errorMessage.isEmpty {
          Text(model.errorMessage)
            .font(NexusTokens.inputFont)
            .foregroundStyle(NexusTokens.muted)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(NexusTokens.gutter)
      .offset(y: NexusTokens.loggedOutContentOffsetY)
    }
    .background(NexusBlueprintBackground())
  }
}

struct NexusWordmark: View {
  let size: CGFloat

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: size * NexusTokens.loggedOutBrandTracking) {
      ForEach(Array("Nexus").map(String.init), id: \.self) { character in
        Text(character)
          .font(NexusFont.semibold(size))
          .fixedSize(horizontal: true, vertical: false)
      }
    }
    .padding(.horizontal, abs(size * NexusTokens.loggedOutBrandTracking) * 2)
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct NexusVaultView: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    GeometryReader { proxy in
      #if os(iOS)
      VStack(spacing: 0) {
        NexusMobileTopBar(showAccount: false)
        NexusMobileNavSupplement()
        NexusSectionView(section: model.selectedSection, compact: true)
          .environmentObject(model)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        NexusBottomTabBar()
          .padding(.horizontal, NexusTokens.bottomTabHorizontalPadding)
          .padding(.bottom, NexusTokens.bottomTabGlassBottomPadding)
      }
      #else
      if proxy.size.width <= 960 {
        VStack(spacing: 0) {
          NexusMobileTopBar()
          NexusMobileNav()
          NexusMobileNavSupplement()
          NexusSectionView(section: model.selectedSection, compact: true)
            .environmentObject(model)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      } else {
        HStack(spacing: 0) {
          NexusSidebar()
          NexusSectionView(section: model.selectedSection, compact: false)
            .environmentObject(model)
        }
      }
      #endif
    }
    .background(NexusBlueprintBackground())
  }
}

struct NexusSectionView: View {
  @EnvironmentObject private var model: NexusVaultModel
  let section: NexusSection
  let compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if hasFixedMetrics {
        pageMetrics
          .padding(.top, topPadding)
          .padding(.horizontal, horizontalPadding)
          .padding(.bottom, metricsBottomGap)
      }
      ScrollView(.vertical, showsIndicators: false) {
        pageContent
          .padding(.top, hasFixedMetrics ? 0 : topPadding)
          .padding(.horizontal, horizontalPadding)
          .padding(.bottom, bottomPadding)
      }
    }
    .background(Color.clear)
  }

  @ViewBuilder
  private var pageMetrics: some View {
    switch section {
    case .passwords:
      if compact {
        NexusCompactPasswordsMetricStrip(metrics: model.snapshot.passwordMetrics)
      } else {
        NexusPasswordsMetricStrip(metrics: model.snapshot.passwordMetrics, compact: compact)
      }
    case .apiKeys:
      EmptyView()
    case .cards:
      HStack {
        Spacer(minLength: 0)
        NexusMetricStrip(metrics: model.snapshot.cardMetrics, compact: compact)
      }
    case .subscriptions:
      NexusMetricStrip(metrics: model.snapshot.subscriptionMetrics, compact: compact, subscriptions: true)
    }
  }

  @ViewBuilder
  private var pageContent: some View {
    let filteredSnapshot = model.filteredSnapshot(for: section)
    switch section {
    case .passwords:
      NexusPasswordsPage(snapshot: filteredSnapshot, compact: compact)
    case .apiKeys:
      NexusAPIKeysPage(snapshot: filteredSnapshot, compact: compact)
    case .cards:
      NexusCardsPage(snapshot: filteredSnapshot, compact: compact)
    case .subscriptions:
      NexusRecurringsPage(snapshot: filteredSnapshot, compact: compact)
    }
  }

  private var hasFixedMetrics: Bool {
    !compact && section != .apiKeys
  }

  private var metricsBottomGap: CGFloat {
    switch section {
    case .passwords:
      return compact ? NexusTokens.compactPasswordSectionGap : NexusTokens.pageSectionGap
    case .cards:
      return NexusTokens.pageSectionGap
    case .subscriptions:
      return NexusTokens.pageSectionGap + NexusTokens.subscriptionsRowGap / 2
    case .apiKeys:
      return 0
    }
  }

  private var topPadding: CGFloat {
    guard !compact else { return NexusTokens.pageMobileTopPadding }
    switch section {
    case .passwords, .subscriptions:
      return NexusTokens.passwordsDesktopTopPadding
    case .apiKeys:
      return NexusTokens.apiKeysDesktopTopPadding
    case .cards:
      return NexusTokens.defaultDesktopTopPadding
    }
  }

  private var horizontalPadding: CGFloat {
    return compact ? NexusTokens.pageMobileHorizontalPadding : NexusTokens.pageDesktopHorizontalPadding
  }

  private var bottomPadding: CGFloat {
    compact ? NexusTokens.pageMobileBottomPadding : NexusTokens.pageDesktopBottomPadding
  }
}

private enum NexusTableColumns {
  static let passwords = [
    NexusTableColumn("service", "Service", weight: 17.864078),
    NexusTableColumn("username", "Username", weight: 16.504854),
    NexusTableColumn("type", "Type", weight: 14.563107),
    NexusTableColumn("password", "Password", weight: 14.563107),
    NexusTableColumn("website", "Website", weight: 17.11165),
    NexusTableColumn("note", "Note", weight: 17.451456),
    NexusTableColumn("actions", "", weight: 1.941748, alignment: .trailing)
  ]

  static let apiKeys = [
    NexusTableColumn("name", "Name", weight: 28),
    NexusTableColumn("value", "Value", weight: 38),
    NexusTableColumn("status", "Status", weight: 12),
    NexusTableColumn("note", "Note", weight: 20),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]

  static let cards = [
    NexusTableColumn("name", "Card Name", weight: 17.5),
    NexusTableColumn("network", "Type", weight: 10),
    NexusTableColumn("number", "Card Number", weight: 17.5),
    NexusTableColumn("credit", "Credit", weight: 12.5),
    NexusTableColumn("expiry", "Expiry", weight: 10),
    NexusTableColumn("cvv", "CVV", weight: 7.5),
    NexusTableColumn("nextBilling", "Next Billing", weight: 10),
    NexusTableColumn("note", "Note", weight: 13),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]

  static let subscriptions = [
    NexusTableColumn("service", "Service", weight: 22.7136),
    NexusTableColumn("tier", "Tier", weight: 12.177024),
    NexusTableColumn("cadence", "Cadence", weight: 12.177024),
    NexusTableColumn("amount", "Amount", weight: 12.177024),
    NexusTableColumn("nextBilling", "Next Billing", weight: 10.047024),
    NexusTableColumn("status", "Status", weight: 12.177024),
    NexusTableColumn("note", "Note", weight: 16.53168),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]
}

struct NexusPasswordsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    if compact {
      NexusCompactPasswordsPage(snapshot: snapshot)
    } else {
      NexusTableShell(
        columns: NexusTableColumns.passwords,
        minWidth: NexusTokens.passwordsTableMinWidth,
        variant: .passwords,
        rowCount: snapshot.passwords.count
      ) {
        ForEach(snapshot.sortedPasswords) { row in
          NexusPasswordTableRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactPasswordsPage: View {
  let snapshot: NexusVaultSnapshot

  var body: some View {
    LazyVStack(spacing: NexusTokens.compactPasswordRowGap) {
      if snapshot.sortedPasswords.isEmpty {
        NexusCompactEmptyPasswordRow()
      } else {
        ForEach(snapshot.sortedPasswords) { row in
          NexusCompactPasswordRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactPasswordsMetricStrip: View {
  let metrics: [NexusMetricItem]

  var body: some View {
    GeometryReader { proxy in
      let columnWidth = max(proxy.size.width / 3, 0)
      HStack(alignment: .top, spacing: 0) {
        ForEach(metrics.prefix(3)) { metric in
          NexusCompactMetricCell(metric: metric)
            .frame(width: columnWidth, height: NexusTokens.compactPasswordMetricHeight, alignment: .topLeading)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: NexusTokens.compactPasswordMetricHeight)
    .padding(.vertical, NexusTokens.metricValueVerticalPadding)
    .padding(.trailing, NexusTokens.metricValueBleedPadding)
  }
}

struct NexusCompactMetricCell: View {
  let metric: NexusMetricItem

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.compactPasswordMetricStackGap) {
      HStack(spacing: NexusTokens.tableCellGap) {
        Rectangle()
          .fill(NexusTokens.strong)
          .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
        Text(compactPasswordMetricLabel(metric.label))
          .font(NexusTokens.compactPasswordMetricLabelFont)
          .tracking(NexusTokens.compactPasswordMetricLabelTracking)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .minimumScaleFactor(0.6)
      }
      .frame(height: NexusTokens.compactPasswordMetricLabelHeight, alignment: .bottomLeading)

      Text(metric.value)
        .font(compactMetricValueFont(metric.value))
        .lineSpacing(NexusTokens.compactPasswordMetricValueLineSpacing)
        .lineLimit(metricLineCount(metric.value))
        .minimumScaleFactor(0.55)
        .allowsTightening(true)
        .foregroundStyle(NexusTokens.strong)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .accessibilityElement(children: .combine)
  }
}

struct NexusCompactEmptyPasswordRow: View {
  var body: some View {
    Text("NO MATCHES")
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .foregroundStyle(NexusTokens.muted)
      .frame(maxWidth: .infinity, minHeight: NexusTokens.compactPasswordRowMinHeight)
      .background(NexusTokens.passwordPanel)
  }
}

struct NexusCompactPasswordRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusPassword

  var body: some View {
    HStack(alignment: .center, spacing: NexusTokens.tableCellGap) {
      NexusIconTile(
        urlString: row.resolvedIconUrl,
        iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
        website: row.website,
        fallback: monogram(row.service, row.website, row.username, fallback: "S"),
        defaultSection: .passwords
      )
      .frame(width: NexusTokens.compactPasswordRowIconSize, height: NexusTokens.compactPasswordRowIconSize)

      VStack(alignment: .leading, spacing: NexusTokens.compactPasswordRowBodyGap) {
        NexusCompactPasswordMetaLine(row: row)
        HStack(alignment: .center, spacing: NexusTokens.compactPasswordRowInlineGap) {
          Text(compactPasswordUsername(row.username))
            .font(NexusTokens.compactPasswordRowUsernameFont)
            .tracking(-0.55)
            .foregroundStyle(NexusTokens.strong)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(height: NexusTokens.compactResourceDetailLineHeight, alignment: .center)
          Spacer(minLength: NexusTokens.tableCellGap)
          Text(compactPasswordMask(row))
            .font(NexusTokens.compactPasswordRowMaskFont)
            .tracking(NexusTokens.compactPasswordRowMaskTracking)
            .foregroundStyle(NexusTokens.strong)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(height: NexusTokens.compactResourceDetailLineHeight, alignment: .center)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        model.editPassword(row)
      } label: {
        NexusVerticalDots()
      }
      .buttonStyle(.plain)
      .frame(width: NexusTokens.compactPasswordRowActionWidth, height: NexusTokens.compactPasswordRowMinHeight)
      .contentShape(Rectangle())
      .accessibilityLabel("Edit password")
    }
    .padding(.horizontal, NexusTokens.compactPasswordRowPaddingInline)
    .padding(.vertical, NexusTokens.compactPasswordRowPaddingBlock)
    .frame(maxWidth: .infinity, minHeight: NexusTokens.compactPasswordRowMinHeight, alignment: .leading)
    .background(NexusTokens.passwordPanel)
  }
}

struct NexusCompactPasswordMetaLine: View {
  @Environment(\.openURL) private var openURL
  let row: NexusPassword

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let contentWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let serviceWidth = contentWidth * NexusTokens.compactPasswordRowServiceRatio
      let websiteWidth = contentWidth - serviceWidth

      HStack(spacing: 0) {
        Text(compactPasswordService(row.service))
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(width: serviceWidth, alignment: .leading)
        Text("|")
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .frame(width: separatorWidth)
        compactWebsiteView
          .frame(width: websiteWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactPasswordRowMetaHeight)
  }

  @ViewBuilder
  private var compactWebsiteView: some View {
    if let url = externalWebsiteURL(row.website) {
      Button {
        openURL(url)
      } label: {
        Text(compactPasswordWebsite(row.website))
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      .buttonStyle(.plain)
      .accessibilityLabel("Open website")
    } else {
      Text(compactPasswordWebsite(row.website))
        .font(NexusTokens.compactPasswordRowMetaFont)
        .foregroundStyle(NexusTokens.muted)
        .lineLimit(1)
        .truncationMode(.tail)
    }
  }
}

struct NexusVerticalDots: View {
  var body: some View {
    VStack(spacing: NexusTokens.compactPasswordRowActionDotGap) {
      ForEach(0..<3, id: \.self) { _ in
        Circle()
          .fill(NexusTokens.strong)
          .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct NexusAPIKeysPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    if compact {
      NexusCompactAPIKeysPage(snapshot: snapshot)
    } else {
      NexusTableShell(
        columns: NexusTableColumns.apiKeys,
        minWidth: NexusTokens.apiKeysTableMinWidth,
        variant: .apiKeys,
        rowCount: snapshot.apiKeys.count
      ) {
        ForEach(snapshot.sortedAPIKeys) { row in
          NexusAPIKeyTableRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactAPIKeysPage: View {
  let snapshot: NexusVaultSnapshot

  var body: some View {
    LazyVStack(spacing: NexusTokens.compactPasswordRowGap) {
      if snapshot.sortedAPIKeys.isEmpty {
        NexusCompactEmptyPasswordRow()
      } else {
        ForEach(snapshot.sortedAPIKeys) { row in
          NexusCompactAPIKeyRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactAPIKeyRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusAPIKey

  var body: some View {
    HStack(alignment: .center, spacing: NexusTokens.compactPasswordRowInlineGap) {
      VStack(alignment: .leading, spacing: NexusTokens.compactPasswordRowBodyGap) {
        NexusCompactAPIKeyTopLine(row: row)
        Text(compactAPIKeyValue(row))
          .font(NexusTokens.compactAPIKeyRowValueFont)
          .tracking(NexusTokens.compactAPIKeyRowValueTracking)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .truncationMode(.middle)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        model.editAPIKey(row)
      } label: {
        NexusVerticalDots()
      }
      .buttonStyle(.plain)
      .frame(width: NexusTokens.compactPasswordRowActionWidth, height: NexusTokens.compactAPIKeyRowMinHeight)
      .contentShape(Rectangle())
      .accessibilityLabel("Edit API key")
    }
    .padding(.horizontal, NexusTokens.compactPasswordRowPaddingInline)
    .padding(.vertical, NexusTokens.compactPasswordRowPaddingBlock)
    .frame(maxWidth: .infinity, minHeight: NexusTokens.compactAPIKeyRowMinHeight, alignment: .leading)
    .background(NexusTokens.panel)
  }
}

struct NexusCompactAPIKeyTopLine: View {
  let row: NexusAPIKey

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let availableWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let nameWidth = availableWidth * NexusTokens.compactAPIKeyNameRatio
      let statusWidth = availableWidth - nameWidth

      HStack(spacing: 0) {
        Text(compactAPIKeyName(row))
          .font(NexusTokens.compactAPIKeyRowNameFont)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(width: nameWidth, alignment: .leading)
        Text("|")
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .frame(width: separatorWidth)
        NexusChip(label: compactAPIKeyStatus(row), style: apiKeyStatusChipStyle(row.environment))
          .frame(width: statusWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactResourceTagLineHeight)
  }
}

struct NexusCardsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    if compact {
      NexusCompactCardsPage(snapshot: snapshot)
    } else {
      NexusTableShell(
        columns: NexusTableColumns.cards,
        minWidth: NexusTokens.cardsTableMinWidth,
        variant: .cards,
        rowCount: snapshot.sortedCards.count
      ) {
        ForEach(snapshot.sortedCards) { row in
          NexusCardTableRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactCardsPage: View {
  let snapshot: NexusVaultSnapshot

  var body: some View {
    LazyVStack(spacing: NexusTokens.compactPasswordRowGap) {
      if snapshot.sortedCards.isEmpty {
        NexusCompactEmptyPasswordRow()
      } else {
        ForEach(snapshot.sortedCards) { row in
          NexusCompactCardRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactCardRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusCard

  var body: some View {
    HStack(alignment: .center, spacing: NexusTokens.compactResourceRowSideGap) {
      NexusIconTile(
        urlString: row.resolvedIconUrl,
        iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
        website: nil,
        fallback: monogram(row.cardName, row.network, fallback: "C"),
        size: NexusTokens.compactResourceRowIconSize,
        defaultSection: .cards
      )

      VStack(alignment: .leading, spacing: NexusTokens.compactPasswordRowBodyGap) {
        NexusCompactCardTopLine(row: row)
        NexusCompactCardDetailLine(row: row)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        model.editCard(row)
      } label: {
        NexusVerticalDots()
      }
      .buttonStyle(.plain)
      .frame(width: NexusTokens.compactPasswordRowActionWidth, height: NexusTokens.compactResourceRowMinHeight)
      .contentShape(Rectangle())
      .accessibilityLabel("Edit card")
    }
    .padding(.horizontal, NexusTokens.compactPasswordRowPaddingInline)
    .padding(.vertical, NexusTokens.compactPasswordRowPaddingBlock)
    .frame(maxWidth: .infinity, minHeight: NexusTokens.compactResourceRowMinHeight, alignment: .leading)
    .background(NexusTokens.cardPanel)
  }
}

struct NexusCompactCardTopLine: View {
  let row: NexusCard

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let availableWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let nameWidth = availableWidth * NexusTokens.compactCardNameRatio
      let chipWidth = availableWidth - nameWidth

      HStack(spacing: 0) {
        Text(compactCardName(row))
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(width: nameWidth, alignment: .leading)
        Text("|")
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .frame(width: separatorWidth)
        NexusChip(label: compactCardNetwork(row), style: compactCardNetworkStyle(row))
          .frame(width: chipWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactResourceTagLineHeight)
  }
}

struct NexusCompactCardDetailLine: View {
  let row: NexusCard

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let availableWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let nameWidth = availableWidth * NexusTokens.compactCardNameRatio
      let numberWidth = nameWidth + separatorWidth
      let detailWidth = max(proxy.size.width - numberWidth, CGFloat.zero)
      let expiryWidth = detailWidth * NexusTokens.compactCardDetailExpiryRatio
      let securityWidth = detailWidth - expiryWidth

      HStack(alignment: .firstTextBaseline, spacing: 0) {
        Text(compactCardNumber(row))
          .font(NexusTokens.compactPasswordRowUsernameFont)
          .tracking(-0.55)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .truncationMode(.middle)
          .frame(width: numberWidth, alignment: .leading)
        Text(compactCardExpiry(row))
          .font(NexusTokens.compactResourceRowRightDetailFont)
          .tracking(-0.2)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .frame(width: expiryWidth, alignment: .leading)
        Text(compactCardSecurity(row))
          .font(NexusTokens.compactResourceRowRightDetailFont)
          .tracking(NexusTokens.compactPasswordRowMaskTracking)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .blur(radius: 2)
          .padding(.leading, NexusTokens.compactCardSecurityLeadingInset)
          .frame(width: securityWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactResourceDetailLineHeight)
  }
}

struct NexusRecurringsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    if compact {
      NexusCompactRecurringsPage(snapshot: snapshot)
    } else {
      NexusSubscriptionsBoard(rows: snapshot.sortedSubscriptions)
    }
  }
}

struct NexusCompactRecurringsPage: View {
  let snapshot: NexusVaultSnapshot

  var body: some View {
    LazyVStack(spacing: NexusTokens.compactPasswordRowGap) {
      if snapshot.sortedSubscriptions.isEmpty {
        NexusCompactEmptyPasswordRow()
      } else {
        ForEach(snapshot.sortedSubscriptions) { row in
          NexusCompactRecurringRow(row: row)
        }
      }
    }
  }
}

struct NexusCompactRecurringRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusRecurring

  var body: some View {
    HStack(alignment: .center, spacing: NexusTokens.compactResourceRowSideGap) {
      NexusIconTile(
        urlString: row.resolvedIconUrl,
        iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
        website: nil,
        fallback: monogram(row.service, row.tier, fallback: "R"),
        size: NexusTokens.compactResourceRowIconSize,
        defaultSection: .subscriptions
      )

      VStack(alignment: .leading, spacing: NexusTokens.compactPasswordRowBodyGap) {
        NexusCompactRecurringTopLine(row: row)
        NexusCompactRecurringDetailLine(row: row)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        model.editRecurring(row)
      } label: {
        NexusVerticalDots()
      }
      .buttonStyle(.plain)
      .frame(width: NexusTokens.compactPasswordRowActionWidth, height: NexusTokens.compactResourceRowMinHeight)
      .contentShape(Rectangle())
      .accessibilityLabel("Edit recurring")
    }
    .padding(.horizontal, NexusTokens.compactPasswordRowPaddingInline)
    .padding(.vertical, NexusTokens.compactPasswordRowPaddingBlock)
    .frame(maxWidth: .infinity, minHeight: NexusTokens.compactResourceRowMinHeight, alignment: .leading)
    .background(Color.white.opacity(0.84))
  }
}

struct NexusCompactRecurringTopLine: View {
  let row: NexusRecurring

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let contentWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let serviceWidth = contentWidth * NexusTokens.compactRecurringNameRatio
      let tierWidth = contentWidth * NexusTokens.compactRecurringTierRatio
      let cadenceWidth = contentWidth * NexusTokens.compactRecurringCadenceRatio

      HStack(spacing: 0) {
        Text(compactRecurringService(row))
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(width: serviceWidth, alignment: .leading)
        Text("|")
          .font(NexusTokens.compactPasswordRowMetaFont)
          .foregroundStyle(NexusTokens.muted)
          .frame(width: separatorWidth)
        NexusChip(label: compactRecurringTier(row), style: compactRecurringTierStyle(row))
          .frame(width: tierWidth, alignment: .leading)
        NexusChip(label: compactRecurringCadence(row), style: .normal)
          .frame(width: cadenceWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactResourceTagLineHeight)
  }
}

struct NexusCompactRecurringDetailLine: View {
  let row: NexusRecurring

  var body: some View {
    GeometryReader { proxy in
      let separatorWidth = NexusTokens.compactPasswordRowSeparatorWidth
      let contentWidth = max(proxy.size.width - separatorWidth, CGFloat.zero)
      let serviceWidth = contentWidth * NexusTokens.compactRecurringNameRatio
      let tierWidth = contentWidth * NexusTokens.compactRecurringTierRatio
      let cadenceWidth = contentWidth * NexusTokens.compactRecurringCadenceRatio
      let amountWidth = serviceWidth + separatorWidth

      HStack(alignment: .firstTextBaseline, spacing: 0) {
        Text(compactRecurringAmount(row))
          .font(NexusTokens.compactPasswordRowUsernameFont)
          .tracking(-0.55)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .frame(width: amountWidth, alignment: .leading)
        Text(compactRecurringNextBilling(row))
          .font(NexusTokens.compactResourceRowRightDetailFont)
          .tracking(-0.55)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .frame(width: tierWidth, alignment: .leading)
        NexusChip(label: compactRecurringStatus(row), style: recurringStatusChipStyle(row.status))
          .frame(width: cadenceWidth, alignment: .leading)
      }
    }
    .frame(height: NexusTokens.compactResourceDetailLineHeight)
  }
}

struct NexusPasswordEditorOverlay: View {
  @EnvironmentObject private var model: NexusVaultModel
  @State private var draft: NexusPasswordDraft
  @State private var confirmsDelete = false
  let row: NexusPassword?
  let isCreating: Bool

  init(row: NexusPassword) {
    self.row = row
    self.isCreating = false
    _draft = State(initialValue: NexusPasswordDraft(row: row))
  }

  init() {
    self.row = nil
    self.isCreating = true
    _draft = State(initialValue: NexusPasswordDraft())
  }

  var body: some View {
    NexusEditorOverlayShell(
      title: isCreating ? "Add Password" : "Edit Password",
      onClose: { model.dismissEditor() },
      onDelete: isCreating ? nil : { confirmsDelete = true },
      onSave: { Task { isCreating ? await model.createPassword(draft) : await model.savePassword(draft) } }
    ) { formWidth in
      NexusEditorResourceTitleRow(
        section: .passwords,
        placeholder: "Title",
        text: $draft.serviceName,
        width: formWidth,
        urlString: row?.resolvedIconUrl,
        iconKey: firstNonEmpty(draft.resolvedIconKey, draft.iconKey),
        website: draft.website,
        fallback: "P"
      )
      NexusEditorSectionHeader("LOGIN DETAILS")
      NexusEditorTextField("Username", text: $draft.userName, width: formWidth)
      NexusEditorCredentialModePicker(value: $draft.credentialMode, width: formWidth)
      if draft.credentialMode == "PASSWORD" {
        NexusEditorSecureTextField("Password", text: $draft.secretValue, width: formWidth)
        NexusEditorPasswordGeneratorRow(password: $draft.secretValue, width: formWidth)
      }
      NexusEditorSectionHeader("WEBSITES AND APPS")
      NexusEditorTextField("Web Address", text: $draft.website, width: formWidth)
      NexusEditorSectionHeader("OTHER")
      NexusEditorTextArea("Note", text: $draft.note, width: formWidth)
    }
    .confirmationDialog("", isPresented: $confirmsDelete) {
      Button("DELETE", role: .destructive) {
        if let row {
          Task { await model.deletePassword(row.id) }
        }
      }
    }
  }
}

struct NexusAPIKeyEditorOverlay: View {
  @EnvironmentObject private var model: NexusVaultModel
  @State private var draft: NexusAPIKeyDraft
  @State private var confirmsDelete = false
  let row: NexusAPIKey?
  let isCreating: Bool

  init(row: NexusAPIKey) {
    self.row = row
    self.isCreating = false
    _draft = State(initialValue: NexusAPIKeyDraft(row: row))
  }

  init() {
    self.row = nil
    self.isCreating = true
    _draft = State(initialValue: NexusAPIKeyDraft())
  }

  var body: some View {
    NexusEditorOverlayShell(
      title: isCreating ? "Add Key" : "Edit Key",
      onClose: { model.dismissEditor() },
      onDelete: isCreating ? nil : { confirmsDelete = true },
      onSave: { Task { isCreating ? await model.createAPIKey(draft) : await model.saveAPIKey(draft) } }
    ) { formWidth in
      NexusEditorTextField("Title", text: $draft.keyName, width: formWidth)
      NexusEditorSectionHeader("KEY DETAILS")
      NexusEditorSecureTextField("Key Value", text: $draft.keyValue, width: formWidth)
      NexusEditorChoiceGroup(
        title: "Status",
        value: $draft.environment,
        options: ["ACTIVE", "INACTIVE"],
        width: formWidth
      )
      NexusEditorSectionHeader("OTHER")
      NexusEditorTextArea("Note", text: $draft.note, width: formWidth)
    }
    .confirmationDialog("", isPresented: $confirmsDelete) {
      Button("DELETE", role: .destructive) {
        if let row {
          Task { await model.deleteAPIKey(row.id) }
        }
      }
    }
  }
}

struct NexusCardEditorOverlay: View {
  @EnvironmentObject private var model: NexusVaultModel
  @State private var draft: NexusCardDraft
  @State private var confirmsDelete = false
  let row: NexusCard?
  let isCreating: Bool

  init(row: NexusCard) {
    self.row = row
    self.isCreating = false
    _draft = State(initialValue: NexusCardDraft(row: row))
  }

  init() {
    self.row = nil
    self.isCreating = true
    _draft = State(initialValue: NexusCardDraft())
  }

  var body: some View {
    NexusEditorOverlayShell(
      title: isCreating ? "Add Credit Card" : "Edit Credit Card",
      onClose: { model.dismissEditor() },
      onDelete: isCreating ? nil : { confirmsDelete = true },
      onSave: { Task { isCreating ? await model.createCard(draft) : await model.saveCard(draft) } }
    ) { formWidth in
      NexusEditorResourceTitleRow(
        section: .cards,
        placeholder: "Title",
        text: $draft.cardName,
        width: formWidth,
        urlString: row?.resolvedIconUrl,
        iconKey: firstNonEmpty(draft.resolvedIconKey, draft.iconKey),
        website: nil,
        fallback: "C"
      )
      NexusEditorSectionHeader("CARD DETAILS")
      NexusEditorChoiceGroup(
        title: "Type",
        value: $draft.network,
        options: ["VISA", "MASTERCARD", "AMEX", "DEBIT", "VIRTUAL"],
        width: formWidth
      )
      NexusEditorTextField("Card Number", text: $draft.cardNumber, width: formWidth)
      if !isNoCreditNetwork(draft.network) {
        NexusEditorCurrencyAmountField(
          title: "Credit",
          amount: $draft.creditLimit,
          currency: $draft.creditCurrency,
          width: formWidth
        )
      }
      NexusEditorExpiryField("Expiration Date", text: $draft.expiry, width: formWidth)
      NexusEditorSecureTextField("CVV", text: $draft.cvv, width: formWidth, keyboard: .number)
      NexusEditorPINField("Card PIN", text: $draft.pin, width: formWidth)
      if !isNoCreditNetwork(draft.network) {
        NexusEditorDateField("Next Billing", text: $draft.nextBillingDate, width: formWidth)
      }
      NexusEditorSectionHeader("OTHER")
      NexusEditorTextArea("Note", text: $draft.note, width: formWidth)
    }
    .confirmationDialog("", isPresented: $confirmsDelete) {
      Button("DELETE", role: .destructive) {
        if let row {
          Task { await model.deleteCard(row.id) }
        }
      }
    }
  }
}

struct NexusRecurringEditorOverlay: View {
  @EnvironmentObject private var model: NexusVaultModel
  @State private var draft: NexusRecurringDraft
  @State private var confirmsDelete = false
  let row: NexusRecurring?
  let isCreating: Bool

  init(row: NexusRecurring) {
    self.row = row
    self.isCreating = false
    _draft = State(initialValue: NexusRecurringDraft(row: row))
  }

  init() {
    self.row = nil
    self.isCreating = true
    _draft = State(initialValue: NexusRecurringDraft())
  }

  var body: some View {
    NexusEditorOverlayShell(
      title: isCreating ? "Add Recurring" : "Edit Recurring",
      onClose: { model.dismissEditor() },
      onDelete: isCreating ? nil : { confirmsDelete = true },
      onSave: { Task { isCreating ? await model.createRecurring(draft) : await model.saveRecurring(draft) } }
    ) { formWidth in
      NexusEditorResourceTitleRow(
        section: .subscriptions,
        placeholder: "Title",
        text: $draft.service,
        width: formWidth,
        urlString: row?.resolvedIconUrl,
        iconKey: firstNonEmpty(draft.resolvedIconKey, draft.iconKey),
        website: nil,
        fallback: "R"
      )
      NexusEditorSectionHeader("BILLING DETAILS")
      NexusEditorChoiceGroup(
        title: "Type",
        value: $draft.tier,
        options: ["PAID", "FREE TRIAL"],
        width: formWidth
      )
      NexusEditorChoiceGroup(
        title: "Cycle",
        value: $draft.cadence,
        options: ["MONTHLY", "QUARTERLY", "YEARLY"],
        width: formWidth
      )
      NexusEditorCurrencyAmountField(
        title: "Bill Amount",
        amount: $draft.amount,
        currency: $draft.amountCurrency,
        width: formWidth
      )
      NexusEditorDateField("Next Billing", text: $draft.nextBillingDate, width: formWidth)
      NexusEditorChoiceGroup(
        title: "Status",
        value: $draft.status,
        options: ["ACTIVE", "INACTIVE"],
        width: formWidth
      )
      NexusEditorSectionHeader("OTHER")
      NexusEditorTextArea("Note", text: $draft.note, width: formWidth)
    }
    .confirmationDialog("", isPresented: $confirmsDelete) {
      Button("DELETE", role: .destructive) {
        if let row {
          Task { await model.deleteRecurring(row.id) }
        }
      }
    }
  }
}

struct NexusSettingsOverlay: View {
  @EnvironmentObject private var model: NexusVaultModel
  @Environment(\.openURL) private var openURL
  @Environment(\.requestReview) private var requestReview
  @AppStorage("nexus.settings.autofill") private var autofillEnabled = false
  @AppStorage("nexus.settings.faceid") private var faceIDEnabled = false

  var body: some View {
    GeometryReader { proxy in
      let safeTop = proxy.safeAreaInsets.top
      let panelWidth = proxy.size.width

      ZStack(alignment: .top) {
        NexusBlueprintBackground()

        VStack(spacing: NexusTokens.seam) {
          NexusSettingsNavBar(onClose: { model.dismissSettings() })
            .padding(.top, safeTop)
            .frame(height: safeTop + NexusTokens.editorNavHeight)
            .background(Color.clear)
            .overlay(alignment: .bottom) {
              Rectangle()
                .fill(NexusTokens.editorDivider)
                .frame(height: NexusTokens.seam)
            }

          ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
              NexusEditorSectionHeader("ACCOUNT")
              NexusSettingsValueRow(title: "Email", value: model.accountEmail, width: panelWidth)
              NexusSettingsActionRow(title: "Password", width: panelWidth) {}
              NexusSettingsActionRow(title: "Logout", width: panelWidth) {
                model.dismissSettings()
                model.logout()
              }

              NexusEditorSectionHeader("SECURITY")
              NexusSettingsToggleRow(title: "Turn on Autofill", isOn: $autofillEnabled, width: panelWidth)
              NexusSettingsToggleRow(title: "Unlock with Face ID", isOn: $faceIDEnabled, width: panelWidth)

              NexusEditorSectionHeader("APP")
              NexusSettingsActionRow(title: "Rate Nexus", width: panelWidth) {
                requestReview()
              }
              NexusSettingsActionRow(title: "Feedback", width: panelWidth) {
                openURL(nexusFeedbackURL())
              }
              NexusSettingsActionRow(title: "Help", width: panelWidth) {
                openURL(nexusHelpURL())
              }
              NexusSettingsActionRow(title: "Privacy Policy", width: panelWidth) {
                openURL(nexusPrivacyURL())
              }
              NexusSettingsValueRow(title: "Version", value: nexusAppVersionText(), width: panelWidth)
            }
          }
          .background(Color.clear)
        }
        .frame(width: panelWidth)
        .ignoresSafeArea(edges: .top)
      }
    }
  }
}

struct NexusSettingsNavBar: View {
  let onClose: () -> Void

  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Button("CANCEL", action: onClose)
        .font(NexusTokens.editorNavButtonFont)
        .tracking(NexusTokens.editorNavButtonTracking)
        .frame(width: NexusTokens.editorNavSideWidth, alignment: .leading)
      Text("SETTINGS")
        .font(NexusTokens.editorNavTitleFont)
        .tracking(NexusTokens.editorNavTitleTracking)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
      Color.clear
        .frame(width: NexusTokens.editorNavSideWidth)
    }
    .buttonStyle(.plain)
    .foregroundStyle(NexusTokens.strong)
    .padding(.horizontal, NexusTokens.editorNavHorizontalPadding)
    .frame(height: NexusTokens.editorNavHeight)
  }
}

struct NexusSettingsValueRow: View {
  let title: String
  let value: String
  let width: CGFloat

  var body: some View {
    NexusEditorRow(width: width) {
      HStack(spacing: NexusTokens.editorInlineFieldGap) {
        Text(title)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.editorPlaceholder)
          .lineLimit(1)
        Text(clean(value).isEmpty ? "-" : clean(value))
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
          .truncationMode(.middle)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}

struct NexusSettingsToggleRow: View {
  let title: String
  @Binding var isOn: Bool
  let width: CGFloat

  var body: some View {
    NexusEditorRow(width: width) {
      Text(title)
        .font(NexusTokens.editorFieldFont)
        .foregroundStyle(NexusTokens.strong)
        .lineLimit(1)
      Spacer(minLength: NexusTokens.editorInlineFieldGap)
      Toggle("", isOn: $isOn)
        .labelsHidden()
        .tint(NexusTokens.strong)
        .scaleEffect(NexusTokens.settingsToggleScale)
    }
  }
}

struct NexusSettingsActionRow: View {
  let title: String
  let width: CGFloat
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      NexusEditorRow(width: width) {
        Text(title)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
        Spacer(minLength: NexusTokens.editorInlineFieldGap)
      }
    }
    .buttonStyle(.plain)
  }
}

struct NexusEditorOverlayShell<Content: View>: View {
  let title: String
  let onClose: () -> Void
  let onDelete: (() -> Void)?
  let onSave: () -> Void
  @ViewBuilder let content: (CGFloat) -> Content

  var body: some View {
    GeometryReader { proxy in
      let safeTop = proxy.safeAreaInsets.top
      let panelWidth = proxy.size.width

      ZStack(alignment: .top) {
        NexusBlueprintBackground()

        VStack(spacing: NexusTokens.seam) {
          NexusEditorNavBar(title: title, onClose: onClose, onSave: onSave)
            .padding(.top, safeTop)
            .frame(height: safeTop + NexusTokens.editorNavHeight)
            .background(Color.clear)
            .overlay(alignment: .bottom) {
              Rectangle()
                .fill(NexusTokens.editorDivider)
                .frame(height: NexusTokens.seam)
            }

          ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
              content(panelWidth)
              if let onDelete {
                NexusEditorDeleteRow(width: panelWidth, action: onDelete)
              }
            }
          }
          .background(Color.clear)
        }
        .frame(width: panelWidth)
        .ignoresSafeArea(edges: .top)
      }
    }
  }
}

struct NexusEditorNavBar: View {
  let title: String
  let onClose: () -> Void
  let onSave: () -> Void

  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      Button("CANCEL", action: onClose)
        .font(NexusTokens.editorNavButtonFont)
        .tracking(NexusTokens.editorNavButtonTracking)
        .frame(width: NexusTokens.editorNavSideWidth, alignment: .leading)
      Text(title.uppercased())
        .font(NexusTokens.editorNavTitleFont)
        .tracking(NexusTokens.editorNavTitleTracking)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
      Button("SAVE", action: onSave)
        .font(NexusTokens.editorNavButtonFont)
        .tracking(NexusTokens.editorNavButtonTracking)
        .frame(width: NexusTokens.editorNavSideWidth, alignment: .trailing)
    }
    .buttonStyle(.plain)
    .foregroundStyle(NexusTokens.strong)
    .padding(.horizontal, NexusTokens.editorNavHorizontalPadding)
    .frame(height: NexusTokens.editorNavHeight)
  }
}

struct NexusEditorSectionHeader: View {
  let title: String

  init(_ title: String) {
    self.title = title
  }

  var body: some View {
    Text(title)
      .font(NexusTokens.editorSectionHeaderFont)
      .tracking(NexusTokens.editorSectionHeaderTracking)
      .textCase(.uppercase)
      .foregroundStyle(NexusTokens.muted)
      .frame(maxWidth: .infinity, minHeight: NexusTokens.editorSectionHeaderHeight, alignment: .leading)
      .padding(.horizontal, NexusTokens.editorRowHorizontalPadding)
      .background(NexusTokens.section.opacity(0.72))
      .overlay(alignment: .bottom) {
        Rectangle()
          .fill(NexusTokens.editorDivider)
          .frame(height: NexusTokens.seam)
      }
  }
}

struct NexusEditorTitleRow<Icon: View>: View {
  let placeholder: String
  @Binding var text: String
  let width: CGFloat
  @ViewBuilder let icon: () -> Icon

  init(_ placeholder: String, text: Binding<String>, width: CGFloat, @ViewBuilder icon: @escaping () -> Icon) {
    self.placeholder = placeholder
    self._text = text
    self.width = width
    self.icon = icon
  }

  var body: some View {
    HStack(spacing: NexusTokens.editorRowIconGap) {
      icon()
        .frame(width: NexusTokens.editorTitleIconSize, height: NexusTokens.editorTitleIconSize)
      NexusEditorPlainField(placeholder: placeholder, text: $text)
    }
    .padding(.horizontal, NexusTokens.editorRowHorizontalPadding)
    .frame(width: width, height: NexusTokens.editorTitleRowHeight)
    .background(NexusTokens.editorRowBackground)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(NexusTokens.editorDivider)
        .frame(height: NexusTokens.seam)
    }
  }
}

struct NexusEditorResourceTitleRow: View {
  let section: NexusSection
  let placeholder: String
  @Binding var text: String
  let width: CGFloat
  let urlString: String?
  let iconKey: String?
  let website: String?
  let fallback: String

  var body: some View {
    NexusEditorTitleRow(placeholder, text: $text, width: width) {
      if hasIconReference {
        NexusIconTile(
          urlString: urlString,
          iconKey: iconKey,
          website: website,
          fallback: fallback,
          defaultSection: section
        )
      } else {
        NexusEditorSectionIcon(section: section)
      }
    }
  }

  private var hasIconReference: Bool {
    !emptyToBlank(urlString).isEmpty || !emptyToBlank(iconKey).isEmpty || !NexusHost.normalize(website).isEmpty
  }
}

struct NexusEditorSectionIcon: View {
  let section: NexusSection

  var body: some View {
    NexusAssetIcon(path: section.navIconPath, selected: false, size: NexusTokens.editorTitleIconSize)
      .frame(width: NexusTokens.editorTitleIconSize, height: NexusTokens.editorTitleIconSize)
      .background(NexusTokens.editorRowBackground)
      .overlay(Rectangle().stroke(NexusTokens.editorDivider, lineWidth: NexusTokens.seam))
  }
}

struct NexusEditorFallbackIcon: View {
  let text: String

  init(_ text: String) {
    self.text = text
  }

  var body: some View {
    Text(text)
      .font(NexusTokens.editorFallbackIconFont)
      .foregroundStyle(NexusTokens.strong)
      .frame(width: NexusTokens.editorTitleIconSize, height: NexusTokens.editorTitleIconSize)
      .background(NexusTokens.editorRowBackground)
      .overlay(Rectangle().stroke(NexusTokens.editorDivider, lineWidth: NexusTokens.seam))
  }
}

enum NexusEditorKeyboard {
  case text
  case number
  case decimal
}

#if os(iOS)
private extension NexusEditorKeyboard {
  var type: UIKeyboardType {
    switch self {
    case .text: return .default
    case .number: return .numberPad
    case .decimal: return .decimalPad
    }
  }
}
#endif

struct NexusEditorTextField: View {
  let placeholder: String
  @Binding var text: String
  let width: CGFloat
  var keyboard: NexusEditorKeyboard = .text
  var valuePlaceholder = ""

  init(
    _ placeholder: String,
    text: Binding<String>,
    width: CGFloat,
    keyboard: NexusEditorKeyboard = .text,
    valuePlaceholder: String = ""
  ) {
    self.placeholder = placeholder
    self._text = text
    self.width = width
    self.keyboard = keyboard
    self.valuePlaceholder = valuePlaceholder
  }

  var body: some View {
    NexusEditorRow(width: width) {
      NexusEditorPlainField(
        placeholder: placeholder,
        text: $text,
        keyboard: keyboard,
        valuePlaceholder: valuePlaceholder
      )
    }
  }
}

struct NexusEditorSecureTextField: View {
  let placeholder: String
  @Binding var text: String
  let width: CGFloat
  var keyboard: NexusEditorKeyboard = .text
  @State private var isVisible = false

  init(_ placeholder: String, text: Binding<String>, width: CGFloat, keyboard: NexusEditorKeyboard = .text) {
    self.placeholder = placeholder
    self._text = text
    self.width = width
    self.keyboard = keyboard
  }

  var body: some View {
    NexusEditorRow(width: width) {
      HStack(spacing: NexusTokens.editorRowIconGap) {
        Text(placeholder)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.editorPlaceholder)
          .lineLimit(1)
        if isVisible || text.isEmpty {
          NexusEditorValueField(text: $text, keyboard: keyboard)
        } else {
          Button {
            isVisible = true
          } label: {
            Text(maskedEditorValue(text))
              .font(NexusTokens.editorFieldFont)
              .tracking(NexusTokens.compactPasswordRowMaskTracking)
              .foregroundStyle(NexusTokens.strong)
              .lineLimit(1)
              .frame(maxWidth: .infinity, alignment: .leading)
              .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
          .frame(maxWidth: .infinity, alignment: .leading)
          .contentShape(Rectangle())
        }
      }
    }
  }
}

struct NexusEditorPlainField: View {
  let placeholder: String
  @Binding var text: String
  var keyboard: NexusEditorKeyboard = .text
  var valuePlaceholder = ""

  var body: some View {
    HStack(spacing: NexusTokens.editorInlineFieldGap) {
      Text(placeholder)
        .font(NexusTokens.editorFieldFont)
        .foregroundStyle(NexusTokens.editorPlaceholder)
        .lineLimit(1)
      NexusEditorValueField(text: $text, keyboard: keyboard, valuePlaceholder: valuePlaceholder)
    }
  }
}

struct NexusEditorValueField: View {
  @Binding var text: String
  var keyboard: NexusEditorKeyboard = .text
  var valuePlaceholder = ""

  var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty && !valuePlaceholder.isEmpty {
        Text(valuePlaceholder)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.editorPlaceholder)
          .lineLimit(1)
      }
      TextField("", text: $text)
        #if os(iOS)
        .keyboardType(keyboard.type)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        #endif
        .textFieldStyle(.plain)
        .font(NexusTokens.editorFieldFont)
        .foregroundStyle(NexusTokens.strong)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct NexusEditorPINField: View {
  let placeholder: String
  @Binding var text: String
  let width: CGFloat

  init(_ placeholder: String, text: Binding<String>, width: CGFloat) {
    self.placeholder = placeholder
    self._text = text
    self.width = width
  }

  var body: some View {
    NexusEditorSecureTextField(placeholder, text: pinBinding, width: width, keyboard: .number)
  }

  private var pinBinding: Binding<String> {
    Binding(
      get: { text },
      set: { text = String(digitsOnly($0).prefix(NexusTokens.editorPinMaxDigits)) }
    )
  }
}

struct NexusEditorTextArea: View {
  let placeholder: String
  @Binding var text: String
  let width: CGFloat

  init(_ placeholder: String, text: Binding<String>, width: CGFloat) {
    self.placeholder = placeholder
    self._text = text
    self.width = width
  }

  var body: some View {
    NexusEditorRow(width: width) {
      NexusEditorPlainField(placeholder: placeholder, text: $text)
    }
  }
}

struct NexusEditorCurrencyAmountField: View {
  let title: String
  @Binding var amount: String
  @Binding var currency: String
  let width: CGFloat

  var body: some View {
    VStack(spacing: 0) {
      NexusEditorChoiceGroup(
        title: "\(title) Currency",
        value: $currency,
        options: currencyOptions.map { $0.id },
        width: width,
        optionLabels: optionLabels
      )
      NexusEditorTextField(title, text: $amount, width: width, keyboard: .decimal)
    }
  }

  private var currencyOptions: [(id: String, label: String)] {
    NexusCurrency.editorOptions.map { ($0, NexusCurrency.symbol(for: $0)) }
  }

  private var optionLabels: [String: String] {
    Dictionary(uniqueKeysWithValues: currencyOptions.map { ($0.id, $0.label) })
  }
}

struct NexusEditorDigitField: View {
  let title: String
  @Binding var text: String
  let segmentCount: Int
  let formatsExpiry: Bool
  let width: CGFloat

  var body: some View {
    NexusEditorTextField(
      title,
      text: formattedBinding,
      width: width,
      keyboard: .number,
      valuePlaceholder: "MM/YY"
    )
  }

  private var formattedBinding: Binding<String> {
    Binding(
      get: { text },
      set: { text = formatsExpiry ? formatExpiryDigits($0) : String(digitsOnly($0).prefix(segmentCount)) }
    )
  }
}

struct NexusEditorExpiryField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    NexusEditorTextField(
      title,
      text: formattedBinding,
      width: width,
      keyboard: .number,
      valuePlaceholder: "MM/YY"
    )
  }

  private var formattedBinding: Binding<String> {
    Binding(
      get: { text },
      set: { text = formatExpiryDigits($0) }
    )
  }
}

struct NexusEditorDateField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    NexusEditorTextField(
      title,
      text: formattedBinding,
      width: width,
      keyboard: .number,
      valuePlaceholder: "YYYY-MM-DD"
    )
  }

  private var formattedBinding: Binding<String> {
    Binding(
      get: { text },
      set: { text = formatISODateDigits($0) }
    )
  }
}

struct NexusEditorCredentialModePicker: View {
  @Binding var value: String
  let width: CGFloat

  var body: some View {
    NexusEditorChoiceGroup(
      title: "Type",
      value: $value,
      options: ["PASSWORD", "ONE-TIME-CODE"],
      width: width
    )
  }
}

struct NexusEditorChoiceGroup: View {
  let title: String
  @Binding var value: String
  let options: [String]
  let width: CGFloat
  let optionLabels: [String: String]
  let optionStyles: [String: NexusChipStyle]

  init(
    title: String,
    value: Binding<String>,
    options: [String],
    width: CGFloat,
    optionLabels: [String: String] = [:],
    optionStyles: [String: NexusChipStyle] = [:]
  ) {
    self.title = title
    self._value = value
    self.options = options
    self.width = width
    self.optionLabels = optionLabels
    self.optionStyles = optionStyles
  }

  var body: some View {
    NexusEditorRow(width: width) {
      Text(title)
        .font(NexusTokens.editorFieldFont)
        .foregroundStyle(NexusTokens.editorPlaceholder)
        .lineLimit(1)
      Spacer(minLength: NexusTokens.editorRowIconGap)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: NexusTokens.editorChoiceGap) {
          ForEach(options, id: \.self) { option in
            NexusEditorChoiceButton(
              title: optionLabels[option] ?? option,
              selected: value == option,
              style: optionStyles[option] ?? .normal
            ) {
              value = option
            }
          }
        }
      }
    }
  }
}

struct NexusEditorChoiceButton: View {
  let title: String
  let selected: Bool
  var style: NexusChipStyle = .normal
  var width: CGFloat?
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(NexusTokens.editorChoiceFont)
        .tracking(NexusTokens.chipTracking)
        .lineLimit(1)
        .padding(.horizontal, NexusTokens.editorChoiceHorizontalPadding)
        .frame(width: width)
        .frame(height: NexusTokens.editorChoiceHeight)
    }
    .buttonStyle(.plain)
    .foregroundStyle(foreground)
    .background(background)
    .overlay(Rectangle().stroke(NexusTokens.editorFieldBorder, lineWidth: NexusTokens.seam))
  }

  private var foreground: Color {
    switch style {
    case .success:
      return NexusTokens.statusSuccess
    case .muted, .ghost:
      return NexusTokens.muted
    case .normal:
      return selected ? Color.white : NexusTokens.strong
    }
  }

  private var background: Color {
    switch style {
    case .success:
      return NexusTokens.statusSuccessTint
    case .muted:
      return selected ? NexusTokens.mutedPanel : Color.white.opacity(0.94)
    case .ghost:
      return Color.clear
    case .normal:
      return selected ? NexusTokens.strong : Color.white.opacity(0.94)
    }
  }
}

struct NexusEditorPasswordGeneratorRow: View {
  @Binding var password: String
  let width: CGFloat
  @State private var candidate = ""
  @State private var includesDigits = true
  @State private var includesSymbols = true
  @State private var lengthText = String(NexusTokens.editorPasswordLengthDefault)

  var body: some View {
    HStack(spacing: NexusTokens.seam) {
      Text(candidate)
        .font(NexusTokens.editorFieldFont)
        .foregroundStyle(NexusTokens.strong)
        .lineLimit(1)
        .truncationMode(.middle)
        .frame(maxWidth: .infinity, minHeight: NexusTokens.editorPasswordGeneratorDisplayHeight, alignment: .leading)
        .padding(.horizontal, NexusTokens.editorRowHorizontalPadding)
        .background(NexusTokens.editorRowBackground)
        .overlay(Rectangle().stroke(NexusTokens.editorDivider, lineWidth: NexusTokens.seam))
      NexusEditorIconButton {
        regenerate()
      } icon: {
        NexusDiceGlyph()
          .stroke(style: StrokeStyle(lineWidth: NexusTokens.editorSecureIconStrokeWidth, lineCap: .round, lineJoin: .round))
      }
      NexusEditorIconButton {
        password = candidate
      } icon: {
        NexusCheckGlyph()
          .stroke(style: StrokeStyle(lineWidth: NexusTokens.editorSecureIconStrokeWidth, lineCap: .round, lineJoin: .round))
      }
      NexusEditorChoiceButton(title: "123", selected: includesDigits, width: NexusTokens.editorPasswordGeneratorOptionWidth) {
        includesDigits.toggle()
        regenerate()
      }
      NexusEditorChoiceButton(title: "!@#", selected: includesSymbols, width: NexusTokens.editorPasswordGeneratorOptionWidth) {
        includesSymbols.toggle()
        regenerate()
      }
      HStack(spacing: NexusTokens.editorInlineFieldGap) {
        Text("Length")
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.editorPlaceholder)
          .lineLimit(1)
        TextField("", text: lengthBinding)
          #if os(iOS)
          .keyboardType(.numberPad)
          #endif
          .textFieldStyle(.plain)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.strong)
          .multilineTextAlignment(.trailing)
          .frame(width: NexusTokens.editorPasswordLengthWidth)
      }
      .padding(.horizontal, NexusTokens.editorChoiceHorizontalPadding)
      .frame(width: NexusTokens.editorPasswordLengthGroupWidth, height: NexusTokens.editorPasswordGeneratorDisplayHeight)
      .background(NexusTokens.editorRowBackground)
      .overlay(Rectangle().stroke(NexusTokens.editorFieldBorder, lineWidth: NexusTokens.seam))
    }
    .frame(width: width)
    .background(Color.clear)
    .onAppear {
      if candidate.isEmpty {
        regenerate()
      }
    }
  }

  private var lengthBinding: Binding<String> {
    Binding(
      get: { lengthText },
      set: {
        lengthText = String(digitsOnly($0).prefix(2))
        regenerate()
      }
    )
  }

  private func regenerate() {
    candidate = generatedEditorPassword(
      length: normalizedLength,
      includesDigits: includesDigits,
      includesSymbols: includesSymbols
    )
  }

  private var normalizedLength: Int {
    min(
      NexusTokens.editorPasswordLengthMax,
      max(NexusTokens.editorPasswordLengthMin, Int(lengthText) ?? NexusTokens.editorPasswordLengthDefault)
    )
  }
}

struct NexusEditorIconButton<Icon: View>: View {
  let action: () -> Void
  @ViewBuilder let icon: () -> Icon

  var body: some View {
    Button(action: action) {
      icon()
        .frame(width: NexusTokens.IconSize, height: NexusTokens.IconSize)
        .foregroundStyle(NexusTokens.strong)
        .frame(width: NexusTokens.editorPasswordGeneratorDisplayHeight, height: NexusTokens.editorPasswordGeneratorDisplayHeight)
        .background(NexusTokens.editorRowBackground)
        .overlay(Rectangle().stroke(NexusTokens.editorDivider, lineWidth: NexusTokens.seam))
    }
    .buttonStyle(.plain)
  }
}

struct NexusEditorRow<Content: View>: View {
  let width: CGFloat
  var showsDivider = true
  @ViewBuilder let content: () -> Content

  var body: some View {
    HStack(spacing: 0) {
      content()
    }
    .padding(.horizontal, NexusTokens.editorRowHorizontalPadding)
    .frame(width: width, height: NexusTokens.editorRowHeight)
    .background(NexusTokens.editorRowBackground)
    .overlay(alignment: .bottom) {
      if showsDivider {
        Rectangle()
          .fill(NexusTokens.editorDivider)
          .frame(height: NexusTokens.seam)
      }
    }
  }
}

struct NexusEditorActionRow: View {
  let title: String
  let width: CGFloat
  let action: () -> Void

  init(_ title: String, width: CGFloat, action: @escaping () -> Void) {
    self.title = title
    self.width = width
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      NexusEditorRow(width: width) {
        Text(title)
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.strong)
        Spacer()
      }
    }
    .buttonStyle(.plain)
  }
}

struct NexusEditorDeleteRow: View {
  let width: CGFloat
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      NexusEditorRow(width: width, showsDivider: false) {
        Text("Delete")
          .font(NexusTokens.editorFieldFont)
          .foregroundStyle(NexusTokens.editorDanger)
        Spacer()
      }
    }
    .buttonStyle(.plain)
  }
}

struct NexusEyeGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let iconRect = rect.insetBy(dx: rect.width * 0.08, dy: rect.height * 0.18)
    let center = CGPoint(x: iconRect.midX, y: iconRect.midY)
    let eyeRadius = min(iconRect.width, iconRect.height) * 0.18
    var path = Path()
    path.move(to: CGPoint(x: iconRect.minX, y: center.y))
    path.addQuadCurve(to: CGPoint(x: iconRect.maxX, y: center.y), control: CGPoint(x: center.x, y: iconRect.minY))
    path.addQuadCurve(to: CGPoint(x: iconRect.minX, y: center.y), control: CGPoint(x: center.x, y: iconRect.maxY))
    path.addEllipse(in: CGRect(
      x: center.x - eyeRadius,
      y: center.y - eyeRadius,
      width: eyeRadius * 2,
      height: eyeRadius * 2
    ))
    return path
  }
}

struct NexusDiceGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let iconRect = rect.insetBy(dx: rect.width * 0.16, dy: rect.height * 0.16)
    let dotSide = min(iconRect.width, iconRect.height) * 0.12
    let dotRadius = dotSide / 2
    let dotCenters = [
      CGPoint(x: iconRect.minX + iconRect.width * 0.28, y: iconRect.minY + iconRect.height * 0.28),
      CGPoint(x: iconRect.maxX - iconRect.width * 0.28, y: iconRect.minY + iconRect.height * 0.28),
      CGPoint(x: iconRect.midX, y: iconRect.midY),
      CGPoint(x: iconRect.minX + iconRect.width * 0.28, y: iconRect.maxY - iconRect.height * 0.28),
      CGPoint(x: iconRect.maxX - iconRect.width * 0.28, y: iconRect.maxY - iconRect.height * 0.28)
    ]
    var path = Path()
    path.addRoundedRect(in: iconRect, cornerSize: CGSize(width: NexusTokens.corner, height: NexusTokens.corner))
    for center in dotCenters {
      path.addEllipse(in: CGRect(
        x: center.x - dotRadius,
        y: center.y - dotRadius,
        width: dotSide,
        height: dotSide
      ))
    }
    return path
  }
}

struct NexusCheckGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let iconRect = rect.insetBy(dx: rect.width * 0.18, dy: rect.height * 0.24)
    var path = Path()
    path.move(to: CGPoint(x: iconRect.minX, y: iconRect.midY))
    path.addLine(to: CGPoint(x: iconRect.minX + iconRect.width * 0.36, y: iconRect.maxY))
    path.addLine(to: CGPoint(x: iconRect.maxX, y: iconRect.minY))
    return path
  }
}

private func generatedEditorPassword(
  length: Int = NexusTokens.editorPasswordLengthDefault,
  includesDigits: Bool = true,
  includesSymbols: Bool = true
) -> String {
  let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  let digits = Array("0123456789")
  let symbols = Array("!@#")
  let minimumDigits = requiredPasswordClassCount(length: length, enabled: includesDigits)
  let minimumSymbols = requiredPasswordClassCount(length: length, enabled: includesSymbols)
  var generator = SystemRandomNumberGenerator()
  var requiredDigits = minimumDigits
  var requiredSymbols = minimumSymbols
  while requiredDigits + requiredSymbols > length {
    if requiredSymbols >= requiredDigits {
      requiredSymbols -= 1
    } else {
      requiredDigits -= 1
    }
  }

  var characters: [Character] = []
  characters += randomCharacters(from: digits, count: requiredDigits, generator: &generator)
  characters += randomCharacters(from: symbols, count: requiredSymbols, generator: &generator)

  let pool = letters + (includesDigits ? digits : []) + (includesSymbols ? symbols : [])
  characters += randomCharacters(from: pool, count: max(0, length - characters.count), generator: &generator)
  characters.shuffle(using: &generator)
  return String(characters)
}

private func requiredPasswordClassCount(length: Int, enabled: Bool) -> Int {
  guard enabled else { return 0 }
  let ratioCount = Int((Double(length) * NexusTokens.editorPasswordRequiredClassRatio).rounded(.up))
  let minimum = length >= NexusTokens.editorPasswordLengthDefault
    ? NexusTokens.editorPasswordRequiredClassMin
    : 1
  return max(minimum, ratioCount)
}

private func randomCharacters(
  from pool: [Character],
  count: Int,
  generator: inout SystemRandomNumberGenerator
) -> [Character] {
  guard !pool.isEmpty && count > 0 else { return [] }
  return (0..<count).compactMap { _ in pool.randomElement(using: &generator) }
}

struct NexusSidebar: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.gutter) {
      Text("Nexus")
        .font(NexusFont.semibold(36))
        .tracking(-2)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .center)
      VStack(spacing: 8) {
        ForEach(NexusSection.allCases) { section in
          NexusNavButton(section: section, selected: model.selectedSection == section) {
            model.open(section)
          }
        }
      }
      Spacer()
      Text(model.accountEmail)
        .font(NexusTokens.inputFont)
        .foregroundStyle(NexusTokens.muted)
      NexusButton("Logout") { model.logout() }
    }
    .padding(18)
    .frame(width: NexusTokens.sidebarWidth)
    .background(NexusTokens.section)
  }
}

struct NexusMobileTopBar: View {
  @EnvironmentObject private var model: NexusVaultModel
  var horizontalPadding = NexusTokens.topBarHorizontalPadding
  var showAccount = true

  var body: some View {
    NexusGlassContainer(spacing: NexusTokens.toolbarRowGap) {
      HStack(alignment: .center, spacing: NexusTokens.toolbarRowGap) {
        NexusSearchLine(text: $model.searchText)
        HStack(spacing: NexusTokens.toolbarActionGap) {
          NexusSquareButton(toolbarIcon: .add, variant: .primary) {
            model.createEntry()
          }
          if showAccount {
            NexusSquareButton(toolbarIcon: .account, variant: .secondary) {
              model.openSettings()
            }
          }
        }
      }
    }
    .padding(.horizontal, horizontalPadding)
    .padding(.vertical, NexusTokens.topBarVerticalPadding)
  }
}

struct NexusMobileNav: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NexusTokens.mobileNavGap) {
      ForEach(NexusSection.allCases) { section in
        NexusNavButton(section: section, selected: model.selectedSection == section) {
          model.open(section)
        }
      }
    }
    .padding(.horizontal, NexusTokens.topBarHorizontalPadding)
    .padding(.bottom, NexusTokens.mobileNavBottomPadding)
  }
}

struct NexusMobileNavSupplement: View {
  @EnvironmentObject private var model: NexusVaultModel
  var horizontalPadding = NexusTokens.topBarHorizontalPadding

  var body: some View {
    Group {
      switch model.selectedSection {
      case .passwords:
        NexusCompactPasswordsMetricStrip(metrics: model.snapshot.passwordMetrics)
      case .apiKeys:
        NexusCompactPasswordsMetricStrip(metrics: model.snapshot.apiKeyMetrics)
      case .cards:
        NexusCompactPasswordsMetricStrip(metrics: model.snapshot.cardMetrics)
      case .subscriptions:
        NexusCompactPasswordsMetricStrip(metrics: model.snapshot.subscriptionMetrics)
      }
    }
    .padding(.horizontal, horizontalPadding)
    .padding(.bottom, NexusTokens.mobileMetricsBottomPadding)
  }
}

struct NexusBottomTabBar: View {
  @EnvironmentObject private var model: NexusVaultModel
  @Namespace private var selectionNamespace
  @State private var dragSelectionCenterX: CGFloat?

  private let items = NexusBottomTabItem.allCases

  var body: some View {
    NexusGlassContainer(spacing: NexusTokens.bottomTabGlassSpacing) {
      GeometryReader { proxy in
        ZStack(alignment: .topLeading) {
          NexusBottomTabSelectionGlass(namespace: selectionNamespace)
            .frame(
              width: selectionDynamicWidth(in: proxy.size.width),
              height: selectionDynamicHeight(in: proxy.size.height)
            )
            .offset(
              x: selectionOffsetX(in: proxy.size.width),
              y: selectionOffsetY(in: proxy.size.height)
            )
            .allowsHitTesting(false)
            .animation(dragSelectionCenterX == nil ? NexusMotion.tab : nil, value: model.selectedSection)
            .animation(dragSelectionCenterX == nil ? NexusMotion.tab : nil, value: model.showingSettings)
            .animation(dragSelectionCenterX == nil ? NexusMotion.tab : nil, value: dragSelectionCenterX)
            .animation(NexusMotion.tabPress, value: isDragging)

          HStack(spacing: 0) {
            ForEach(items) { item in
              NexusBottomTabButton(item: item) {
                withAnimation(NexusMotion.tab) {
                  open(item)
                }
              }
            }
          }
          .padding(NexusTokens.bottomTabInnerPadding)
          .zIndex(1)
        }
        .background(.ultraThinMaterial, in: Capsule())
        .background(Color.white.opacity(NexusTokens.bottomTabGlassSurfaceOpacity), in: Capsule())
        .overlay(Capsule().stroke(NexusTokens.liquidGlassStroke, lineWidth: NexusTokens.liquidGlassStrokeWidth))
        .shadow(
          color: NexusTokens.liquidGlassShadow,
          radius: NexusTokens.liquidGlassShadowRadius,
          y: NexusTokens.liquidGlassShadowYOffset
        )
        .contentShape(Capsule())
        .simultaneousGesture(tabDragGesture(width: proxy.size.width))
      }
      .frame(height: NexusTokens.bottomTabHeight)
      .frame(maxWidth: .infinity)
    }
    .animation(NexusMotion.tab, value: model.selectedSection)
    .animation(NexusMotion.tab, value: model.showingSettings)
  }

  private func open(_ item: NexusBottomTabItem) {
    if item == .settings {
      model.openSettings()
      return
    }
    model.dismissSettings()
    if let section = item.section {
      model.open(section)
    }
  }

  private var isDragging: Bool {
    dragSelectionCenterX != nil
  }

  private var selectedItem: NexusBottomTabItem {
    if model.showingSettings {
      return .settings
    }
    return items.first { $0.section == model.selectedSection } ?? .passwords
  }

  private var selectedIndex: CGFloat {
    CGFloat(items.firstIndex(of: selectedItem) ?? 0)
  }

  private func selectionWidth(in width: CGFloat) -> CGFloat {
    contentWidth(in: width) / CGFloat(items.count)
  }

  private func selectionHeight(in height: CGFloat) -> CGFloat {
    max(0, height - (NexusTokens.bottomTabInnerPadding * 2))
  }

  private func selectionDynamicWidth(in width: CGFloat) -> CGFloat {
    selectionWidth(in: width) * (isDragging ? NexusTokens.bottomTabDragSelectionWidthScale : 1)
  }

  private func selectionDynamicHeight(in height: CGFloat) -> CGFloat {
    selectionHeight(in: height) * (isDragging ? NexusTokens.bottomTabDragSelectionHeightScale : 1)
  }

  private func selectionOffsetX(in width: CGFloat) -> CGFloat {
    selectionCenterX(in: width) - (selectionDynamicWidth(in: width) / 2)
  }

  private func selectionOffsetY(in height: CGFloat) -> CGFloat {
    NexusTokens.bottomTabInnerPadding - ((selectionDynamicHeight(in: height) - selectionHeight(in: height)) / 2)
  }

  private func selectionCenterX(in width: CGFloat) -> CGFloat {
    if let dragSelectionCenterX {
      return clampedDragCenter(dragSelectionCenterX, width: width)
    }
    return NexusTokens.bottomTabInnerPadding + (selectionWidth(in: width) * (selectedIndex + 0.5))
  }

  private func contentWidth(in width: CGFloat) -> CGFloat {
    max(0, width - (NexusTokens.bottomTabInnerPadding * 2))
  }

  private func clampedDragCenter(_ x: CGFloat, width: CGFloat) -> CGFloat {
    let halfSelection = selectionWidth(in: width) / 2
    let lowerBound = NexusTokens.bottomTabInnerPadding + halfSelection
    let upperBound = width - NexusTokens.bottomTabInnerPadding - halfSelection
    return min(max(x, lowerBound), upperBound)
  }

  private func item(at x: CGFloat, width: CGFloat) -> NexusBottomTabItem {
    let contentX = min(max(x - NexusTokens.bottomTabInnerPadding, 0), contentWidth(in: width))
    let rawIndex = contentX / max(selectionWidth(in: width), 1)
    let index = min(max(Int(rawIndex), 0), items.count - 1)
    return items[index]
  }

  private func tabDragGesture(width: CGFloat) -> some Gesture {
    DragGesture(minimumDistance: NexusTokens.bottomTabDragMinimumDistance, coordinateSpace: .local)
      .onChanged { value in
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
          dragSelectionCenterX = clampedDragCenter(value.location.x, width: width)
        }
      }
      .onEnded { value in
        let finalItem = item(at: value.location.x, width: width)
        withAnimation(NexusMotion.tab) {
          open(finalItem)
          dragSelectionCenterX = nil
        }
      }
  }
}

struct NexusBottomTabButton: View {
  let item: NexusBottomTabItem
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      NexusBottomTabItemContent(item: item)
    }
    .buttonStyle(.plain)
    .foregroundStyle(NexusTokens.strong)
    .accessibilityLabel(item.title)
  }
}

struct NexusBottomTabItemContent: View {
  let item: NexusBottomTabItem

  var body: some View {
    VStack(spacing: NexusTokens.bottomTabItemGap) {
      tabIcon
        .frame(width: NexusTokens.bottomTabIconSize, height: NexusTokens.bottomTabIconSize)

      Text(item.title)
        .font(NexusTokens.bottomTabLabelFont)
        .lineLimit(1)
        .minimumScaleFactor(0.75)
    }
    .offset(y: NexusTokens.bottomTabContentOffsetY)
    .padding(.vertical, NexusTokens.bottomTabSelectedVerticalPadding)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentShape(Rectangle())
  }

  @ViewBuilder
  private var tabIcon: some View {
    if let iconPath = item.iconPath {
      NexusAssetIcon(path: iconPath, selected: false, size: NexusTokens.bottomTabIconSize)
    } else {
      NexusBottomSettingsIcon()
    }
  }
}

struct NexusBottomTabSelectionGlass: View {
  let namespace: Namespace.ID

  var body: some View {
    fallback
  }

  private var fallback: some View {
    Color.white.opacity(0.01)
      .background(.ultraThinMaterial, in: Capsule())
      .background(Color.white.opacity(NexusTokens.liquidGlassSelectedFallbackOpacity), in: Capsule())
      .overlay(Capsule().stroke(NexusTokens.liquidGlassStroke, lineWidth: NexusTokens.liquidGlassStrokeWidth))
      .matchedGeometryEffect(id: "bottom-tab-selection-frame", in: namespace)
      .shadow(
        color: NexusTokens.liquidGlassShadow,
        radius: NexusTokens.liquidGlassShadowRadius,
        y: NexusTokens.liquidGlassShadowYOffset
      )
  }
}

struct NexusBottomSettingsIcon: View {
  var body: some View {
    NexusAccountSVGIconGlyph()
      .stroke(style: StrokeStyle(
        lineWidth: NexusTokens.bottomTabSettingsIconStrokeWidth,
        lineCap: .round,
        lineJoin: .round
      ))
      .scaleEffect(NexusTokens.bottomTabSettingsIconVisualScale)
  }
}

struct NexusAccountSVGIconGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let side = min(rect.width, rect.height)
    let origin = CGPoint(x: rect.midX - side / 2, y: rect.midY - side / 2)
    let scale = side / 24

    func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
      CGPoint(x: origin.x + x * scale, y: origin.y + y * scale)
    }

    func circleRect(centerX: CGFloat, centerY: CGFloat, radius: CGFloat) -> CGRect {
      CGRect(
        x: origin.x + (centerX - radius) * scale,
        y: origin.y + (centerY - radius) * scale,
        width: radius * 2 * scale,
        height: radius * 2 * scale
      )
    }

    var path = Path()
    path.addEllipse(in: circleRect(centerX: 12, centerY: 12, radius: 9.5))
    path.addEllipse(in: circleRect(centerX: 12, centerY: 9.25, radius: 3.15))
    path.move(to: point(5.85, 19.15))
    path.addCurve(
      to: point(12, 14.13),
      control1: point(7.3, 15.8),
      control2: point(9.4, 14.13)
    )
    path.addCurve(
      to: point(18.15, 19.15),
      control1: point(14.6, 14.13),
      control2: point(16.7, 15.8)
    )
    return path
  }
}

struct NexusSearchLine: View {
  @Binding var text: String

  var body: some View {
    HStack(spacing: NexusTokens.tableCellGap) {
      Image(systemName: "magnifyingglass")
        .font(NexusFont.regular(NexusTokens.searchGlassIconSize))
        .foregroundStyle(NexusTokens.strong.opacity(0.78))
      TextField("Search", text: $text)
        #if os(iOS)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        #endif
        .textFieldStyle(.plain)
        .font(NexusTokens.inputFont)
        .foregroundStyle(NexusTokens.strong)
        .submitLabel(.search)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, NexusTokens.searchGlassHorizontalPadding)
    .frame(height: NexusTokens.searchGlassHeight)
    .nexusLiquidGlassCapsule(interactive: true)
  }
}

enum NexusTableVariant {
  case passwords
  case apiKeys
  case cards
  case subscriptions

  var headerBackground: Color {
    switch self {
    case .passwords:
      return NexusTokens.tableHeaderPassword
    case .cards:
      return .clear
    default:
      return NexusTokens.tableHeader
    }
  }

  var slabBackground: Color {
    switch self {
    case .passwords:
      return NexusTokens.passwordPanel
    case .apiKeys:
      return Color.white
    case .cards:
      return .clear
    case .subscriptions:
      return .clear
    }
  }

  var rowBackground: Color {
    switch self {
    case .cards:
      return NexusTokens.cardPanel
    case .subscriptions:
      return Color.white.opacity(0.84)
    case .passwords:
      return NexusTokens.passwordPanel
    case .apiKeys:
      return NexusTokens.panel
    }
  }
}

struct NexusToolbarMetric: View {
  let metric: NexusMetricItem

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 10) {
        Rectangle()
          .fill(NexusTokens.strong)
          .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
        Text(metric.label)
          .font(NexusTokens.popupMetricTagFont)
          .tracking(2.2)
          .foregroundStyle(NexusTokens.muted)
      }
      Text(metric.value)
        .font(NexusTokens.popupMetricValueFont)
        .lineSpacing(0)
        .fixedSize(horizontal: true, vertical: true)
        .padding(.trailing, NexusTokens.metricValueBleedPadding)
        .padding(.vertical, NexusTokens.metricValueVerticalPadding)
        .foregroundStyle(NexusTokens.strong)
    }
    .accessibilityElement(children: .combine)
  }
}

struct NexusPasswordsMetricStrip: View {
  let metrics: [NexusMetricItem]
  let compact: Bool

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top, spacing: compact ? NexusTokens.metricCompactGap : 52) {
        ForEach(metrics) { metric in
          VStack(alignment: .leading, spacing: 10) {
            Rectangle()
              .fill(NexusTokens.strong)
              .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
            Text(metric.label)
              .font(NexusTokens.metricLabelFont)
              .tracking(2.2)
              .foregroundStyle(NexusTokens.muted)
            Text(metric.value)
              .font(compact ? NexusTokens.metricCompactValueFont : NexusTokens.metricValueFont)
              .fixedSize(horizontal: true, vertical: true)
              .padding(.trailing, NexusTokens.metricValueBleedPadding)
              .padding(.vertical, NexusTokens.metricValueVerticalPadding)
              .foregroundStyle(NexusTokens.strong)
          }
          .fixedSize(horizontal: true, vertical: true)
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.bottom, 4)
    }
  }
}

struct NexusMetricStrip: View {
  let metrics: [NexusMetricItem]
  let compact: Bool
  var subscriptions = false

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top, spacing: spacing) {
        ForEach(metrics) { metric in
          VStack(alignment: .leading, spacing: subscriptions ? 10 : 8) {
            Text(metric.label)
              .font(NexusTokens.metricLabelFont)
              .tracking(2.2)
              .foregroundStyle(NexusTokens.muted)
            Text(metric.value)
              .font(compact ? NexusTokens.metricCompactValueFont : NexusTokens.metricValueFont)
              .lineSpacing(0)
              .fixedSize(horizontal: true, vertical: true)
              .padding(.trailing, NexusTokens.metricValueBleedPadding)
              .padding(.vertical, NexusTokens.metricValueVerticalPadding)
              .foregroundStyle(NexusTokens.strong)
          }
          .padding(.leading, subscriptions ? NexusTokens.subscriptionsMetricInset : NexusTokens.metricInset)
          .overlay(alignment: .leading) {
            Rectangle()
              .fill(NexusTokens.strong)
              .frame(width: NexusTokens.metricBorderWidth)
          }
          .fixedSize(horizontal: true, vertical: true)
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.bottom, 4)
    }
  }

  private var spacing: CGFloat {
    if compact { return NexusTokens.metricCompactGap }
    return subscriptions ? NexusTokens.subscriptionsMetricGap : NexusTokens.metricHorizontalGap
  }
}

struct NexusTableShell<Content: View>: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant
  let rowCount: Int
  @ViewBuilder let content: () -> Content

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack(spacing: 0) {
        NexusTableHeaderRow(columns: columns, minWidth: minWidth, variant: variant)
        if rowCount > 0 {
          content()
        } else {
          NexusEmptyTableRow(columns: columns, minWidth: minWidth, label: "NO MATCHES")
        }
      }
      .frame(minWidth: minWidth, alignment: .leading)
      .background(variant.slabBackground)
      .overlay {
        if variant == .apiKeys {
          Rectangle().stroke(NexusTokens.outlineSoft, lineWidth: 1)
        }
      }
    }
  }
}

struct NexusTableHeaderRow: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant

  var body: some View {
    HStack(spacing: 0) {
      ForEach(columns) { column in
        NexusHeaderCell(column: column, columns: columns, minWidth: minWidth, variant: variant)
      }
    }
  }
}

struct NexusHeaderCell: View {
  let column: NexusTableColumn
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant

  var body: some View {
    Text(column.label)
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .textCase(.uppercase)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: column.alignment)
      .padding(.horizontal, NexusTokens.tableCellHorizontalPadding)
      .padding(.vertical, NexusTokens.tableHeaderVerticalPadding)
      .frame(width: cellWidth(column, columns: columns, minWidth: minWidth), alignment: column.alignment)
      .background(variant.headerBackground)
  }
}

struct NexusTableCell<Content: View>: View {
  let column: NexusTableColumn
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let alignment: Alignment
  let verticalPadding: CGFloat
  @ViewBuilder let content: () -> Content

  init(
    column: NexusTableColumn,
    columns: [NexusTableColumn],
    minWidth: CGFloat,
    alignment: Alignment? = nil,
    verticalPadding: CGFloat = NexusTokens.tableCellVerticalPadding,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.column = column
    self.columns = columns
    self.minWidth = minWidth
    self.alignment = alignment ?? column.alignment
    self.verticalPadding = verticalPadding
    self.content = content
  }

  var body: some View {
    content()
      .frame(maxWidth: .infinity, alignment: alignment)
      .padding(.horizontal, NexusTokens.tableCellHorizontalPadding)
      .padding(.vertical, verticalPadding)
      .frame(width: cellWidth(column, columns: columns, minWidth: minWidth), alignment: alignment)
  }
}

struct NexusEmptyTableRow: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let label: String

  var body: some View {
    Text(label)
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .foregroundStyle(NexusTokens.muted)
      .frame(width: minWidth)
      .frame(minHeight: 68)
      .background(NexusTokens.panel)
  }
}

struct NexusPasswordTableRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusPassword
  private let columns = NexusTableColumns.passwords
  private let minWidth = NexusTokens.passwordsTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .passwords) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        NexusPrimaryCell(
          title: clean(row.service),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: row.website,
          fallback: monogram(row.service, row.website, row.username, fallback: "S"),
          defaultSection: .passwords
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.username))
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusKindChipGroup(kinds: row.kinds ?? [])
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth) {
        NexusMaskedCell(clean(row.passwordMask))
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(NexusHost.normalize(row.website).isEmpty ? clean(row.website) : NexusHost.normalize(row.website))
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth, alignment: .trailing) {
        Button {
          model.editPassword(row)
        } label: {
          NexusRowAction()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit password")
      }
    }
  }
}

struct NexusAPIKeyTableRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusAPIKey
  private let columns = NexusTableColumns.apiKeys
  private let minWidth = NexusTokens.apiKeysTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .apiKeys) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        Text(clean(row.keyName))
          .font(NexusTokens.tablePrimaryFont)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusBoxedCell(clean(row.maskedValue ?? row.rawValue))
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusChip(label: compactAPIKeyStatus(row), style: apiKeyStatusChipStyle(row.environment))
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth, alignment: .trailing) {
        Button {
          model.editAPIKey(row)
        } label: {
          NexusRowAction()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit API key")
      }
    }
  }
}

struct NexusCardTableRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusCard
  private let columns = NexusTableColumns.cards
  private let minWidth = NexusTokens.cardsTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .cards) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        NexusPrimaryCell(
          title: clean(row.cardName),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: nil,
          fallback: monogram(row.cardName, row.network, fallback: "C"),
          defaultSection: .cards
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusChip(label: clean(row.network), style: isNoCreditNetwork(row.network) || clean(row.network).uppercased() == "AMEX" ? .ghost : .normal)
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.maskedNumber ?? row.rawCardNumber))
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth) {
        NexusValueCell(cardCredit(row))
          .foregroundStyle(isNoCreditNetwork(row.network) ? Color.black.opacity(0.35) : NexusTokens.strong)
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.expiry))
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth) {
        NexusMaskedCell(clean(row.cvvMask ?? row.rawCvv))
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(nextCardBillingDate(row).map(NexusDate.formatShort) ?? "-")
      }
      NexusTableCell(column: columns[7], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[8], columns: columns, minWidth: minWidth, alignment: .trailing) {
        Button {
          model.editCard(row)
        } label: {
          NexusRowAction()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit card")
      }
    }
  }
}

struct NexusSubscriptionsBoard: View {
  let rows: [NexusRecurring]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack(spacing: NexusTokens.subscriptionsBoardGap) {
        if rows.isEmpty {
          NexusEmptySubscriptionRow()
        } else {
          ForEach(rows) { row in
            NexusSubscriptionBoardRow(row: row)
          }
        }
      }
      .frame(minWidth: NexusTokens.subscriptionsBoardMinWidth, alignment: .leading)
      .padding(.bottom, 4)
    }
    .accessibilityLabel("Subscriptions")
  }
}

struct NexusSubscriptionBoardRow: View {
  @EnvironmentObject private var model: NexusVaultModel
  let row: NexusRecurring
  private let columns = NexusTableColumns.subscriptions
  private let minWidth = NexusTokens.subscriptionsBoardMinWidth

  var body: some View {
    HStack(spacing: NexusTokens.subscriptionsRowGap) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusPrimaryCell(
          title: clean(row.service),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: nil,
          fallback: monogram(row.service, row.tier, fallback: "R"),
          defaultSection: .subscriptions
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.tier), style: clean(row.tier).uppercased() == "FREE TRIAL" ? .ghost : .normal)
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.cadence), style: .normal)
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusValueCell(recurringAmount(row))
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusSecondaryCell(nextSubscriptionBillingDate(row).map(NexusDate.formatShort) ?? "-")
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.status), style: clean(row.status).uppercased() == "ACTIVE" ? .success : .muted)
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[7], columns: columns, minWidth: minWidth, alignment: .trailing, verticalPadding: 0) {
        Button {
          model.editRecurring(row)
        } label: {
          NexusRowAction()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Edit recurring")
      }
    }
    .padding(.horizontal, NexusTokens.subscriptionsRowHorizontalPadding)
    .padding(.vertical, NexusTokens.subscriptionsRowVerticalPadding)
    .frame(minHeight: NexusTokens.tableRowMinHeight)
    .background(Color.white.opacity(0.84))
  }
}

struct NexusEmptySubscriptionRow: View {
  var body: some View {
    Text("NO MATCHES")
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .foregroundStyle(NexusTokens.muted)
      .frame(minWidth: NexusTokens.subscriptionsBoardMinWidth, minHeight: 90)
      .background(Color.white.opacity(0.84))
  }
}

struct NexusBodyRow<Content: View>: View {
  let variant: NexusTableVariant
  @ViewBuilder let content: () -> Content

  var body: some View {
    HStack(spacing: 0) {
      content()
    }
    .frame(minHeight: NexusTokens.tableRowMinHeight)
    .background(variant.rowBackground)
    .overlay(alignment: .top) {
      Rectangle()
        .fill(variant == .cards ? NexusTokens.outlineSoft : NexusTokens.softBorder)
        .frame(height: 1)
    }
  }
}

struct NexusPrimaryCell: View {
  let title: String
  let iconURL: String?
  let iconKey: String?
  let website: String?
  let fallback: String
  var defaultSection: NexusSection? = nil

  var body: some View {
    HStack(spacing: NexusTokens.tableCellGap) {
      NexusIconTile(
        urlString: iconURL,
        iconKey: iconKey,
        website: website,
        fallback: fallback,
        defaultSection: defaultSection
      )
      Text(title)
        .font(NexusTokens.tablePrimaryFont)
        .tracking(-0.45)
        .foregroundStyle(NexusTokens.strong)
        .lineLimit(1)
    }
  }
}

struct NexusIconTile: View {
  let urlString: String?
  let iconKey: String?
  let website: String?
  let fallback: String
  var size = NexusTokens.tableIconSize
  var defaultSection: NexusSection? = nil

  var body: some View {
    ZStack {
      if let url = resolvedIconURL(urlString, iconKey: iconKey, website: website, fallback: fallback) {
        NexusCachedIconWebImage(
          url: url,
          fallback: fallback,
          defaultSection: defaultSection,
          size: size
        )
      } else {
        fallbackView
      }
    }
    .frame(width: size, height: size)
    .clipped()
  }

  @ViewBuilder private var fallbackView: some View {
    if let defaultSection {
      NexusAssetIcon(path: defaultSection.navIconPath, selected: false, size: size)
    } else {
      NexusIconFallback(fallback)
    }
  }
}

struct NexusIconFallback: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusFont.semibold(NexusTokens.tableIconFallbackFontSize))
      .foregroundStyle(NexusTokens.strong)
      .textCase(.uppercase)
  }
}

struct NexusCachedIconWebImage: View {
  let url: URL
  let fallback: String
  let defaultSection: NexusSection?
  let size: CGFloat

  @State private var payload: NexusIconPayload?

  var body: some View {
    ZStack {
      if let payload {
        NexusIconWebImage(imageSource: payload.dataURI, fallback: fallback)
      } else {
        fallbackView
      }
    }
    .task(id: url.absoluteString) {
      await load()
    }
  }

  @ViewBuilder private var fallbackView: some View {
    if let defaultSection {
      NexusAssetIcon(path: defaultSection.navIconPath, selected: false, size: size)
    } else {
      NexusIconFallback(fallback)
    }
  }

  @MainActor
  private func load() async {
    payload = nil
    do {
      payload = try await NexusIconCache.shared.payload(for: url)
    } catch {
      payload = nil
    }
  }
}

struct NexusIconPayload: Equatable {
  let dataURI: String
}

private struct NexusIconCacheMetadata: Codable {
  let mimeType: String
}

actor NexusIconCache {
  static let shared = NexusIconCache()

  private var memory: [String: NexusIconPayload] = [:]
  private var inFlight: [String: Task<NexusIconPayload, Error>] = [:]

  func payload(for url: URL) async throws -> NexusIconPayload {
    let key = cacheKey(for: url)
    if let cached = memory[key] {
      return cached
    }
    if let disk = try diskPayload(for: key) {
      memory[key] = disk
      return disk
    }
    if let task = inFlight[key] {
      return try await task.value
    }

    let task = Task<NexusIconPayload, Error> {
      let payload = try await fetchPayload(for: url, key: key)
      return payload
    }
    inFlight[key] = task
    defer { inFlight[key] = nil }

    let payload = try await task.value
    memory[key] = payload
    return payload
  }

  func prefetch(_ urls: [URL]) async {
    for url in Array(Set(urls)) {
      _ = try? await payload(for: url)
    }
  }

  private func fetchPayload(for url: URL, key: String) async throws -> NexusIconPayload {
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.setValue("image/avif,image/webp,image/svg+xml,image/png,image/jpeg,image/*,*/*;q=0.8", forHTTPHeaderField: "Accept")
    let (data, response) = try await URLSession.shared.data(for: request)
    if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
      throw NexusError.requestFailed("Icon request failed.")
    }
    let mimeType = normalizedIconMimeType(response.mimeType, url: url, data: data)
    try write(data: data, mimeType: mimeType, key: key)
    return NexusIconPayload(dataURI: iconDataURI(data: data, mimeType: mimeType))
  }

  private func diskPayload(for key: String) throws -> NexusIconPayload? {
    let dataURL = cacheDataURL(for: key)
    let metadataURL = cacheMetadataURL(for: key)
    guard
      FileManager.default.fileExists(atPath: dataURL.path),
      let data = try? Data(contentsOf: dataURL)
    else {
      return nil
    }
    let metadata = try? JSONDecoder().decode(
      NexusIconCacheMetadata.self,
      from: Data(contentsOf: metadataURL)
    )
    let mimeType = metadata?.mimeType ?? normalizedIconMimeType(nil, url: nil, data: data)
    return NexusIconPayload(dataURI: iconDataURI(data: data, mimeType: mimeType))
  }

  private func write(data: Data, mimeType: String, key: String) throws {
    try FileManager.default.createDirectory(at: cacheRootURL, withIntermediateDirectories: true)
    try? excludeFromBackup(cacheRootURL)
    try data.write(to: cacheDataURL(for: key), options: [.atomic])
    let metadata = NexusIconCacheMetadata(mimeType: mimeType)
    let metadataData = try JSONEncoder().encode(metadata)
    try metadataData.write(to: cacheMetadataURL(for: key), options: [.atomic])
  }

  private var cacheRootURL: URL {
    let root = NexusEnvironment.appGroup
      .flatMap { FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: $0) }
      ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
      ?? FileManager.default.temporaryDirectory
    return root.appendingPathComponent("NexusIconCache", isDirectory: true)
  }

  private func cacheDataURL(for key: String) -> URL {
    cacheRootURL.appendingPathComponent("\(key).data")
  }

  private func cacheMetadataURL(for key: String) -> URL {
    cacheRootURL.appendingPathComponent("\(key).json")
  }

  private func cacheKey(for url: URL) -> String {
    let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
    return digest.map { String(format: "%02x", $0) }.joined()
  }
}

#if os(iOS)
struct NexusIconWebImage: UIViewRepresentable {
  let imageSource: String
  let fallback: String

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero)
    webView.isOpaque = false
    webView.backgroundColor = .clear
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.isUserInteractionEnabled = false
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    webView.loadHTMLString(iconHTML(forImageSource: imageSource, fallback: fallback), baseURL: Bundle.main.resourceURL)
  }
}
#elseif os(macOS)
struct NexusIconWebImage: NSViewRepresentable {
  let imageSource: String
  let fallback: String

  func makeNSView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero)
    webView.setValue(false, forKey: "drawsBackground")
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {
    webView.loadHTMLString(iconHTML(forImageSource: imageSource, fallback: fallback), baseURL: Bundle.main.resourceURL)
  }
}
#endif

private func iconHTML(forImageSource imageSource: String, fallback: String) -> String {
  """
  <!doctype html>
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <style>
        @font-face {
          font-family: "OpenAISans-Semibold";
          src: url("openai-sans-v2-semibold.ttf") format("truetype");
          font-weight: 600;
          font-style: normal;
        }
        html, body {
          width: 100%;
          height: 100%;
          margin: 0;
          overflow: hidden;
          background: transparent;
        }
        img {
          display: block;
          width: 100%;
          height: 100%;
          object-fit: contain;
        }
        .fallback {
          position: absolute;
          inset: 0;
          display: grid;
          place-items: center;
          color: #0a0a0a;
          font: \(Int(NexusTokens.tableIconFallbackFontWeight)) \(cssPixels(NexusTokens.tableIconFallbackFontSize)) "OpenAISans-Semibold", sans-serif;
          text-transform: uppercase;
        }
      </style>
    </head>
    <body>
      <div class="fallback" id="fallback">\(htmlTextEscaped(fallback))</div>
      <img
        alt=""
        src="\(htmlAttributeEscaped(imageSource))"
        onload="document.getElementById('fallback').style.display='none'"
        onerror="this.style.display='none'"
      />
    </body>
  </html>
  """
}

private func iconDataURI(data: Data, mimeType: String) -> String {
  "data:\(mimeType);base64,\(data.base64EncodedString())"
}

private func excludeFromBackup(_ url: URL) throws {
  var mutableURL = url
  var values = URLResourceValues()
  values.isExcludedFromBackup = true
  try mutableURL.setResourceValues(values)
}

private func normalizedIconMimeType(_ value: String?, url: URL?, data: Data) -> String {
  let raw = String(value ?? "")
    .split(separator: ";", maxSplits: 1)
    .first
    .map(String.init)?
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .lowercased() ?? ""
  if raw.hasPrefix("image/") {
    return raw
  }
  if let extensionMimeType = iconMimeType(fromExtension: url?.pathExtension) {
    return extensionMimeType
  }
  return iconMimeType(fromData: data)
}

private func iconMimeType(fromExtension value: String?) -> String? {
  switch String(value ?? "").lowercased() {
  case "svg": return "image/svg+xml"
  case "png": return "image/png"
  case "jpg", "jpeg": return "image/jpeg"
  case "webp": return "image/webp"
  case "gif": return "image/gif"
  default: return nil
  }
}

private func iconMimeType(fromData data: Data) -> String {
  if data.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
    return "image/png"
  }
  if data.starts(with: [0xFF, 0xD8, 0xFF]) {
    return "image/jpeg"
  }
  if data.starts(with: [0x47, 0x49, 0x46]) {
    return "image/gif"
  }
  let prefix = String(data: data.prefix(128), encoding: .utf8)?.lowercased() ?? ""
  if prefix.contains("<svg") {
    return "image/svg+xml"
  }
  return "image/png"
}

private func cssPixels(_ value: CGFloat) -> String {
  "\(Int(value.rounded()))px"
}

private func htmlTextEscaped(_ value: String) -> String {
  value
    .replacingOccurrences(of: "&", with: "&amp;")
    .replacingOccurrences(of: "<", with: "&lt;")
    .replacingOccurrences(of: ">", with: "&gt;")
}

private func htmlAttributeEscaped(_ value: String) -> String {
  value
    .replacingOccurrences(of: "&", with: "&amp;")
    .replacingOccurrences(of: "\"", with: "&quot;")
    .replacingOccurrences(of: "<", with: "&lt;")
    .replacingOccurrences(of: ">", with: "&gt;")
}

struct NexusKindChipGroup: View {
  let kinds: [String]

  var body: some View {
    HStack(spacing: 4) {
      if kinds.isEmpty {
        NexusSecondaryCell("-")
      } else {
        ForEach(kinds, id: \.self) { kind in
          let normalized = clean(kind).uppercased()
          NexusChip(
            label: normalized == "OTP" ? "ONE-TIME-CODE" : normalized,
            style: normalized == "OTP" ? .muted : .normal
          )
        }
      }
    }
  }
}

enum NexusChipStyle {
  case normal
  case muted
  case ghost
  case success
}

private let statusOptionStyles: [String: NexusChipStyle] = [
  "ACTIVE": .success,
  "INACTIVE": .muted
]

struct NexusChip: View {
  let label: String
  let style: NexusChipStyle

  var body: some View {
    Text(label)
      .font(NexusTokens.chipFont)
      .tracking(NexusTokens.chipTracking)
      .lineLimit(1)
      .padding(.horizontal, NexusTokens.chipPaddingInline)
      .frame(minHeight: NexusTokens.chipMinHeight)
      .foregroundStyle(foreground)
      .background(background)
  }

  private var foreground: Color {
    switch style {
    case .success:
      return NexusTokens.statusSuccess
    case .muted, .ghost:
      return NexusTokens.muted
    case .normal:
      return NexusTokens.strong
    }
  }

  private var background: Color {
    switch style {
    case .success:
      return NexusTokens.statusSuccessTint
    case .ghost:
      return Color.clear
    case .muted:
      return NexusTokens.mutedPanel.opacity(0.7)
    case .normal:
      return NexusTokens.mutedPanel
    }
  }
}

struct NexusSecondaryCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tableSecondaryFont)
      .tracking(0.28)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
  }
}

struct NexusValueCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tablePrimaryFont)
      .foregroundStyle(NexusTokens.strong)
      .lineLimit(1)
  }
}

struct NexusMaskedCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tablePrimaryFont)
      .tracking(1.8)
      .foregroundStyle(NexusTokens.strong)
      .lineLimit(1)
  }
}

struct NexusBoxedCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tableMonoFont)
      .tracking(0.25)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
      .padding(.horizontal, NexusTokens.boxedCellHorizontalPadding)
      .frame(height: NexusTokens.boxedCellHeight)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(NexusTokens.mutedPanel)
  }
}

struct NexusRowAction: View {
  var body: some View {
    Image(systemName: "ellipsis.vertical")
      .font(NexusFont.regular(16))
      .foregroundStyle(NexusTokens.strong)
      .frame(width: NexusTokens.markerSize * 4, height: NexusTokens.markerSize * 4)
  }
}

private func cellWidth(_ column: NexusTableColumn, columns: [NexusTableColumn], minWidth: CGFloat) -> CGFloat {
  let total = columns.reduce(CGFloat.zero) { $0 + $1.weight }
  guard total > 0 else { return minWidth / CGFloat(max(columns.count, 1)) }
  return minWidth * column.weight / total
}

private func monogram(_ values: String?..., fallback: String) -> String {
  for value in values {
    let normalized = emptyToBlank(value)
    if let first = normalized.first {
      return String(first).uppercased()
    }
  }
  return fallback
}

private func nexusIconURLs(from snapshot: NexusVaultSnapshot) -> [URL] {
  let passwordURLs = snapshot.passwords.compactMap { row in
    resolvedIconURL(
      row.resolvedIconUrl,
      iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
      website: row.website,
      fallback: monogram(row.service, row.website, row.username, fallback: "S")
    )
  }
  let cardURLs = snapshot.cards.compactMap { row in
    resolvedIconURL(
      row.resolvedIconUrl,
      iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
      website: nil,
      fallback: monogram(row.cardName, row.network, fallback: "C")
    )
  }
  let subscriptionURLs = snapshot.subscriptions.compactMap { row in
    resolvedIconURL(
      row.resolvedIconUrl,
      iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
      website: nil,
      fallback: monogram(row.service, row.tier, fallback: "R")
    )
  }
  return passwordURLs + cardURLs + subscriptionURLs
}

private func resolvedIconURL(_ value: String?, iconKey: String?, website: String?, fallback: String) -> URL? {
  let raw = emptyToBlank(value)
  if !raw.isEmpty {
    if raw.hasPrefix("http://") || raw.hasPrefix("https://") {
      return URL(string: raw)
    }
    if raw.hasPrefix("/") {
      return nexusAPIURL(path: raw, fallback: fallback)
    }
    if raw.contains("/") {
      return nexusAPIURL(path: raw, fallback: fallback)
    }
    return nexusAPIURL(path: "/api/site-icons/\(percentEncodePathComponent(raw))", fallback: fallback)
  }
  let key = firstNonEmpty(iconKey, NexusHost.normalize(website))
  guard !key.isEmpty else { return nil }
  return nexusAPIURL(path: "/api/site-icons/\(percentEncodePathComponent(key))", fallback: fallback)
}

private func nexusAPIURL(path: String, fallback: String) -> URL? {
  var normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
  if normalizedPath.hasPrefix("/nexus/api/") {
    normalizedPath.removeFirst("/nexus".count)
  }
  var queryItems: [URLQueryItem] = []
  if !fallback.isEmpty {
    queryItems.append(URLQueryItem(name: "fallback", value: fallback))
  }
  var components = URLComponents(string: NexusEnvironment.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + normalizedPath)
  components?.queryItems = queryItems.isEmpty ? nil : queryItems
  return components?.url
}

private func nexusAssetURL(path: String) -> URL? {
  var normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
  if normalizedPath.hasPrefix("/nexus/") {
    normalizedPath.removeFirst("/nexus".count)
  }
  return URL(string: NexusEnvironment.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + normalizedPath)
}

private func percentEncodePathComponent(_ value: String) -> String {
  var allowed = CharacterSet.urlPathAllowed
  allowed.remove(charactersIn: "/?#[]@!$&'()*+,;=")
  return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}

private func firstNonEmpty(_ values: String?...) -> String {
  for value in values {
    let normalized = emptyToBlank(value)
    if !normalized.isEmpty {
      return normalized
    }
  }
  return ""
}

private func passwordMatchesSearch(_ row: NexusPassword, query: String) -> Bool {
  matchesSearch(
    [
      row.service,
      row.username,
      row.website,
      NexusWebsiteList.entries(row.website).joined(separator: " "),
      row.note,
      row.kinds?.joined(separator: " "),
      passwordCredentialMode(row.kinds)
    ],
    query: query
  )
}

private func apiKeyMatchesSearch(_ row: NexusAPIKey, query: String) -> Bool {
  matchesSearch(
    [
      row.keyName,
      row.rawValue,
      row.maskedValue,
      row.environment,
      compactAPIKeyStatus(row),
      row.note
    ],
    query: query
  )
}

private func cardMatchesSearch(_ row: NexusCard, query: String) -> Bool {
  matchesSearch(
    [
      row.cardName,
      row.network,
      row.maskedNumber,
      row.rawCardNumber,
      row.expiry,
      row.cvvMask,
      row.rawCvv,
      row.pinMask,
      row.rawPin,
      row.billingAnchorDate,
      row.creditCurrency,
      decimalInputString(row.creditLimit, digits: 2),
      cardCredit(row),
      row.note
    ],
    query: query
  )
}

private func recurringMatchesSearch(_ row: NexusRecurring, query: String) -> Bool {
  matchesSearch(
    [
      row.service,
      row.tier,
      row.cadence,
      row.status,
      compactRecurringStatus(row),
      row.amountCurrency,
      decimalInputString(row.amount, digits: 2),
      recurringAmount(row),
      row.billingAnchorDate,
      nextSubscriptionBillingDate(row).map(NexusDate.formatShort),
      row.note
    ],
    query: query
  )
}

private func matchesSearch(_ values: [String?], query: String) -> Bool {
  values.contains { normalizedSearchQuery($0 ?? "").contains(query) }
}

private func normalizedSearchQuery(_ value: String) -> String {
  clean(value)
    .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    .lowercased()
}

private func compactPasswordMetricLabel(_ value: String) -> String {
  value
}

private func metricLineCount(_ value: String) -> Int {
  max(1, value.split(separator: "\n", omittingEmptySubsequences: false).count)
}

private func compactMetricValueFont(_ value: String) -> Font {
  let lineCount = metricLineCount(value)
  let longestLine = value.split(separator: "\n", omittingEmptySubsequences: false).map(\.count).max() ?? value.count
  if lineCount >= 3 {
    return NexusTokens.compactPasswordMetricValueFontDense
  }
  if lineCount == 2 {
    if longestLine >= 9 {
      return NexusTokens.compactPasswordMetricValueFontExtraWide
    }
    return NexusTokens.compactPasswordMetricValueFontTwoLine
  }
  if longestLine >= 9 {
    return NexusTokens.compactPasswordMetricValueFontExtraWide
  }
  if longestLine >= 7 {
    return NexusTokens.compactPasswordMetricValueFontWide
  }
  return NexusTokens.compactPasswordMetricValueFont
}

private func passwordCredentialMode(_ kinds: [String]?) -> String {
  let normalized = Set((kinds ?? []).map { clean($0).uppercased() })
  if normalized.contains("2FA") || normalized.contains("OTP") {
    return "ONE-TIME-CODE"
  }
  return "PASSWORD"
}

private func compactPasswordService(_ value: String?) -> String {
  let normalized = clean(value)
  return normalized.isEmpty ? "NO SERVICE" : normalized
}

private func compactPasswordUsername(_ value: String?) -> String {
  let normalized = clean(value)
  return normalized.isEmpty ? "NO USERNAME" : normalized
}

private func compactPasswordMask(_ row: NexusPassword) -> String {
  let mask = clean(row.passwordMask)
  if !mask.isEmpty {
    return mask
  }
  return clean(row.rawSecret).isEmpty ? "-" : "********"
}

private func maskedEditorValue(_ value: String) -> String {
  let normalized = clean(value)
  guard !normalized.isEmpty else { return "" }
  let count = max(NexusTokens.editorMaskMinLength, min(NexusTokens.editorMaskMaxLength, normalized.count))
  return String(repeating: "*", count: count)
}

private func nexusAppVersionText() -> String {
  let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
  let normalizedVersion = clean(version)
  let normalizedBuild = clean(build)
  if normalizedVersion.isEmpty {
    return normalizedBuild.isEmpty ? "-" : normalizedBuild
  }
  return normalizedBuild.isEmpty ? normalizedVersion : "\(normalizedVersion) (\(normalizedBuild))"
}

private func nexusFeedbackURL() -> URL {
  URL(string: "mailto:zjz.novembre@gmail.com?subject=Nexus%20Feedback")!
}

private func nexusHelpURL() -> URL {
  URL(string: "https://zjz.world/nexus")!
}

private func nexusPrivacyURL() -> URL {
  URL(string: "https://zjz.world/privacy")!
}

private func compactAPIKeyValue(_ row: NexusAPIKey) -> String {
  let masked = clean(row.maskedValue)
  if !masked.isEmpty {
    return masked
  }
  let raw = clean(row.rawValue)
  return raw.isEmpty ? "-" : raw
}

private func compactAPIKeyName(_ row: NexusAPIKey) -> String {
  let normalized = clean(row.keyName)
  return normalized.isEmpty ? "NO KEY" : normalized
}

private func compactAPIKeyStatus(_ row: NexusAPIKey) -> String {
  normalizedAPIKeyEnvironment(row.environment)
}

private func normalizedAPIKeyEnvironment(_ value: String?) -> String {
  let normalized = emptyToBlank(value).uppercased()
  return normalized == "RETIRE" || normalized == "RETIRED" || normalized == "INTERNAL" || normalized == "INACTIVE" ? "INACTIVE" : "ACTIVE"
}

private func apiKeyStatusChipStyle(_ value: String?) -> NexusChipStyle {
  normalizedAPIKeyEnvironment(value) == "ACTIVE" ? .success : .muted
}

private func compactCardName(_ card: NexusCard) -> String {
  let normalized = clean(card.cardName)
  return normalized.isEmpty ? "NO CARD" : normalized
}

private func compactCardNetwork(_ card: NexusCard) -> String {
  let normalized = clean(card.network)
  return normalized.isEmpty ? "-" : normalized
}

private func compactCardNetworkStyle(_ card: NexusCard) -> NexusChipStyle {
  let normalized = clean(card.network).uppercased()
  return isNoCreditNetwork(normalized) || normalized == "AMEX" ? .ghost : .normal
}

private func compactCardNumber(_ card: NexusCard) -> String {
  let masked = clean(card.maskedNumber)
  if !masked.isEmpty {
    return masked
  }
  let raw = clean(card.rawCardNumber)
  return raw.isEmpty ? "-" : raw
}

private func compactCardExpiry(_ card: NexusCard) -> String {
  let normalized = clean(card.expiry)
  return normalized.isEmpty ? "-" : normalized
}

private func compactCardSecurity(_ card: NexusCard) -> String {
  let masked = clean(card.cvvMask)
  if !masked.isEmpty {
    return masked
  }
  let raw = clean(card.rawCvv)
  return raw.isEmpty ? "***" : raw
}

private func compactRecurringService(_ recurring: NexusRecurring) -> String {
  let normalized = clean(recurring.service)
  return normalized.isEmpty ? "NO SERVICE" : normalized
}

private func compactRecurringTier(_ recurring: NexusRecurring) -> String {
  let normalized = clean(recurring.tier)
  return normalized.isEmpty ? "-" : normalized
}

private func compactRecurringTierStyle(_ recurring: NexusRecurring) -> NexusChipStyle {
  .normal
}

private func compactRecurringCadence(_ recurring: NexusRecurring) -> String {
  let normalized = clean(recurring.cadence)
  return normalized.isEmpty ? "-" : normalized
}

private func compactRecurringAmount(_ recurring: NexusRecurring) -> String {
  recurringAmount(recurring)
}

private func compactRecurringNextBilling(_ recurring: NexusRecurring) -> String {
  nextSubscriptionBillingDate(recurring).map(NexusDate.formatShort) ?? "-"
}

private func compactRecurringStatus(_ recurring: NexusRecurring) -> String {
  normalizedRecurringStatus(recurring.status)
}

private func recurringStatusChipStyle(_ value: String?) -> NexusChipStyle {
  normalizedRecurringStatus(value) == "ACTIVE" ? .success : .muted
}

private func normalizedRecurringStatus(_ value: String?) -> String {
  let status = emptyToBlank(value).uppercased()
  return status.isEmpty ? "ACTIVE" : status
}

private func compactPasswordWebsite(_ value: String?) -> String {
  let raw = NexusWebsiteList.primary(value)
  guard !raw.isEmpty else { return "-" }
  return raw
    .replacingOccurrences(of: #"^https?://"#, with: "", options: .regularExpression)
    .replacingOccurrences(of: #"/+$"#, with: "", options: .regularExpression)
}

private func externalWebsiteURL(_ value: String?) -> URL? {
  let raw = NexusWebsiteList.primary(value)
  guard !raw.isEmpty else { return nil }
  let candidate = raw.contains("://") ? raw : "https://\(raw)"
  guard
    let url = URL(string: candidate),
    let scheme = url.scheme?.lowercased(),
    scheme == "http" || scheme == "https"
  else {
    return nil
  }
  return url
}

private func nexusPageURL(for section: NexusSection) -> URL? {
  let root = NexusEnvironment.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
  return URL(string: "\(root)/#/\(section.resourceId)")
}

private func cardCredit(_ card: NexusCard) -> String {
  guard !isNoCreditNetwork(card.network) else { return "-" }
  return NexusCurrency.format(card.creditLimit ?? 0, currency: card.creditCurrency ?? "USD", digits: 0)
}

private func recurringAmount(_ recurring: NexusRecurring) -> String {
  NexusCurrency.format(recurring.amount ?? 0, currency: recurring.amountCurrency ?? "USD", digits: 2)
}

struct NexusNavButton: View {
  let section: NexusSection
  let selected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: NexusTokens.navItemGap) {
        NexusAssetIcon(path: section.navIconPath, selected: selected, size: NexusTokens.navIconSize)
        Text(section.title)
          .font(NexusFont.bold(12))
          .tracking(2.4)
          .lineLimit(1)
          .minimumScaleFactor(0.82)
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 14)
      .frame(maxWidth: .infinity, alignment: .leading)
      .frame(height: NexusTokens.control)
    }
    .buttonStyle(.plain)
    .foregroundStyle(selected ? Color.white : NexusTokens.muted)
    .background(selected ? NexusTokens.strong : Color.clear)
    .clipShape(RoundedRectangle(cornerRadius: NexusTokens.corner))
  }
}

struct NexusAssetIcon: View {
  let path: String
  var selected = false
  let size: CGFloat

  var body: some View {
    Group {
      if let url = nexusAssetURL(path: path) {
        AsyncImage(url: url) { phase in
          if let image = phase.image {
            assetImage(image)
          } else {
            Color.clear
          }
        }
      } else {
        Color.clear
      }
    }
    .frame(width: size, height: size)
  }

  @ViewBuilder
  private func assetImage(_ image: Image) -> some View {
    let icon = image
      .resizable()
      .aspectRatio(contentMode: .fit)
    if selected {
      icon.colorInvert()
    } else {
      icon
    }
  }
}

struct NexusButton: View {
  enum Variant {
    case primary
    case secondary
  }

  let title: String
  let variant: Variant
  let width: CGFloat?
  let action: () -> Void

  init(_ title: String, variant: Variant = .secondary, width: CGFloat? = nil, action: @escaping () -> Void) {
    self.title = title
    self.variant = variant
    self.width = width
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(NexusFont.bold(11.5))
        .tracking(2.2)
        .textCase(.uppercase)
        .frame(minHeight: NexusTokens.control)
        .padding(.horizontal, 16)
    }
    .buttonStyle(.plain)
    .frame(width: width)
    .foregroundStyle(variant == .primary ? Color.white : NexusTokens.strong)
    .background(variant == .primary ? NexusTokens.strong : Color.clear)
    .overlay(RoundedRectangle(cornerRadius: NexusTokens.corner).stroke(NexusTokens.strong, lineWidth: 1))
    .clipShape(RoundedRectangle(cornerRadius: NexusTokens.corner))
  }
}

struct NexusSquareButton: View {
  enum Variant {
    case primary
    case secondary
  }

  enum ToolbarIcon {
    case add
    case account
  }

  var systemName: String?
  var iconPath: String?
  var toolbarIcon: ToolbarIcon?
  var variant: Variant
  let action: () -> Void

  init(systemName: String, variant: Variant = .secondary, action: @escaping () -> Void) {
    self.systemName = systemName
    self.iconPath = nil
    self.toolbarIcon = nil
    self.variant = variant
    self.action = action
  }

  init(iconPath: String, variant: Variant = .secondary, action: @escaping () -> Void) {
    self.systemName = nil
    self.iconPath = iconPath
    self.toolbarIcon = nil
    self.variant = variant
    self.action = action
  }

  init(toolbarIcon: ToolbarIcon, variant: Variant = .secondary, action: @escaping () -> Void) {
    self.systemName = nil
    self.iconPath = nil
    self.toolbarIcon = toolbarIcon
    self.variant = variant
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      Group {
        if let toolbarIcon {
          NexusToolbarIcon(kind: toolbarIcon)
            .frame(width: NexusTokens.toolbarGlassIconSize, height: NexusTokens.toolbarGlassIconSize)
        } else if let iconPath {
          NexusAssetIcon(path: iconPath, selected: false, size: NexusTokens.buttonSymbolSize)
        } else if let systemName {
          Image(systemName: systemName)
            .font(NexusFont.bold(NexusTokens.buttonSymbolSize * 0.72))
        }
      }
      .frame(width: buttonSize, height: buttonSize)
    }
    .buttonStyle(.plain)
    .foregroundStyle(toolbarIcon == nil && variant == .primary ? Color.white : toolbarIcon == nil ? NexusTokens.strong : NexusTokens.toolbarIconColor)
    .background {
      if toolbarIcon == nil && variant == .primary {
        NexusTokens.strong
      }
    }
    .overlay {
      if toolbarIcon == nil {
        Rectangle().stroke(NexusTokens.strong, lineWidth: 1)
      }
    }
    .modifier(NexusToolbarButtonGlassModifier(isToolbarIcon: toolbarIcon != nil))
  }

  private var buttonSize: CGFloat {
    toolbarIcon == nil ? NexusTokens.control : NexusTokens.toolbarGlassButtonSize
  }
}

private struct NexusToolbarButtonGlassModifier: ViewModifier {
  let isToolbarIcon: Bool

  @ViewBuilder
  func body(content: Content) -> some View {
    if isToolbarIcon {
      content
        .nexusLiquidGlassCircle(interactive: true)
    } else {
      content
    }
  }
}

struct NexusToolbarIcon: View {
  let kind: NexusSquareButton.ToolbarIcon

  var body: some View {
    ZStack {
      templateIcon
      ForEach(weightOffsets.indices, id: \.self) { index in
        let offset = weightOffsets[index]
        templateIcon
          .offset(x: offset.width, y: offset.height)
      }
    }
    .foregroundStyle(NexusTokens.toolbarIconColor)
  }

  @ViewBuilder private var templateIcon: some View {
    Group {
      #if os(iOS)
      if let path = Bundle.main.path(forResource: imageName, ofType: "png"),
        let image = UIImage(contentsOfFile: path) {
        Image(uiImage: image)
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
      } else {
        fallbackIcon
      }
      #elseif os(macOS)
      if let path = Bundle.main.path(forResource: imageName, ofType: "png"),
        let image = NSImage(contentsOfFile: path) {
        Image(nsImage: image)
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
      } else {
        fallbackIcon
      }
      #else
      fallbackIcon
      #endif
    }
  }

  private var weightOffsets: [CGSize] {
    guard kind == .account else { return [] }
    let offset = NexusTokens.toolbarAccountWeightOffset
    guard offset > 0 else { return [] }
    return [
      CGSize(width: offset, height: 0),
      CGSize(width: -offset, height: 0),
      CGSize(width: 0, height: offset),
      CGSize(width: 0, height: -offset)
    ]
  }

  private var imageName: String {
    switch kind {
    case .add:
      return NexusTokens.toolbarAddImageName
    case .account:
      return NexusTokens.toolbarUserImageName
    }
  }

  @ViewBuilder private var fallbackIcon: some View {
    switch kind {
    case .add:
      NexusAddToolbarGlyph()
        .stroke(style: toolbarStroke)
    case .account:
      NexusAccountToolbarGlyph()
        .stroke(style: toolbarStroke)
    }
  }

  private var toolbarStroke: StrokeStyle {
    StrokeStyle(
      lineWidth: NexusTokens.toolbarIconStrokeWidth,
      lineCap: .round,
      lineJoin: .round
    )
  }
}

struct NexusAddToolbarGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let inset = NexusTokens.toolbarIconInset
    let iconRect = rect.insetBy(dx: inset, dy: inset)
    let corner = iconRect.width * 0.222
    var path = Path()
    path.addRoundedRect(in: iconRect, cornerSize: CGSize(width: corner, height: corner))
    path.move(to: CGPoint(x: iconRect.midX, y: iconRect.minY + iconRect.height * 0.231))
    path.addLine(to: CGPoint(x: iconRect.midX, y: iconRect.maxY - iconRect.height * 0.231))
    path.move(to: CGPoint(x: iconRect.minX + iconRect.width * 0.231, y: iconRect.midY))
    path.addLine(to: CGPoint(x: iconRect.maxX - iconRect.width * 0.231, y: iconRect.midY))
    return path
  }
}

struct NexusAccountToolbarGlyph: Shape {
  func path(in rect: CGRect) -> Path {
    let inset = NexusTokens.toolbarIconInset
    let iconRect = rect.insetBy(dx: inset, dy: inset)
    let center = CGPoint(x: iconRect.midX, y: iconRect.midY)
    let headRadius = iconRect.width * 0.131
    var path = Path()
    path.addEllipse(in: iconRect)
    path.addEllipse(in: CGRect(
      x: center.x - headRadius,
      y: iconRect.minY + iconRect.height * 0.385 - headRadius,
      width: headRadius * 2,
      height: headRadius * 2
    ))
    path.move(to: CGPoint(x: iconRect.minX + iconRect.width * 0.244, y: iconRect.minY + iconRect.height * 0.798))
    path.addQuadCurve(
      to: CGPoint(x: center.x, y: iconRect.minY + iconRect.height * 0.589),
      control: CGPoint(x: iconRect.minX + iconRect.width * 0.366, y: iconRect.minY + iconRect.height * 0.658)
    )
    path.addQuadCurve(
      to: CGPoint(x: iconRect.maxX - iconRect.width * 0.244, y: iconRect.minY + iconRect.height * 0.798),
      control: CGPoint(x: iconRect.maxX - iconRect.width * 0.366, y: iconRect.minY + iconRect.height * 0.658)
    )
    return path
  }
}

struct NexusInput: View {
  let title: String
  @Binding var text: String

  init(_ title: String, text: Binding<String>) {
    self.title = title
    self._text = text
  }

  var body: some View {
    TextField(title, text: $text)
      .textFieldStyle(.plain)
      .font(NexusTokens.inputFont)
      .padding(.horizontal, 14)
      .frame(width: 320, height: NexusTokens.control)
      .background(Color.white.opacity(0.86))
      .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
  }
}

struct NexusSecureInput: View {
  let title: String
  @Binding var text: String

  init(_ title: String, text: Binding<String>) {
    self.title = title
    self._text = text
  }

  var body: some View {
    SecureField(title, text: $text)
      .textFieldStyle(.plain)
      .font(NexusTokens.inputFont)
      .padding(.horizontal, 14)
      .frame(width: 320, height: NexusTokens.control)
      .background(Color.white.opacity(0.86))
      .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
  }
}

struct NexusLoggedOutField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    labeledField {
      TextField("", text: $text)
        #if os(iOS)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        #endif
    }
  }

  private func labeledField<Field: View>(@ViewBuilder field: () -> Field) -> some View {
    ZStack(alignment: .topLeading) {
      Text(title)
        .font(NexusTokens.labelFont)
        .tracking(2.2)
        .textCase(.uppercase)
        .foregroundStyle(NexusTokens.muted)
        .offset(y: -(NexusTokens.modalLabelOffset + 10))
      field()
        .textFieldStyle(.plain)
        .font(NexusTokens.inputFont)
        .padding(.horizontal, NexusTokens.loggedOutFieldPadding)
        .frame(width: width, height: NexusTokens.control)
        .background(Color.white.opacity(0.84))
        .overlay(Rectangle().stroke(Color.black.opacity(0.14), lineWidth: 1))
    }
    .frame(width: width, height: NexusTokens.control, alignment: .topLeading)
  }
}

struct NexusLoggedOutSecureField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      Text(title)
        .font(NexusTokens.labelFont)
        .tracking(2.2)
        .textCase(.uppercase)
        .foregroundStyle(NexusTokens.muted)
        .offset(y: -(NexusTokens.modalLabelOffset + 10))
      SecureField("", text: $text)
        .textFieldStyle(.plain)
        .font(NexusTokens.inputFont)
        .padding(.horizontal, NexusTokens.loggedOutFieldPadding)
        .frame(width: width, height: NexusTokens.control)
        .background(Color.white.opacity(0.84))
        .overlay(Rectangle().stroke(Color.black.opacity(0.14), lineWidth: 1))
    }
    .frame(width: width, height: NexusTokens.control, alignment: .topLeading)
  }
}

struct NexusBlueprintBackground: View {
  var body: some View {
    Canvas { context, size in
      var path = Path()
      let horizontalOrigin = centeredGridOrigin(length: size.width)
      var x = horizontalOrigin
      while x <= size.width {
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: size.height))
        x += NexusTokens.grid
      }
      var y: CGFloat = 0
      while y <= size.height {
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: size.width, y: y))
        y += NexusTokens.grid
      }
      context.stroke(path, with: .color(Color(red: 0.906, green: 0.906, blue: 0.906)), lineWidth: 1)
    }
    .background(NexusTokens.base)
    .ignoresSafeArea()
  }
}

private func centeredGridOrigin(length: CGFloat) -> CGFloat {
  let center = length / 2
  let stepsToStart = ceil(center / NexusTokens.grid)
  return center - (stepsToStart * NexusTokens.grid)
}

struct NexusAutoFillPickerView: View {
  let credentials: [NexusCachedCredential]
  let select: (NexusCachedCredential) -> Void

  var body: some View {
    VStack(spacing: NexusTokens.seam) {
      ForEach(credentials) { credential in
        Button {
          select(credential)
        } label: {
          HStack {
            VStack(alignment: .leading, spacing: 3) {
              Text(credential.service)
                .font(NexusFont.semibold(15))
              Text(credential.username)
                .font(NexusTokens.inputFont)
                .foregroundStyle(NexusTokens.muted)
            }
            Spacer()
            Text(credential.host)
              .font(NexusTokens.inputFont)
              .foregroundStyle(NexusTokens.muted)
          }
          .padding(.horizontal, 14)
          .frame(minHeight: 54)
          .background(NexusTokens.panel)
          .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
      }
    }
    .padding(NexusTokens.gutter)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(NexusTokens.base)
  }
}

enum NexusRouteStore {
  private static let pendingKey = "pending-section"

  static func savePendingSection(_ section: NexusSection) {
    defaults.set(section.rawValue, forKey: pendingKey)
  }

  static func consumePendingSection() -> NexusSection? {
    guard let raw = defaults.string(forKey: pendingKey), let section = NexusSection(rawValue: raw) else {
      return nil
    }
    defaults.removeObject(forKey: pendingKey)
    return section
  }

  static func section(from url: URL) -> NexusSection? {
    if url.scheme == "nexus", url.host == "section" {
      return NexusSection(rawValue: url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }
    return nil
  }

  private static var defaults: UserDefaults {
    if let appGroup = NexusEnvironment.appGroup, let groupDefaults = UserDefaults(suiteName: appGroup) {
      return groupDefaults
    }
    return .standard
  }
}

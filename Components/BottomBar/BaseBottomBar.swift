//
//  BaseBottomBar.swift
//  BaseLibrary
//
//  Created by BaseLibrary contributors.
//

import UIKit

public enum BaseBottomBarItemRole {
    case tab
    case action
}

public enum BaseBottomBarGlassStyle {
    case regular
    case clear
}

public enum BaseBottomBarGlassFallback {
    case systemUltraThinMaterial
    case systemThinMaterial
    case systemMaterial
    case systemThickMaterial
    case solid(UIColor)
}

public struct BaseBottomBarItem {
    public var image: UIImage
    public var selectedImage: UIImage?
    public var title: String?
    public var accessibilityLabel: String?
    public var badgeValue: String?
    public var role: BaseBottomBarItemRole
    public var isEnabled: Bool

    public init(
        image: UIImage,
        selectedImage: UIImage? = nil,
        title: String? = nil,
        accessibilityLabel: String? = nil,
        badgeValue: String? = nil,
        role: BaseBottomBarItemRole = .tab,
        isEnabled: Bool = true
    ) {
        self.image = image
        self.selectedImage = selectedImage
        self.title = title
        self.accessibilityLabel = accessibilityLabel
        self.badgeValue = badgeValue
        self.role = role
        self.isEnabled = isEnabled
    }
}

public enum BaseBottomBarBackgroundStyle {
    case flat(cornerRadius: CGFloat)
    case floating(horizontalInset: CGFloat, cornerRadius: CGFloat)
    case notched(notchDiameter: CGFloat, cornerRadius: CGFloat)
    case liquidGlass(
        horizontalInset: CGFloat = 16,
        cornerRadius: CGFloat = 28,
        style: BaseBottomBarGlassStyle = .regular,
        tintColor: UIColor? = nil,
        isInteractive: Bool = true,
        fallback: BaseBottomBarGlassFallback = .systemMaterial
    )
}

public enum BaseBottomBarIndicatorStyle {
    case none
    case circle(diameter: CGFloat)
    case pill(size: CGSize)
    case underline(width: CGFloat, height: CGFloat)
}

public enum BaseBottomBarSelectionAnimation {
    case none
    case ease(duration: TimeInterval)
    case fade(duration: TimeInterval)
    case spring(duration: TimeInterval, dampingRatio: CGFloat)
    case bounce(duration: TimeInterval)
    case toss
}

public enum BaseBottomBarHapticFeedback {
    case none
    case selection
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
}

public struct BaseBottomBarAppearance {
    public var backgroundStyle: BaseBottomBarBackgroundStyle
    public var indicatorStyle: BaseBottomBarIndicatorStyle
    public var backgroundColor: UIColor
    public var indicatorColor: UIColor
    public var selectedItemColor: UIColor
    public var normalItemColor: UIColor
    public var disabledItemColor: UIColor
    public var badgeBackgroundColor: UIColor
    public var badgeTextColor: UIColor
    public var titleFont: UIFont
    public var iconSize: CGSize
    public var rendersImagesAsTemplate: Bool
    public var showsTitles: Bool
    public var contentInsets: UIEdgeInsets
    public var actionItemVerticalOffset: CGFloat
    public var shadowColor: UIColor
    public var shadowOpacity: Float
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize

    public init(
        backgroundStyle: BaseBottomBarBackgroundStyle = .notched(
            notchDiameter: 64,
            cornerRadius: 0
        ),
        indicatorStyle: BaseBottomBarIndicatorStyle = .circle(diameter: 48),
        backgroundColor: UIColor = .white,
        indicatorColor: UIColor = .systemPink,
        selectedItemColor: UIColor = .white,
        normalItemColor: UIColor = .label,
        disabledItemColor: UIColor = .tertiaryLabel,
        badgeBackgroundColor: UIColor = .systemRed,
        badgeTextColor: UIColor = .white,
        titleFont: UIFont = .systemFont(ofSize: 10, weight: .medium),
        iconSize: CGSize = CGSize(width: 24, height: 24),
        rendersImagesAsTemplate: Bool = true,
        showsTitles: Bool = false,
        contentInsets: UIEdgeInsets = .zero,
        actionItemVerticalOffset: CGFloat = -12,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.12,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGSize = CGSize(width: 0, height: -2)
    ) {
        self.backgroundStyle = backgroundStyle
        self.indicatorStyle = indicatorStyle
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
        self.selectedItemColor = selectedItemColor
        self.normalItemColor = normalItemColor
        self.disabledItemColor = disabledItemColor
        self.badgeBackgroundColor = badgeBackgroundColor
        self.badgeTextColor = badgeTextColor
        self.titleFont = titleFont
        self.iconSize = iconSize
        self.rendersImagesAsTemplate = rendersImagesAsTemplate
        self.showsTitles = showsTitles
        self.contentInsets = contentInsets
        self.actionItemVerticalOffset = actionItemVerticalOffset
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
}

public struct BaseBottomBarConfiguration {
    public var appearance: BaseBottomBarAppearance
    public var selectionAnimation: BaseBottomBarSelectionAnimation
    public var hapticFeedback: BaseBottomBarHapticFeedback
    public var animationsEnabled: Bool
    public var automaticallyHonorsReduceMotion: Bool
    public var allowsReselection: Bool

    public init(
        appearance: BaseBottomBarAppearance = .init(),
        selectionAnimation: BaseBottomBarSelectionAnimation = .spring(
            duration: 0.45,
            dampingRatio: 0.72
        ),
        hapticFeedback: BaseBottomBarHapticFeedback = .selection,
        animationsEnabled: Bool = true,
        automaticallyHonorsReduceMotion: Bool = true,
        allowsReselection: Bool = true
    ) {
        self.appearance = appearance
        self.selectionAnimation = selectionAnimation
        self.hapticFeedback = hapticFeedback
        self.animationsEnabled = animationsEnabled
        self.automaticallyHonorsReduceMotion = automaticallyHonorsReduceMotion
        self.allowsReselection = allowsReselection
    }
}

public extension BaseBottomBarConfiguration {
    static func toss(
        backgroundColor: UIColor = .white,
        indicatorColor: UIColor = UIColor(
            red: 0.7529411765,
            green: 0.4470588235,
            blue: 0.5960784314,
            alpha: 1
        ),
        selectedItemColor: UIColor = .white,
        normalItemColor: UIColor = .black,
        showsTitles: Bool = false
    ) -> BaseBottomBarConfiguration {
        BaseBottomBarConfiguration(
            appearance: BaseBottomBarAppearance(
                backgroundStyle: .notched(
                    notchDiameter: 64,
                    cornerRadius: 0
                ),
                indicatorStyle: .circle(diameter: 48),
                backgroundColor: backgroundColor,
                indicatorColor: indicatorColor,
                selectedItemColor: selectedItemColor,
                normalItemColor: normalItemColor,
                showsTitles: showsTitles,
                shadowOpacity: 0
            ),
            selectionAnimation: .toss,
            hapticFeedback: .none,
            allowsReselection: true
        )
    }
}

extension BaseBottomBarConfiguration {
    var usesAMTossStyle: Bool {
        guard case .toss = selectionAnimation,
              case .notched = appearance.backgroundStyle,
              case .circle = appearance.indicatorStyle else {
            return false
        }
        return true
    }
}

@MainActor
public protocol BaseBottomBarDelegate: AnyObject {
    func baseBottomBar(
        _ bottomBar: BaseBottomBar,
        shouldSelectItemAt index: Int
    ) -> Bool
    func baseBottomBar(_ bottomBar: BaseBottomBar, didSelectItemAt index: Int)
    func baseBottomBar(_ bottomBar: BaseBottomBar, didReselectItemAt index: Int)
    func baseBottomBar(_ bottomBar: BaseBottomBar, didTriggerActionAt index: Int)
}

public extension BaseBottomBarDelegate {
    func baseBottomBar(
        _ bottomBar: BaseBottomBar,
        shouldSelectItemAt index: Int
    ) -> Bool {
        true
    }

    func baseBottomBar(_ bottomBar: BaseBottomBar, didSelectItemAt index: Int) {}
    func baseBottomBar(_ bottomBar: BaseBottomBar, didReselectItemAt index: Int) {}
    func baseBottomBar(_ bottomBar: BaseBottomBar, didTriggerActionAt index: Int) {}
}

public final class BaseBottomBar: UIControl {
    public weak var delegate: BaseBottomBarDelegate?

    public var configuration: BaseBottomBarConfiguration = .init() {
        didSet {
            applyAppearance()
            setNeedsLayout()
        }
    }

    public private(set) var items: [BaseBottomBarItem] = []
    public private(set) var selectedIndex: Int?

    private let backgroundLayer = CAShapeLayer()
    private let glassBackgroundView = UIVisualEffectView()
    private let indicatorView = UIView()
    private let stackView = UIStackView()
    private var itemButtons: [BaseBottomBarItemButton] = []
    private var activeAnimator: UIViewPropertyAnimator?
    private var reduceTransparencyObserver: NSObjectProtocol?
    private var hasLaidOutContent = false
    private var tossAnimationGeneration = 0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    deinit {
        activeAnimator?.stopAnimation(true)
        if let reduceTransparencyObserver {
            NotificationCenter.default.removeObserver(reduceTransparencyObserver)
        }
    }

    public func setItems(_ items: [BaseBottomBarItem], selectedIndex: Int? = nil) {
        activeAnimator?.stopAnimation(true)
        activeAnimator = nil
        self.items = items
        self.selectedIndex = resolvedInitialSelection(requestedIndex: selectedIndex)
        rebuildButtons()
        applyAppearance()
        setNeedsLayout()
    }

    @discardableResult
    public func selectItem(at index: Int, animated: Bool = true) -> Bool {
        guard isSelectableTab(at: index) else { return false }
        guard selectedIndex != index else { return true }

        selectedIndex = index
        updateSelection(animated: animated)
        return true
    }

    @discardableResult
    public func setItemEnabled(_ isEnabled: Bool, at index: Int) -> Bool {
        guard items.indices.contains(index) else { return false }

        if selectedIndex == index, !isEnabled {
            let replacement = items.indices.first { candidateIndex in
                candidateIndex != index
                    && isSelectableTab(at: candidateIndex)
                    && (delegate?.baseBottomBar(
                        self,
                        shouldSelectItemAt: candidateIndex
                    ) ?? true)
            }
            guard let replacement else { return false }

            items[index].isEnabled = false
            itemButtons[index].isEnabled = false
            itemButtons[index].item = items[index]
            itemButtons[index].apply(appearance: configuration.appearance)
            selectedIndex = replacement
            updateSelection(animated: false)
            delegate?.baseBottomBar(self, didSelectItemAt: replacement)
            return true
        }

        items[index].isEnabled = isEnabled
        itemButtons[index].isEnabled = isEnabled
        itemButtons[index].item = items[index]
        itemButtons[index].apply(appearance: configuration.appearance)
        return true
    }

    @discardableResult
    public func setBadge(_ value: String?, at index: Int) -> Bool {
        guard items.indices.contains(index) else { return false }
        items[index].badgeValue = value
        itemButtons[index].item = items[index]
        itemButtons[index].apply(appearance: configuration.appearance)
        return true
    }

    @discardableResult
    public func updateItem(_ item: BaseBottomBarItem, at index: Int) -> Bool {
        guard items.indices.contains(index) else { return false }
        let oldItem = items[index]
        items[index] = item
        itemButtons[index].item = item
        itemButtons[index].isEnabled = item.isEnabled
        itemButtons[index].apply(appearance: configuration.appearance)

        if selectedIndex == index, !isSelectableTab(at: index) {
            let replacement = items.indices.first { candidateIndex in
                candidateIndex != index
                    && isSelectableTab(at: candidateIndex)
                    && (delegate?.baseBottomBar(
                        self,
                        shouldSelectItemAt: candidateIndex
                    ) ?? true)
            }
            guard let replacement else {
                items[index] = oldItem
                itemButtons[index].item = oldItem
                itemButtons[index].isEnabled = oldItem.isEnabled
                itemButtons[index].apply(appearance: configuration.appearance)
                return false
            }
            selectedIndex = replacement
            updateSelection(animated: false)
            delegate?.baseBottomBar(self, didSelectItemAt: replacement)
            return true
        }
        updateSelection(animated: false)
        return true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0, bounds.height > 0 else { return }

        stackView.frame = contentFrame()
        stackView.layoutIfNeeded()

        let layoutAppearance = resolvedItemAppearance()
        itemButtons.forEach { $0.apply(appearance: layoutAppearance) }

        glassBackgroundView.frame = backgroundContentFrame()
        glassBackgroundView.layer.cornerRadius = backgroundCornerRadius

        let destinationIndicatorFrame = indicatorFrame(for: selectedIndex)
        itemButtons.enumerated().forEach { index, button in
            var iconVerticalOffset = button.item.role == .action
                ? configuration.appearance.actionItemVerticalOffset
                : 0

            if configuration.usesAMTossStyle,
               index == selectedIndex,
               button.item.role == .tab {
                iconVerticalOffset = -(layoutAppearance.iconSize.height / 8)
                    - button.defaultIconMinY
            } else if index == selectedIndex,
               button.item.role == .tab,
               case .circle = configuration.appearance.indicatorStyle {
                let indicatorCenter = convert(
                    CGPoint(
                        x: destinationIndicatorFrame.midX,
                        y: destinationIndicatorFrame.midY
                    ),
                    to: button
                )
                iconVerticalOffset = indicatorCenter.y - button.defaultIconCenterY
            }

            button.iconVerticalOffset = iconVerticalOffset
            button.setNeedsLayout()
            button.layoutIfNeeded()
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let backgroundPath = makeBackgroundPath().cgPath
        backgroundLayer.frame = bounds
        backgroundLayer.path = backgroundPath
        backgroundLayer.shadowPath = backgroundPath
        CATransaction.commit()

        indicatorView.frame = destinationIndicatorFrame
        configureIndicatorShape()
        hasLaidOutContent = true
    }

    private func setUpView() {
        backgroundColor = .clear
        clipsToBounds = false
        isAccessibilityElement = false

        backgroundLayer.name = "BaseLibrary.BaseBottomBar.background"
        // AMTabView's two-phase toss path contains overlapping subpaths.
        // Non-zero filling keeps the bar opaque while it flattens; even-odd
        // would cancel the overlap and briefly reveal the view underneath.
        backgroundLayer.fillRule = .nonZero
        layer.addSublayer(backgroundLayer)

        glassBackgroundView.isHidden = true
        glassBackgroundView.isUserInteractionEnabled = false
        glassBackgroundView.clipsToBounds = true
        glassBackgroundView.layer.cornerCurve = .continuous
        glassBackgroundView.accessibilityIdentifier =
            "BaseLibrary.BaseBottomBar.liquidGlass"
        addSubview(glassBackgroundView)

        indicatorView.isUserInteractionEnabled = false
        indicatorView.accessibilityIdentifier = "BaseLibrary.BaseBottomBar.indicator"
        addSubview(indicatorView)

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)

        reduceTransparencyObserver = NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.applyAppearance()
        }
        applyAppearance()
    }

    private func rebuildButtons() {
        itemButtons.forEach { button in
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }

        itemButtons = items.enumerated().map { index, item in
            let button = BaseBottomBarItemButton(item: item)
            button.tag = index
            button.accessibilityIdentifier = "BaseLibrary.BaseBottomBar.item.\(index)"
            button.isEnabled = item.isEnabled
            button.addTarget(self, action: #selector(didTapItem(_:)), for: .touchUpInside)
            button.apply(appearance: configuration.appearance)
            stackView.addArrangedSubview(button)
            return button
        }
        refreshButtonSelectionState()
    }

    private func applyAppearance() {
        let appearance = configuration.appearance
        backgroundLayer.fillColor = isLiquidGlassBackground
            ? UIColor.clear.cgColor
            : appearance.backgroundColor.cgColor
        backgroundLayer.shadowColor = appearance.shadowColor.cgColor
        backgroundLayer.shadowOpacity = appearance.shadowOpacity
        backgroundLayer.shadowRadius = max(0, appearance.shadowRadius)
        backgroundLayer.shadowOffset = appearance.shadowOffset
        configureGlassBackground()
        indicatorView.backgroundColor = appearance.indicatorColor
        itemButtons.forEach { $0.apply(appearance: appearance) }
        refreshButtonSelectionState()
    }

    @objc
    private func didTapItem(_ sender: BaseBottomBarItemButton) {
        handleItemTap(at: sender.tag)
    }

    func handleItemTap(at index: Int) {
        guard items.indices.contains(index), items[index].isEnabled else { return }
        let sender = itemButtons[index]

        performHapticFeedback()
        if items[index].role == .action {
            animateActionButton(sender)
            delegate?.baseBottomBar(self, didTriggerActionAt: index)
            return
        }

        guard delegate?.baseBottomBar(self, shouldSelectItemAt: index) ?? true else {
            animateRejectedSelection(sender)
            return
        }

        if selectedIndex == index {
            guard configuration.allowsReselection else { return }
            animateReselection(sender)
            delegate?.baseBottomBar(self, didReselectItemAt: index)
            return
        }

        selectedIndex = index
        updateSelection(animated: true)
        delegate?.baseBottomBar(self, didSelectItemAt: index)
    }

    private func updateSelection(animated: Bool) {
        let presentedIndicatorFrame = indicatorView.layer.presentation()?.frame
        let presentedBackgroundPath = backgroundLayer.presentation()?.path
        let oldIconVerticalOffsets = itemButtons.map(\.iconVerticalOffset)
        activeAnimator?.stopAnimation(true)
        activeAnimator = nil
        indicatorView.layer.removeAllAnimations()
        indicatorView.transform = .identity

        let oldIndicatorFrame = presentedIndicatorFrame ?? indicatorView.frame
        let oldBackgroundPath = presentedBackgroundPath ?? backgroundLayer.path
        tossAnimationGeneration += 1
        backgroundLayer.removeAllAnimations()
        refreshButtonSelectionState()
        setNeedsLayout()

        guard shouldAnimate(requested: animated), hasLaidOutContent else {
            layoutIfNeeded()
            indicatorView.alpha = indicatorVisibility
            return
        }

        layoutIfNeeded()
        let destinationFrame = indicatorView.frame
        let destinationPath = backgroundLayer.path
        indicatorView.frame = oldIndicatorFrame
        itemButtons.enumerated().forEach { index, button in
            button.prepareIconTransition(
                fromVerticalOffset: oldIconVerticalOffsets[index]
            )
        }

        switch configuration.selectionAnimation {
        case .none:
            indicatorView.frame = destinationFrame
            indicatorView.alpha = indicatorVisibility

        case let .ease(duration):
            animateIndicator(
                duration: duration,
                curve: .easeInOut,
                destinationFrame: destinationFrame
            )

        case let .fade(duration):
            indicatorView.alpha = 0
            indicatorView.frame = destinationFrame
            let animator = UIViewPropertyAnimator(
                duration: clampedDuration(duration),
                curve: .easeInOut
            ) {
                self.indicatorView.alpha = self.indicatorVisibility
                self.finishIconTransitions()
            }
            activeAnimator = animator
            animator.startAnimation()

        case let .spring(duration, dampingRatio):
            let timing = UISpringTimingParameters(
                dampingRatio: min(max(dampingRatio, 0.05), 1)
            )
            let animator = UIViewPropertyAnimator(
                duration: clampedDuration(duration),
                timingParameters: timing
            )
            animator.addAnimations {
                self.indicatorView.frame = destinationFrame
                self.indicatorView.alpha = self.indicatorVisibility
                self.finishIconTransitions()
            }
            activeAnimator = animator
            animator.startAnimation()

        case let .bounce(duration):
            indicatorView.frame = destinationFrame
            indicatorView.alpha = indicatorVisibility
            UIView.animateKeyframes(
                withDuration: clampedDuration(duration),
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]
            ) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.55) {
                    self.indicatorView.transform = CGAffineTransform(scaleX: 1.18, y: 0.82)
                    self.finishIconTransitions()
                }
                UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                    self.indicatorView.transform = .identity
                }
            }

        case .toss:
            animateTossIndicator(
                from: oldIndicatorFrame,
                destinationFrame: destinationFrame
            )
        }

        if configuration.usesAMTossStyle {
            animateTossBackground(
                from: oldBackgroundPath,
                to: destinationPath
            )
        } else {
            animateBackgroundPath(
                from: oldBackgroundPath,
                to: destinationPath,
                duration: animationDuration
            )
        }
    }

    private func animateIndicator(
        duration: TimeInterval,
        curve: UIView.AnimationCurve,
        destinationFrame: CGRect
    ) {
        let animator = UIViewPropertyAnimator(
            duration: clampedDuration(duration),
            curve: curve
        ) {
            self.indicatorView.frame = destinationFrame
            self.indicatorView.alpha = self.indicatorVisibility
            self.finishIconTransitions()
        }
        activeAnimator = animator
        animator.startAnimation()
    }

    private func animateTossIndicator(
        from startFrame: CGRect,
        destinationFrame: CGRect
    ) {
        let path = BaseBottomBarTossEngine.ballPath(
            fromX: startFrame.midX,
            toX: destinationFrame.midX,
            in: bounds,
            numberOfTabs: items.count
        )

        indicatorView.frame = destinationFrame
        indicatorView.alpha = indicatorVisibility
        let animation = CAKeyframeAnimation(
            keyPath: #keyPath(CALayer.position)
        )
        animation.path = path
        animation.duration = BaseBottomBarTossEngine.ballDuration
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .easeOut)
        ]
        indicatorView.layer.add(
            animation,
            forKey: "BaseLibrary.BottomBar.toss.ball"
        )

        UIView.animate(
            withDuration: BaseBottomBarTossEngine.tintAndIconDuration,
            delay: 0,
            options: [.beginFromCurrentState, .allowUserInteraction]
        ) {
            self.finishIconTransitions()
        }
    }

    private func finishIconTransitions() {
        itemButtons.forEach { $0.finishIconTransition() }
    }

    private func animateTossBackground(
        from oldPath: CGPath?,
        to destinationPath: CGPath?
    ) {
        guard let oldPath, let destinationPath else { return }
        let rectanglePath = BaseBottomBarTossEngine.fullRectangle(in: bounds)
        let animationGeneration = tossAnimationGeneration

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self,
                  self.tossAnimationGeneration == animationGeneration else {
                return
            }
            let revealAnimation = CABasicAnimation(
                keyPath: #keyPath(CAShapeLayer.path)
            )
            revealAnimation.fromValue = rectanglePath
            revealAnimation.toValue = destinationPath
            revealAnimation.fillMode = .both
            revealAnimation.isRemovedOnCompletion = false
            revealAnimation.duration = BaseBottomBarTossEngine.shapePhaseDuration
            self.backgroundLayer.add(
                revealAnimation,
                forKey: "BaseLibrary.BottomBar.toss.background"
            )
        }

        let flattenAnimation = CABasicAnimation(
            keyPath: #keyPath(CAShapeLayer.path)
        )
        flattenAnimation.fromValue = oldPath
        flattenAnimation.toValue = rectanglePath
        flattenAnimation.fillMode = .both
        flattenAnimation.isRemovedOnCompletion = false
        flattenAnimation.duration = BaseBottomBarTossEngine.shapePhaseDuration
        backgroundLayer.add(
            flattenAnimation,
            forKey: "BaseLibrary.BottomBar.toss.background"
        )
        CATransaction.commit()
    }

    private func animateBackgroundPath(
        from oldPath: CGPath?,
        to newPath: CGPath?,
        duration: TimeInterval
    ) {
        guard let oldPath, let newPath, duration > 0 else { return }
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.fromValue = oldPath
        animation.toValue = newPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        backgroundLayer.add(animation, forKey: "BaseLibrary.BottomBar.background")
    }

    private func refreshButtonSelectionState() {
        itemButtons.enumerated().forEach { index, button in
            button.isSelected = selectedIndex == index && items[index].role == .tab
            button.apply(appearance: configuration.appearance)
        }
    }

    private func resolvedInitialSelection(requestedIndex: Int?) -> Int? {
        if let requestedIndex, isSelectableTab(at: requestedIndex) {
            return requestedIndex
        }
        return items.indices.first(where: isSelectableTab(at:))
    }

    private func isSelectableTab(at index: Int) -> Bool {
        items.indices.contains(index)
            && items[index].role == .tab
            && items[index].isEnabled
    }

    private func resolvedItemAppearance() -> BaseBottomBarAppearance {
        var appearance = configuration.appearance
        guard configuration.usesAMTossStyle else { return appearance }

        let iconSize = BaseBottomBarTossEngine.metrics(
            in: bounds,
            numberOfTabs: items.count
        ).iconSize
        appearance.iconSize = CGSize(width: iconSize, height: iconSize)
        return appearance
    }

    private func contentFrame() -> CGRect {
        let insets = configuration.appearance.contentInsets
        var frame = bounds.inset(by: insets)
        switch configuration.appearance.backgroundStyle {
        case let .floating(horizontalInset, _),
             let .liquidGlass(horizontalInset, _, _, _, _, _):
            frame = frame.insetBy(dx: max(0, horizontalInset), dy: 0)
        case .flat, .notched:
            break
        }
        return frame
    }

    private func backgroundContentFrame() -> CGRect {
        switch configuration.appearance.backgroundStyle {
        case let .floating(horizontalInset, _),
             let .liquidGlass(horizontalInset, _, _, _, _, _):
            return bounds.insetBy(dx: max(0, horizontalInset), dy: 0)
        case .flat, .notched:
            return bounds
        }
    }

    private var backgroundCornerRadius: CGFloat {
        switch configuration.appearance.backgroundStyle {
        case let .flat(cornerRadius),
             let .floating(_, cornerRadius),
             let .notched(_, cornerRadius),
             let .liquidGlass(_, cornerRadius, _, _, _, _):
            return max(0, cornerRadius)
        }
    }

    private func makeBackgroundPath() -> UIBezierPath {
        let appearance = configuration.appearance
        let path: UIBezierPath

        switch appearance.backgroundStyle {
        case let .flat(cornerRadius):
            path = makeBottomAttachedPath(cornerRadius: cornerRadius)

        case let .floating(horizontalInset, cornerRadius):
            let rect = bounds.insetBy(dx: max(0, horizontalInset), dy: 0)
            path = UIBezierPath(
                roundedRect: rect,
                cornerRadius: max(0, cornerRadius)
            )

        case let .liquidGlass(horizontalInset, cornerRadius, _, _, _, _):
            let rect = bounds.insetBy(dx: max(0, horizontalInset), dy: 0)
            path = UIBezierPath(
                roundedRect: rect,
                cornerRadius: max(0, cornerRadius)
            )

        case let .notched(notchDiameter, cornerRadius):
            path = makeNotchedPath(
                notchDiameter: notchDiameter,
                cornerRadius: cornerRadius
            )
        }
        return path
    }

    private func makeBottomAttachedPath(cornerRadius: CGFloat) -> UIBezierPath {
        let radius = resolvedTopCornerRadius(cornerRadius)
        return UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
    }

    private func makeNotchedPath(
        notchDiameter: CGFloat,
        cornerRadius: CGFloat
    ) -> UIBezierPath {
        if configuration.usesAMTossStyle, let selectedIndex {
            return UIBezierPath(
                cgPath: BaseBottomBarTossEngine.notchPath(
                    selectedIndex: selectedIndex,
                    in: bounds,
                    numberOfTabs: items.count
                )
            )
        }

        guard bounds.width > 0, bounds.height > 0,
              let itemCenterX = selectedItemCenterX(),
              notchDiameter > 0 else {
            return makeBottomAttachedPath(cornerRadius: cornerRadius)
        }

        let radius = resolvedTopCornerRadius(cornerRadius)
        let centerX = min(max(itemCenterX, radius), bounds.width - radius)
        let diameter = min(max(0, notchDiameter), bounds.width)
        let selectedIndicatorFrame = indicatorFrame(for: selectedIndex)
        let desiredHalfWidth = max(
            diameter * 0.78,
            selectedIndicatorFrame.width * 0.95
        )
        let notchStartX = max(radius, centerX - desiredHalfWidth)
        let notchEndX = min(bounds.width - radius, centerX + desiredHalfWidth)
        let leftSpan = max(0, centerX - notchStartX)
        let rightSpan = max(0, notchEndX - centerX)
        let notchDepth = min(
            bounds.height * 0.72,
            max(diameter * 0.52, selectedIndicatorFrame.maxY + 5)
        )

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addQuadCurve(
            to: CGPoint(x: radius, y: 0),
            controlPoint: .zero
        )
        path.addLine(to: CGPoint(x: notchStartX, y: 0))
        path.addCurve(
            to: CGPoint(x: centerX, y: notchDepth),
            controlPoint1: CGPoint(
                x: notchStartX + leftSpan * 0.38,
                y: 0
            ),
            controlPoint2: CGPoint(
                x: centerX - leftSpan * 0.42,
                y: notchDepth
            )
        )
        path.addCurve(
            to: CGPoint(x: notchEndX, y: 0),
            controlPoint1: CGPoint(
                x: centerX + rightSpan * 0.42,
                y: notchDepth
            ),
            controlPoint2: CGPoint(
                x: notchEndX - rightSpan * 0.38,
                y: 0
            )
        )
        path.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: bounds.width, y: radius),
            controlPoint: CGPoint(x: bounds.width, y: 0)
        )
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.close()
        return path
    }

    private func resolvedTopCornerRadius(_ requestedRadius: CGFloat) -> CGFloat {
        min(
            max(0, requestedRadius),
            bounds.width / 2,
            bounds.height / 2
        )
    }

    private var isLiquidGlassBackground: Bool {
        if case .liquidGlass = configuration.appearance.backgroundStyle {
            return true
        }
        return false
    }

    private func configureGlassBackground() {
        guard case let .liquidGlass(
            _,
            _,
            style,
            tintColor,
            isInteractive,
            fallback
        ) = configuration.appearance.backgroundStyle else {
            glassBackgroundView.isHidden = true
            glassBackgroundView.effect = nil
            glassBackgroundView.backgroundColor = .clear
            glassBackgroundView.contentView.backgroundColor = .clear
            return
        }

        glassBackgroundView.isHidden = false
        glassBackgroundView.backgroundColor = .clear
        glassBackgroundView.contentView.backgroundColor = .clear

        #if compiler(>=6.2)
            if #available(iOS 26.0, *) {
                glassBackgroundView.effect = makeGlassEffect(
                    style: style,
                    tintColor: tintColor,
                    isInteractive: isInteractive
                )
                return
            }
        #endif

        configureGlassFallback(fallback, tintColor: tintColor)
    }

    #if compiler(>=6.2)
    @available(iOS 26.0, *)
    private func makeGlassEffect(
        style: BaseBottomBarGlassStyle,
        tintColor: UIColor?,
        isInteractive: Bool
    ) -> UIGlassEffect {
        let systemStyle: UIGlassEffect.Style
        switch style {
        case .regular:
            systemStyle = .regular
        case .clear:
            systemStyle = .clear
        }

        let effect = UIGlassEffect(style: systemStyle)
        effect.tintColor = tintColor
        effect.isInteractive = isInteractive
        return effect
    }
    #endif

    private func configureGlassFallback(
        _ fallback: BaseBottomBarGlassFallback,
        tintColor: UIColor?
    ) {
        if UIAccessibility.isReduceTransparencyEnabled {
            glassBackgroundView.effect = nil
            glassBackgroundView.backgroundColor = reducedTransparencyColor(
                for: fallback,
                tintColor: tintColor
            )
            return
        }

        switch fallback {
        case let .solid(color):
            glassBackgroundView.effect = nil
            glassBackgroundView.backgroundColor = color

        case .systemUltraThinMaterial,
             .systemThinMaterial,
             .systemMaterial,
             .systemThickMaterial:
            glassBackgroundView.effect = UIBlurEffect(
                style: blurStyle(for: fallback)
            )
            glassBackgroundView.contentView.backgroundColor = fallbackTintColor(
                tintColor
            )
        }
    }

    private func blurStyle(
        for fallback: BaseBottomBarGlassFallback
    ) -> UIBlurEffect.Style {
        switch fallback {
        case .systemUltraThinMaterial:
            return .systemUltraThinMaterial
        case .systemThinMaterial:
            return .systemThinMaterial
        case .systemMaterial, .solid:
            return .systemMaterial
        case .systemThickMaterial:
            return .systemThickMaterial
        }
    }

    private func fallbackTintColor(_ tintColor: UIColor?) -> UIColor? {
        guard let tintColor else { return nil }
        return tintColor.withAlphaComponent(min(tintColor.cgColor.alpha, 0.18))
    }

    private func reducedTransparencyColor(
        for fallback: BaseBottomBarGlassFallback,
        tintColor: UIColor?
    ) -> UIColor {
        if case let .solid(color) = fallback {
            return color
        }
        return tintColor ?? configuration.appearance.backgroundColor
    }

    private func selectedItemCenterX() -> CGFloat? {
        guard let selectedIndex, itemButtons.indices.contains(selectedIndex) else { return nil }
        return stackView.convert(itemButtons[selectedIndex].center, to: self).x
    }

    private func indicatorFrame(for index: Int?) -> CGRect {
        guard let index, itemButtons.indices.contains(index) else { return .zero }
        let button = itemButtons[index]
        let center = stackView.convert(button.center, to: self)

        switch configuration.appearance.indicatorStyle {
        case .none:
            return .zero

        case let .circle(diameter):
            let size: CGFloat
            let originY: CGFloat
            if configuration.usesAMTossStyle {
                let metrics = BaseBottomBarTossEngine.metrics(
                    in: bounds,
                    numberOfTabs: items.count
                )
                size = metrics.ballSize
                originY = -size * 0.25
            } else {
                size = max(0, diameter)
                originY = -size * 0.36
            }
            return CGRect(
                x: center.x - size / 2,
                y: originY,
                width: size,
                height: size
            )

        case let .pill(size):
            let width = max(0, size.width)
            let height = max(0, size.height)
            return CGRect(
                x: center.x - width / 2,
                y: (bounds.height - height) / 2,
                width: width,
                height: height
            )

        case let .underline(width, height):
            let safeWidth = max(0, width)
            let safeHeight = max(0, height)
            return CGRect(
                x: center.x - safeWidth / 2,
                y: bounds.height - safeHeight,
                width: safeWidth,
                height: safeHeight
            )
        }
    }

    private func configureIndicatorShape() {
        switch configuration.appearance.indicatorStyle {
        case .none:
            indicatorView.layer.cornerRadius = 0
            indicatorView.alpha = 0
        case .circle:
            indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
            indicatorView.alpha = selectedIndex == nil ? 0 : 1
        case .pill:
            indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
            indicatorView.alpha = selectedIndex == nil ? 0 : 1
        case .underline:
            indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
            indicatorView.alpha = selectedIndex == nil ? 0 : 1
        }
    }

    private var indicatorVisibility: CGFloat {
        if case .none = configuration.appearance.indicatorStyle { return 0 }
        return selectedIndex == nil ? 0 : 1
    }

    private var animationDuration: TimeInterval {
        switch configuration.selectionAnimation {
        case .none:
            return 0
        case let .ease(duration),
             let .fade(duration),
             let .spring(duration, _),
             let .bounce(duration):
            return clampedDuration(duration)
        case .toss:
            return BaseBottomBarTossEngine.ballDuration
        }
    }

    private func shouldAnimate(requested: Bool) -> Bool {
        guard requested, configuration.animationsEnabled else { return false }
        if configuration.automaticallyHonorsReduceMotion,
           UIAccessibility.isReduceMotionEnabled {
            return false
        }
        if case .none = configuration.selectionAnimation { return false }
        return true
    }

    private func clampedDuration(_ duration: TimeInterval) -> TimeInterval {
        min(max(duration, 0), 5)
    }

    private func animateActionButton(_ button: UIView) {
        guard shouldAnimate(requested: true) else { return }
        UIView.animateKeyframes(
            withDuration: 0.35,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                button.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.55) {
                button.transform = .identity
            }
        }
    }

    private func animateReselection(_ button: UIView) {
        guard shouldAnimate(requested: true) else { return }

        if configuration.usesAMTossStyle {
            animateTossReselection(button)
            return
        }

        UIView.animateKeyframes(
            withDuration: 0.32,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                button.transform = CGAffineTransform(translationX: 0, y: -5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                button.transform = .identity
            }
        }
    }

    private func animateTossReselection(_ button: UIView) {
        let rise = max(24, indicatorView.bounds.height * 0.8)
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [0, -rise, 0]
        animation.keyTimes = [0, 0.45, 1]
        animation.timingFunctions = [
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeIn)
        ]
        animation.duration = BaseBottomBarTossEngine.ballDuration
        animation.isAdditive = true

        indicatorView.layer.removeAnimation(
            forKey: "BaseLibrary.BottomBar.toss.reselection.ball"
        )
        button.layer.removeAnimation(
            forKey: "BaseLibrary.BottomBar.toss.reselection.item"
        )
        indicatorView.layer.add(
            animation,
            forKey: "BaseLibrary.BottomBar.toss.reselection.ball"
        )
        button.layer.add(
            animation,
            forKey: "BaseLibrary.BottomBar.toss.reselection.item"
        )
    }

    private func animateRejectedSelection(_ button: UIView) {
        guard shouldAnimate(requested: true) else { return }
        UIView.animateKeyframes(
            withDuration: 0.25,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                button.transform = CGAffineTransform(translationX: -4, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                button.transform = CGAffineTransform(translationX: 4, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                button.transform = .identity
            }
        }
    }

    private func performHapticFeedback() {
        switch configuration.hapticFeedback {
        case .none:
            break
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case let .impact(style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

private final class BaseBottomBarItemButton: UIControl {
    var item: BaseBottomBarItem
    var iconVerticalOffset: CGFloat = 0

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()
    private var appearance = BaseBottomBarAppearance()

    init(item: BaseBottomBarItem) {
        self.item = item
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override var isSelected: Bool {
        didSet {
            updateState()
            setNeedsLayout()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateState()
            accessibilityTraits = isEnabled ? [.button] : [.button, .notEnabled]
        }
    }

    func apply(appearance: BaseBottomBarAppearance) {
        self.appearance = appearance
        titleLabel.font = appearance.titleFont
        badgeLabel.backgroundColor = appearance.badgeBackgroundColor
        badgeLabel.textColor = appearance.badgeTextColor
        badgeLabel.text = item.badgeValue
        badgeLabel.isHidden = item.badgeValue?.isEmpty ?? true
        titleLabel.text = item.title
        titleLabel.isHidden = !appearance.showsTitles || item.title == nil
        accessibilityLabel = item.accessibilityLabel ?? item.title
        accessibilityValue = item.badgeValue.map { "Badge \($0)" }
        updateState()
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let baseIconFrame = defaultIconFrame
        iconView.frame = CGRect(
            x: baseIconFrame.minX,
            y: baseIconFrame.minY + iconVerticalOffset,
            width: baseIconFrame.width,
            height: baseIconFrame.height
        )
        titleLabel.frame = CGRect(
            x: 2,
            y: baseIconFrame.maxY + 2,
            width: max(0, bounds.width - 4),
            height: 14
        )

        let badgeWidth = max(18, badgeLabel.intrinsicContentSize.width + 10)
        badgeLabel.frame = CGRect(
            x: min(bounds.width - badgeWidth, iconView.frame.maxX - 5),
            y: max(0, iconView.frame.minY - 7),
            width: badgeWidth,
            height: 18
        )
        badgeLabel.layer.cornerRadius = 9
    }

    var defaultIconCenterY: CGFloat {
        defaultIconFrame.midY
    }

    var defaultIconMinY: CGFloat {
        defaultIconFrame.minY
    }

    func prepareIconTransition(fromVerticalOffset oldVerticalOffset: CGFloat) {
        let translationY = oldVerticalOffset - iconVerticalOffset
        let translation = CGAffineTransform(translationX: 0, y: translationY)
        iconView.transform = translation
        badgeLabel.transform = translation
    }

    func finishIconTransition() {
        iconView.transform = .identity
        badgeLabel.transform = .identity
    }

    private var defaultIconFrame: CGRect {
        let iconSize = CGSize(
            width: max(0, appearance.iconSize.width),
            height: max(0, appearance.iconSize.height)
        )
        let titleHeight: CGFloat = titleLabel.isHidden ? 0 : 16
        let contentHeight = iconSize.height + titleHeight
        return CGRect(
            x: (bounds.width - iconSize.width) / 2,
            y: (bounds.height - contentHeight) / 2,
            width: iconSize.width,
            height: iconSize.height
        )
    }

    private func setUp() {
        isAccessibilityElement = true
        accessibilityTraits = [.button]

        iconView.contentMode = .scaleAspectFit
        iconView.isUserInteractionEnabled = false
        iconView.accessibilityIdentifier = "BaseLibrary.BaseBottomBar.icon"
        addSubview(iconView)

        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.isUserInteractionEnabled = false
        addSubview(titleLabel)

        badgeLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true
        badgeLabel.isUserInteractionEnabled = false
        addSubview(badgeLabel)
        updateState()
    }

    private func updateState() {
        let tintColor: UIColor
        if !isEnabled {
            tintColor = appearance.disabledItemColor
        } else if isSelected {
            tintColor = appearance.selectedItemColor
        } else {
            tintColor = appearance.normalItemColor
        }

        let image = isSelected ? (item.selectedImage ?? item.image) : item.image
        iconView.image = appearance.rendersImagesAsTemplate
            ? image.withRenderingMode(.alwaysTemplate)
            : image.withRenderingMode(.alwaysOriginal)
        iconView.tintColor = tintColor
        titleLabel.textColor = tintColor
        alpha = isEnabled ? 1 : 0.55
        accessibilityTraits = isSelected
            ? [.button, .selected]
            : (isEnabled ? [.button] : [.button, .notEnabled])
    }
}

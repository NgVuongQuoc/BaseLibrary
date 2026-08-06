//
//  BaseBottomBarController.swift
//  BaseLibrary
//
//  Created by BaseLibrary contributors.
//

import UIKit

public enum BaseBottomBarContentTransition {
    case none
    case crossDissolve(duration: TimeInterval)
    case slide(duration: TimeInterval)
    case scale(duration: TimeInterval)
}

public struct BaseBottomBarTab {
    public let viewController: UIViewController?
    public var item: BaseBottomBarItem

    public init(
        viewController: UIViewController,
        image: UIImage,
        selectedImage: UIImage? = nil,
        title: String? = nil,
        accessibilityLabel: String? = nil,
        badgeValue: String? = nil,
        isEnabled: Bool = true
    ) {
        self.viewController = viewController
        self.item = BaseBottomBarItem(
            image: image,
            selectedImage: selectedImage,
            title: title,
            accessibilityLabel: accessibilityLabel,
            badgeValue: badgeValue,
            role: .tab,
            isEnabled: isEnabled
        )
    }

    public init(viewController: UIViewController, item: BaseBottomBarItem) {
        var normalizedItem = item
        normalizedItem.role = .tab
        self.viewController = viewController
        self.item = normalizedItem
    }

    public static func action(
        image: UIImage,
        title: String? = nil,
        accessibilityLabel: String? = nil,
        badgeValue: String? = nil,
        isEnabled: Bool = true
    ) -> BaseBottomBarTab {
        BaseBottomBarTab(
            viewController: nil,
            item: BaseBottomBarItem(
                image: image,
                title: title,
                accessibilityLabel: accessibilityLabel,
                badgeValue: badgeValue,
                role: .action,
                isEnabled: isEnabled
            )
        )
    }

    private init(viewController: UIViewController?, item: BaseBottomBarItem) {
        self.viewController = viewController
        self.item = item
    }
}

open class BaseBottomBarController: UIViewController {
    public let baseBottomBar = BaseBottomBar()
    public private(set) var tabs: [BaseBottomBarTab] = []
    public private(set) var selectedIndex: Int?
    public private(set) var isBottomBarHidden = false

    public var bottomBarHeight: CGFloat = 64 {
        didSet {
            guard !isBottomBarHidden else { return }
            bottomBarHeightConstraint?.constant = max(1, bottomBarHeight)
        }
    }

    public var bottomBarConfiguration: BaseBottomBarConfiguration = .init() {
        didSet {
            baseBottomBar.configuration = bottomBarConfiguration
            updateBottomSafeAreaAppearance()
        }
    }

    public var contentTransition: BaseBottomBarContentTransition = .crossDissolve(
        duration: 0.2
    )

    private let contentContainerView = UIView()
    private let bottomSafeAreaFillView = UIView()
    private weak var visibleViewController: UIViewController?
    private var bottomBarHeightConstraint: NSLayoutConstraint?
    private var isTransitioningContent = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        applyTabs(initialIndex: selectedIndex)
    }

    public func setTabs(_ tabs: [BaseBottomBarTab], selectedIndex: Int? = nil) {
        loadViewIfNeeded()
        cancelContentTransition()
        removeExistingTabChildren()
        self.tabs = tabs
        self.selectedIndex = resolvedSelection(requestedIndex: selectedIndex)
        applyTabs(initialIndex: self.selectedIndex)
    }

    @discardableResult
    public func selectTab(at index: Int, animated: Bool = true) -> Bool {
        guard canSelectTab(at: index), shouldSelectTab(at: index) else { return false }

        if selectedIndex == index {
            if bottomBarConfiguration.allowsReselection {
                bottomBarDidReselectTab(at: index)
            }
            return true
        }

        let previousIndex = selectedIndex
        selectedIndex = index
        baseBottomBar.selectItem(at: index, animated: animated)
        displayViewController(
            at: index,
            previousIndex: previousIndex,
            animated: animated
        )
        bottomBarDidSelectTab(at: index)
        return true
    }

    @discardableResult
    public func setBadge(_ value: String?, at index: Int) -> Bool {
        guard tabs.indices.contains(index) else { return false }
        tabs[index].item.badgeValue = value
        return baseBottomBar.setBadge(value, at: index)
    }

    @discardableResult
    public func setTabEnabled(_ isEnabled: Bool, at index: Int) -> Bool {
        guard tabs.indices.contains(index) else { return false }
        let oldValue = tabs[index].item.isEnabled
        tabs[index].item.isEnabled = isEnabled
        let result = baseBottomBar.setItemEnabled(isEnabled, at: index)
        guard result else {
            tabs[index].item.isEnabled = oldValue
            return false
        }
        selectedIndex = baseBottomBar.selectedIndex
        return true
    }

    @discardableResult
    public func updateTabItem(_ item: BaseBottomBarItem, at index: Int) -> Bool {
        guard tabs.indices.contains(index) else { return false }
        var normalizedItem = item
        normalizedItem.role = tabs[index].viewController == nil ? .action : .tab
        let oldItem = tabs[index].item
        tabs[index].item = normalizedItem
        let result = baseBottomBar.updateItem(normalizedItem, at: index)
        guard result else {
            tabs[index].item = oldItem
            return false
        }
        selectedIndex = baseBottomBar.selectedIndex
        return true
    }

    public func setBottomBarHidden(_ hidden: Bool, animated: Bool = true) {
        guard hidden != isBottomBarHidden else { return }
        loadViewIfNeeded()
        isBottomBarHidden = hidden
        view.layoutIfNeeded()

        bottomBarHeightConstraint?.constant = hidden ? 0 : max(1, bottomBarHeight)
        let changes = {
            self.baseBottomBar.alpha = hidden ? 0 : 1
            self.bottomSafeAreaFillView.alpha = hidden ? 0 : 1
            self.baseBottomBar.transform = hidden
                ? CGAffineTransform(translationX: 0, y: max(1, self.bottomBarHeight))
                : .identity
            self.view.layoutIfNeeded()
        }

        guard animated, animationsAreAllowed else {
            changes()
            return
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut],
            animations: changes
        )
    }

    open func shouldSelectTab(at index: Int) -> Bool {
        true
    }

    open func bottomBarDidSelectTab(at index: Int) {}
    open func bottomBarDidReselectTab(at index: Int) {}
    open func bottomBarDidTriggerAction(at index: Int) {}

    private func setUpLayout() {
        view.backgroundColor = .systemBackground
        contentContainerView.clipsToBounds = true

        [contentContainerView, baseBottomBar, bottomSafeAreaFillView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        baseBottomBar.delegate = self
        baseBottomBar.configuration = bottomBarConfiguration
        bottomSafeAreaFillView.isUserInteractionEnabled = false
        bottomSafeAreaFillView.accessibilityIdentifier =
            "BaseLibrary.BaseBottomBar.safeAreaFill"
        updateBottomSafeAreaAppearance()

        let heightConstraint = baseBottomBar.heightAnchor.constraint(
            equalToConstant: max(1, bottomBarHeight)
        )
        bottomBarHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: baseBottomBar.topAnchor),

            baseBottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseBottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseBottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            heightConstraint,

            bottomSafeAreaFillView.topAnchor.constraint(equalTo: baseBottomBar.bottomAnchor),
            bottomSafeAreaFillView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSafeAreaFillView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSafeAreaFillView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateBottomSafeAreaAppearance() {
        switch bottomBarConfiguration.appearance.backgroundStyle {
        case .floating, .liquidGlass:
            bottomSafeAreaFillView.backgroundColor = .clear
        case .flat, .notched:
            bottomSafeAreaFillView.backgroundColor =
                bottomBarConfiguration.appearance.backgroundColor
        }
    }

    private func applyTabs(initialIndex: Int?) {
        baseBottomBar.setItems(tabs.map(\.item), selectedIndex: initialIndex)
        selectedIndex = baseBottomBar.selectedIndex
        guard let selectedIndex else {
            visibleViewController = nil
            return
        }
        displayViewController(
            at: selectedIndex,
            previousIndex: nil,
            animated: false
        )
    }

    private func resolvedSelection(requestedIndex: Int?) -> Int? {
        if let requestedIndex, canSelectTab(at: requestedIndex) {
            return requestedIndex
        }
        return tabs.indices.first(where: canSelectTab(at:))
    }

    private func canSelectTab(at index: Int) -> Bool {
        tabs.indices.contains(index)
            && tabs[index].viewController != nil
            && tabs[index].item.isEnabled
            && !isTransitioningContent
    }

    private func displayViewController(
        at index: Int,
        previousIndex: Int?,
        animated: Bool
    ) {
        guard let viewController = tabs[index].viewController else { return }
        guard visibleViewController !== viewController else { return }

        let oldViewController = visibleViewController
        let oldView = oldViewController?.view
        let isNewChild = viewController.parent !== self
        if isNewChild {
            addChild(viewController)
        }

        guard let newView = viewController.view else {
            if isNewChild { viewController.removeFromParent() }
            return
        }
        newView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            newView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            newView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
        contentContainerView.layoutIfNeeded()

        if isNewChild {
            viewController.didMove(toParent: self)
        }
        visibleViewController = viewController

        guard animated, animationsAreAllowed, let oldView else {
            oldView?.removeFromSuperview()
            return
        }

        isTransitioningContent = true
        let completion: (Bool) -> Void = { [weak self, weak oldView] _ in
            oldView?.removeFromSuperview()
            oldView?.alpha = 1
            oldView?.transform = .identity
            newView.alpha = 1
            newView.transform = .identity
            self?.isTransitioningContent = false
        }

        switch contentTransition {
        case .none:
            completion(true)

        case let .crossDissolve(duration):
            newView.alpha = 0
            UIView.animate(
                withDuration: clampedDuration(duration),
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut],
                animations: {
                    oldView.alpha = 0
                    newView.alpha = 1
                },
                completion: completion
            )

        case let .slide(duration):
            let movesForward = index > (previousIndex ?? index)
            let width = max(1, contentContainerView.bounds.width)
            newView.transform = CGAffineTransform(
                translationX: movesForward ? width : -width,
                y: 0
            )
            UIView.animate(
                withDuration: clampedDuration(duration),
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut],
                animations: {
                    oldView.transform = CGAffineTransform(
                        translationX: movesForward ? -width * 0.35 : width * 0.35,
                        y: 0
                    )
                    oldView.alpha = 0.7
                    newView.transform = .identity
                },
                completion: completion
            )

        case let .scale(duration):
            newView.alpha = 0
            newView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            UIView.animate(
                withDuration: clampedDuration(duration),
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut],
                animations: {
                    oldView.alpha = 0
                    oldView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                    newView.alpha = 1
                    newView.transform = .identity
                },
                completion: completion
            )
        }
    }

    private func cancelContentTransition() {
        contentContainerView.layer.removeAllAnimations()
        contentContainerView.subviews.forEach { subview in
            subview.layer.removeAllAnimations()
            subview.alpha = 1
            subview.transform = .identity
        }
        isTransitioningContent = false
    }

    private func removeExistingTabChildren() {
        visibleViewController = nil
        tabs.compactMap(\.viewController).forEach { child in
            guard child.parent === self else { return }
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    private var animationsAreAllowed: Bool {
        bottomBarConfiguration.animationsEnabled
            && (!bottomBarConfiguration.automaticallyHonorsReduceMotion
                || !UIAccessibility.isReduceMotionEnabled)
    }

    private func clampedDuration(_ duration: TimeInterval) -> TimeInterval {
        min(max(duration, 0), 5)
    }
}

extension BaseBottomBarController: BaseBottomBarDelegate {
    public func baseBottomBar(
        _ bottomBar: BaseBottomBar,
        shouldSelectItemAt index: Int
    ) -> Bool {
        canSelectTab(at: index) && shouldSelectTab(at: index)
    }

    public func baseBottomBar(_ bottomBar: BaseBottomBar, didSelectItemAt index: Int) {
        let previousIndex = selectedIndex
        selectedIndex = index
        displayViewController(
            at: index,
            previousIndex: previousIndex,
            animated: true
        )
        bottomBarDidSelectTab(at: index)
    }

    public func baseBottomBar(_ bottomBar: BaseBottomBar, didReselectItemAt index: Int) {
        bottomBarDidReselectTab(at: index)
    }

    public func baseBottomBar(_ bottomBar: BaseBottomBar, didTriggerActionAt index: Int) {
        bottomBarDidTriggerAction(at: index)
    }
}

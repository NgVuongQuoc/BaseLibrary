import UIKit

/// A snapshot of the container's geometry, traits, and configured hosting display.
public struct AdaptiveLayoutContext: Equatable {
    public let size: CGSize
    public let safeAreaInsets: UIEdgeInsets
    public let horizontalSizeClass: UIUserInterfaceSizeClass
    public let verticalSizeClass: UIUserInterfaceSizeClass
    public let preferredContentSizeCategory: UIContentSizeCategory
    public let displayType: DeviceDisplayType

    public var availableWidth: CGFloat {
        max(0, size.width - safeAreaInsets.left - safeAreaInsets.right)
    }

    public var layoutType: DeviceLayoutType {
        DeviceLayoutType(horizontalSizeClass: horizontalSizeClass)
    }

    public init(
        size: CGSize,
        safeAreaInsets: UIEdgeInsets,
        traits: UITraitCollection,
        displayType: DeviceDisplayType? = nil
    ) {
        self.size = size
        self.safeAreaInsets = safeAreaInsets
        horizontalSizeClass = traits.horizontalSizeClass
        verticalSizeClass = traits.verticalSizeClass
        preferredContentSizeCategory = traits.preferredContentSizeCategory
        self.displayType = displayType ?? DeviceDisplayType(traitCollection: traits)
    }
}

/// Subclass to adapt constraints or invalidate a collection layout as its container changes.
/// Existing screens opt in by adopting this superclass and implementing the callback.
open class BaseAdaptiveViewController: UIViewController {
    public private(set) var adaptiveLayoutContext: AdaptiveLayoutContext?

    /// Explicit hosting-display information from the app's scene integration.
    /// Update on display changes; nil falls back to the current interface idiom.
    /// This does not detect Duo hardware or infer its display from size classes.
    public var displayTypeOverride: DeviceDisplayType? {
        didSet {
            guard displayTypeOverride != oldValue else { return }
            viewIfLoaded?.setNeedsLayout()
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateAdaptiveLayout()
    }

    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.setNeedsLayout()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewIfLoaded?.setNeedsLayout()
    }

    open override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        let scheduled = coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            let updates = {
                // UIKit supplies the current bounds and safe area during layout.
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            if UIAccessibility.isReduceMotionEnabled {
                UIView.performWithoutAnimation(updates)
            } else {
                updates()
            }
        }, completion: { [weak self] _ in
            // Reconcile actual geometry, including a cancelled transition.
            self?.viewIfLoaded?.setNeedsLayout()
        })
        if !scheduled {
            viewIfLoaded?.setNeedsLayout()
        }
    }

    /// Update constraints or invalidate layout here. Do not reload data, rebuild
    /// controllers, call layoutIfNeeded, or start independent animations here.
    /// The first callback is delivered on the first nonzero layout pass.
    open func adaptiveLayoutDidChange(_ context: AdaptiveLayoutContext) {}

    private func updateAdaptiveLayout() {
        guard view.bounds.width > 0, view.bounds.height > 0 else { return }
        let context = AdaptiveLayoutContext(
            size: view.bounds.size,
            safeAreaInsets: view.safeAreaInsets,
            traits: traitCollection,
            displayType: displayTypeOverride
        )
        guard context != adaptiveLayoutContext else { return }
        // Store before calling client code to avoid duplicate reentrant updates.
        adaptiveLayoutContext = context
        if UIAccessibility.isReduceMotionEnabled {
            UIView.performWithoutAnimation { self.adaptiveLayoutDidChange(context) }
        } else {
            adaptiveLayoutDidChange(context)
        }
    }
}

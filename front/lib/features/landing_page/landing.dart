// =============================================================================
// MAINTENANCE HUB — LANDING PAGE (single-file, copy-paste ready)
// Shared space for Admins & Technicians to organize technical fixes.
// Flutter, null-safe, responsive (mobile / tablet / desktop / web)
//
// Dependencies (add to pubspec.yaml):
//   google_fonts: ^6.2.1
//
// Usage: import this file and use `const LandingPage()` in any route.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Adjust this import path to match where this file lives relative to
// features/auth/login_screen.dart in your project.
import '../auth/login_screen.dart';

// ----------------------------------------------------------------------------
// THEME & DESIGN TOKENS
// ----------------------------------------------------------------------------

class AppColors {
  AppColors._();

  static const Color primaryNavy = Color(0xFF1E3A5F);
  static const Color secondaryBeige = Color(0xFFF5F1EB);
  static const Color accentGold = Color(0xFFC9A86A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF2D2D2D);
  static const Color sageGreen = Color(0xFF6B8E74);

  static const Color navyDark = Color(0xFF142A45);
  static const Color navySoft = Color(0xFF2B4A73);
  static const Color charcoalMuted = Color(0xFF6E6E6E);
  static const Color shadow = Color(0x1A1E3A5F);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDark, primaryNavy, navySoft],
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double section = 96;
  static const double sectionMobile = 56;

  static double pageHorizontal(double width) {
    if (width >= AppBreakpoints.desktop) return 96;
    if (width >= AppBreakpoints.tablet) return 48;
    return 20;
  }
}

class AppRadius {
  AppRadius._();
  static const double sm = 12;
  static const double lg = 16;
  static const double pill = 999;
}

class AppBreakpoints {
  AppBreakpoints._();
  static const double tablet = 800;
  static const double desktop = 1200;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _headingFont => GoogleFonts.playfairDisplay();
  static TextStyle get _bodyFont => GoogleFonts.poppins();

  static TextStyle displayLarge = _headingFont.copyWith(
    fontSize: 52,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryNavy,
    height: 1.15,
  );

  static TextStyle displayMedium = _headingFont.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryNavy,
    height: 1.2,
  );

  static TextStyle headlineSmall = _headingFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryNavy,
  );

  static TextStyle bodyLarge = _bodyFont.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.charcoal,
    height: 1.6,
  );

  static TextStyle bodyMedium = _bodyFont.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.charcoalMuted,
    height: 1.6,
  );

  static TextStyle overline = _bodyFont.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.accentGold,
    letterSpacing: 3,
  );

  static TextStyle buttonText = _bodyFont.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  static TextStyle caption = _bodyFont.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.charcoalMuted,
  );
}

// ----------------------------------------------------------------------------
// ANIMATIONS
// ----------------------------------------------------------------------------

/// Simple one-shot fade + slide-up animation, played on first build.
/// (No scroll-visibility dependency needed — this page is short.)
class AnimatedEntrance extends StatefulWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fade.value,
        child: FractionalTranslation(translation: _slide.value, child: child),
      ),
      child: widget.child,
    );
  }
}

// ----------------------------------------------------------------------------
// BUTTONS
// ----------------------------------------------------------------------------

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dark = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool dark;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.dark ? AppColors.accentGold : AppColors.primaryNavy;
    final fg = widget.dark ? AppColors.primaryNavy : AppColors.background;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : (_hovering ? 1.03 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: [
                BoxShadow(
                  color: bg.withValues(alpha: _hovering ? 0.45 : 0.28),
                  blurRadius: _hovering ? 24 : 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label, style: AppTextStyles.buttonText.copyWith(color: fg)),
                if (widget.icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(widget.icon, size: 18, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dark = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool dark;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final line = widget.dark ? AppColors.background : AppColors.primaryNavy;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _hovering ? line.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: line.withValues(alpha: 0.6), width: 1.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: AppTextStyles.buttonText.copyWith(color: line)),
              if (widget.icon != null) ...[
                const SizedBox(width: 10),
                Icon(widget.icon, size: 18, color: line),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// SECTION SCAFFOLD
// ----------------------------------------------------------------------------

class SectionScaffold extends StatelessWidget {
  const SectionScaffold({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.background,
    this.maxContentWidth = 1100,
  });

  final Widget child;
  final Color backgroundColor;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = AppBreakpoints.isMobile(width);
        final vertical = isMobile ? AppSpacing.sectionMobile : AppSpacing.section;
        final horizontal = AppSpacing.pageHorizontal(width);

        return Container(
          width: double.infinity,
          color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// TOP NAV HEADER (brand + Login button)
// ----------------------------------------------------------------------------

class _LandingHeader extends StatelessWidget {
  const _LandingHeader();

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = AppSpacing.pageHorizontal(constraints.maxWidth);
        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.build_circle_outlined, color: AppColors.primaryNavy, size: 24),
                  const SizedBox(width: 8),
                  Text('Maintenance Hub', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                ],
              ),
              SecondaryButton(
                label: 'Login',
                icon: Icons.login_rounded,
                dark: false,
                onPressed: () => _goToLogin(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// HERO SECTION
// ----------------------------------------------------------------------------

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, this.onLogin});
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = AppBreakpoints.isDesktop(width);
        final isMobile = AppBreakpoints.isMobile(width);
        final horizontal = AppSpacing.pageHorizontal(width);

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          padding: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: isDesktop ? 110 : 72,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: AnimatedEntrance(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
                      ),
                      child: Text('INTERNAL TOOL', style: AppTextStyles.overline.copyWith(fontSize: 12)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'One Place to Track,\nAssign & Resolve Issues',
                      textAlign: TextAlign.center,
                      style: (isMobile ? AppTextStyles.displayMedium : AppTextStyles.displayLarge)
                          .copyWith(color: AppColors.background),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'A shared workspace for admins and technicians to log, assign, and follow '
                      'up on technical problems — from report to resolution.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondaryBeige.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Login to Continue',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: onLogin ?? () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// HOW IT WORKS SECTION (Admin / Technician roles)
// ----------------------------------------------------------------------------

class _RoleInfo {
  const _RoleInfo({
    required this.icon,
    required this.title,
    required this.description,
    required this.points,
  });
  final IconData icon;
  final String title;
  final String description;
  final List<String> points;
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _roles = [
    _RoleInfo(
      icon: Icons.admin_panel_settings_outlined,
      title: 'Admin',
      description: 'Oversees incoming issues and keeps work moving.',
      points: [
        'Log and prioritize reported problems',
        'Assign tasks to the right technician',
        'Track progress and close out resolved tickets',
      ],
    ),
    _RoleInfo(
      icon: Icons.engineering_outlined,
      title: 'Technician',
      description: 'Handles the hands-on fix, start to finish.',
      points: [
        'View assigned tickets and details',
        'Update status as work progresses',
        'Mark issues resolved with notes',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      backgroundColor: AppColors.secondaryBeige,
      child: Column(
        children: [
          AnimatedEntrance(
            child: Column(
              children: [
                Text('HOW IT WORKS', style: AppTextStyles.overline, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Built Around Two Roles',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium.copyWith(fontSize: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isDesktop = AppBreakpoints.isDesktop(width) || AppBreakpoints.isTablet(width);
              const spacing = AppSpacing.lg;
              final itemWidth = isDesktop ? (width - spacing) / 2 : width;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < _roles.length; i++)
                    SizedBox(
                      width: itemWidth,
                      child: AnimatedEntrance(
                        delay: Duration(milliseconds: 120 * i),
                        child: _RoleCard(role: _roles[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  const _RoleCard({required this.role});
  final _RoleInfo role;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hovering ? -6.0 : 0.0),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: _hovering ? 26 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.secondaryBeige,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(widget.role.icon, color: AppColors.accentGold, size: 26),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(widget.role.title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 20)),
            const SizedBox(height: AppSpacing.xs),
            Text(widget.role.description, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            ...widget.role.points.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.sageGreen),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p, style: AppTextStyles.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// FOOTER SECTION
// ----------------------------------------------------------------------------

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navyDark,
      child: SectionScaffold(
        backgroundColor: AppColors.navyDark,
        maxContentWidth: 1100,
        child: Column(
          children: [
            Text(
              '© 2026 Syrine Hleli. All rights reserved.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryBeige.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Designed & Developed by Syrine Hleli',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accentGold.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// LANDING PAGE SCREEN
// ----------------------------------------------------------------------------

/// Drop this widget into any route of the existing app
/// (e.g. `LandingPage()`) to display the simplified landing page.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _LandingHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Builder(
                    builder: (context) => HeroSection(onLogin: () => _goToLogin(context)),
                  ),
                  const HowItWorksSection(),
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:ui_web';
import 'package:flutter/material.dart';

// ---------- Design tokens ----------
const _kPrimary = Color(0xFF6559F5); // main purple
const _kSidebar = Color(0xFF5B50C9); // sidebar purple
const _kTextPrimary = Color(0xFF373346);
const _kTextSecondary = Color(0xFF708AAE);
const _kTextMuted = Color(0xFFA19CAA);
const _kDivider = Color(0x11000000);
const _kCardRadius = 18.0;

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardFrame();
  }
}

class _DashboardFrame extends StatelessWidget {
  const _DashboardFrame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // full-bleed page
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _LeftNavRail(), // wider + centered items + indicator
          _CenterColumn(), // header with animated search + notifications
          _RightSidebar(), // wider panel with functional calendar (pushed in)
        ],
      ),
    );
  }
}

// ============================================================
// LEFT NAV
// ============================================================
class _LeftNavRail extends StatefulWidget {
  const _LeftNavRail();

  @override
  State<_LeftNavRail> createState() => _LeftNavRailState();
}

class _LeftNavRailState extends State<_LeftNavRail> {
  int _selected = 0;

  final _items = const [
    (Icons.dashboard_rounded, 'Dashboard'),
    (Icons.menu_book_rounded, 'All Courses'),
    (Icons.chat_bubble_outline_rounded, 'Messages'),
    (Icons.group_outlined, 'Friends'),
    (Icons.calendar_month_outlined, 'Schedule'),
    (Icons.settings_outlined, 'Settings'),
    (Icons.contact_page_outlined, 'Directory'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240, // wider
      child: Container(
        decoration: const BoxDecoration(
          color: _kSidebar,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(22, 26, 18, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrandWordmark(),
            const SizedBox(height: 30),
            ...List.generate(_items.length, (i) {
              final (icon, label) = _items[i];
              return _NavRowItem(
                icon: icon,
                label: label,
                selected: _selected == i,
                onTap: () => setState(() => _selected = i),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BrandWordmark extends StatelessWidget {
  const _BrandWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          '9',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: 6),
        Text(
          'esmi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ),
      ],
    );
  }
}

class _NavRowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavRowItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = 24.0;
    final baseColor = selected
        ? Colors.white
        : Colors.white.withValues(
            alpha: 0.56,
          ); // semi-transparent qwiodnwuqidnhbwquidhnwquidhwqudhwquidhqwuidhqwuidhquwiqdhuwiqdhwquidhiquwhdiuqwdhiuwqdhuiqwdhuiqwdhwquduiqw

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 52, // taller for centered vertical alignment
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // small white rectangle indicator when selected
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 6 : 0,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            if (selected)
              const SizedBox(width: 10)
            else
              const SizedBox(width: 16),
            Icon(icon, size: iconSize, color: baseColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: baseColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CENTER COLUMN (animated search + notifications, compact cards)
// ============================================================
class _CenterColumn extends StatelessWidget {
  const _CenterColumn();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CenterHeader(), // Title + Animated Search + Bell
            SizedBox(height: 16),
            _CoursesList(),
          ],
        ),
      ),
    );
  }
}

class _CenterHeader extends StatefulWidget {
  const _CenterHeader();

  @override
  State<_CenterHeader> createState() => _CenterHeaderState();
}

class _CenterHeaderState extends State<_CenterHeader> {
  bool _expanded = false;
  final _controller = TextEditingController();
  final _focus = FocusNode();
  static const _animDuration = Duration(milliseconds: 320);

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus && mounted) {
        // collapse when it loses focus and field is empty
        if (_controller.text.isEmpty) {
          setState(() => _expanded = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (!_expanded) {
      // collapsing
      _controller.clear();
      _focus.unfocus();
    } else {
      // expanding
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) _focus.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // put variables here (before returning the Row)
    const double maxSearchWidth = 1000.0; // full width when expanded
    const double iconButton = 42.0; // fixed icon hit target

    return Row(
      children: [
        const Text(
          'My Courses',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _kPrimary,
          ),
        ),

        const SizedBox(width: 16),

        // Animated search: icon stays fixed; pill reveals from the icon to the right
        // Animated search: icon stays fixed; pill reveals from the icon to the right
        SizedBox(
          width: maxSearchWidth, // reserve space so nothing around shifts
          height: 42,
          child: Stack(
            children: [
              // 1) The pill + TextField; reveal via widthFactor (clip)
              TweenAnimationBuilder<double>(
                duration: _animDuration,
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  end: _expanded ? 1.0 : (iconButton / maxSearchWidth),
                ),
                builder: (context, factor, _) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            factor, // reveal from left without moving icon
                        child: AbsorbPointer(
                          absorbing:
                              factor <= (iconButton / maxSearchWidth) + 1e-6,
                          child: Container(
                            width: maxSearchWidth,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _expanded
                                  ? const Color.fromARGB(
                                      185,
                                      183,
                                      183,
                                      183,
                                    ) // fill color expanded
                                  : const Color.fromARGB(
                                      255,
                                      182,
                                      181,
                                      181,
                                    ).withValues(
                                      //qwewqwewqewqewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
                                      alpha: 0.0,
                                    ), // fade out when collapsing
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE7E9F3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.search_rounded,
                                  color: _kPrimary,
                                ),
                                const SizedBox(width: 8),
                                // Fade the TextField smoothly on close
                                Expanded(
                                  child: AnimatedOpacity(
                                    opacity: _expanded ? 1.0 : 0.0,
                                    duration: _animDuration,
                                    curve: Curves.easeInOut,
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _focus,
                                      cursorColor: _kPrimary,
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          38,
                                          38,
                                          38,
                                        ), // typing text color
                                        fontSize: 16,
                                        fontFamily:
                                            "Roboto", // optional: text size
                                        fontWeight:
                                            FontWeight.w600, // optional: weight
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Search...',

                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (_) => _focus.unfocus(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 2) Fixed circular icon hit target on top (never moves)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      setState(() => _expanded = true);
                      Future.delayed(const Duration(milliseconds: 10), () {
                        if (mounted) _focus.requestFocus();
                      });
                    },
                    child: SizedBox(
                      width: iconButton,
                      height: 42,
                      child: Center(
                        child: AnimatedContainer(
                          duration: _animDuration,
                          curve: Curves.easeInOut,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _expanded
                                ? const Color.fromARGB(
                                    255,
                                    158,
                                    158,
                                    158,
                                  ) // Purple when expanded
                                : Colors.white, // White when collapsed
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search_rounded,
                            color: _expanded ? Colors.white : _kPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        const _IconButtonCircle(
          icon: Icons.notifications_none_rounded,
          size: 42,
          iconSize: 30,
          color: _kPrimary,
        ),
      ],
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color color;
  const _IconButtonCircle({
    required this.icon,
    this.size = 36,
    this.iconSize = 18,
    this.color = _kTextPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kDivider),
          ),
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }
}

class PressableCard extends StatefulWidget {
  const PressableCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 18.0,
    this.enableHover = true,
    this.scale = 1.02, // subtle zoom (whole card)
    this.lift = 2.0, // tiny upward lift on press/hover
    // dynamic shadow inputs
    this.shadowBase, // use for solid fills (user-chosen color)
    this.shadowGradientStart, // use these for gradient cards
    this.shadowGradientEnd,

    // strength controls (tweak if needed)
    this.blackMix = 0.6, // 0..1 (how much black to mix into base hue)
    this.shadowOpacityIdle = 0.45, // stronger so it’s visible on white bg
    this.shadowOpacityHover = 0.65,
    this.shadowBlurIdle = 18,
    this.shadowBlurHover = 28,
    this.shadowYOffsetIdle = 10,
    this.shadowYOffsetHover = 14,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool enableHover;
  final double scale;
  final double lift;

  // dynamic shadow inputs
  final Color? shadowBase;
  final Color? shadowGradientStart;
  final Color? shadowGradientEnd;

  // knobs
  final double blackMix;
  final double shadowOpacityIdle;
  final double shadowOpacityHover;
  final double shadowBlurIdle;
  final double shadowBlurHover;
  final double shadowYOffsetIdle;
  final double shadowYOffsetHover;

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _hover = false;
  bool _down = false;

  Color _pickDarker(Color a, Color b) =>
      a.computeLuminance() < b.computeLuminance() ? a : b;

  Color _mixWithBlack(Color c, double t) {
    // t = 0 keeps original hue, t = 1 is full black
    int ch(int v) => (v * (1 - t)).round().clamp(0, 255);
    return Color.fromARGB(c.alpha, ch(c.red), ch(c.green), ch(c.blue));
  }

  @override
  Widget build(BuildContext context) {
    final bool popped = _down || (widget.enableHover && _hover);

    // Decide base color for shadow hue:
    Color? base = widget.shadowBase;
    if (base == null &&
        widget.shadowGradientStart != null &&
        widget.shadowGradientEnd != null) {
      base = _pickDarker(
        widget.shadowGradientStart!,
        widget.shadowGradientEnd!,
      );
    }

    // Build shadow style (dark colored shadow mixed with black for visibility)
    final List<BoxShadow> shadows;
    if (base != null) {
      final tinted = _mixWithBlack(base, widget.blackMix);
      final color = tinted.withOpacity(
        popped ? widget.shadowOpacityHover : widget.shadowOpacityIdle,
      );
      final blur = popped ? widget.shadowBlurHover : widget.shadowBlurIdle;
      final y = popped ? widget.shadowYOffsetHover : widget.shadowYOffsetIdle;
      shadows = [
        BoxShadow(color: color, blurRadius: blur, offset: Offset(0, y)),
      ];
    } else {
      // Fallback neutral shadow if no color hints provided
      shadows = popped
          ? const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ]
          : const [
              BoxShadow(
                color: Color(0x3D000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ];
    }

    // We apply scale/translate to the ENTIRE stack (including shadow + child)
    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: shadows,
      ),
      clipBehavior: Clip.none, // allow decorative overflow
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _down = v),
          child: widget.child,
        ),
      ),
    );

    // Apply lift + scale to the WHOLE thing (shadow + child + background)
    content = AnimatedSlide(
      offset: popped ? Offset(0, -widget.lift / 100.0) : Offset.zero,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: popped ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: content,
      ),
    );

    if (widget.enableHover) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: content,
      );
    }

    return content;
  }
}

// --- REPLACE your _CoursesList with this ---
class _CoursesList extends StatelessWidget {
  const _CoursesList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 16, // gap between columns
        mainAxisSpacing: 16, // gap between rows
        childAspectRatio:
            2.8, // width / height; tweak if cards look too tall/short
        children: const [
          // 1
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 139, 174, 245),
            shadowGradientEnd: Color.fromARGB(255, 200, 220, 252),
            child: _CourseCard(
              title: 'Operating System',
              description:
                  'Learn the basic operating system abstractions, mechanisms, and their implementations.',
              creator: 'Mark Leo',
              gradientStart: Color.fromARGB(255, 139, 174, 245),
              gradientEnd: Color.fromARGB(255, 200, 220, 252),
              bubbleTint: Color.fromARGB(255, 0, 92, 240),
            ),
          ),

          // 2
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 131, 243, 144),
            shadowGradientEnd: Color.fromARGB(255, 170, 235, 207),
            child: _CourseCard(
              title: 'Operating System',
              description:
                  'Learn the basic operating system abstractions, and their implementation.',
              creator: 'Mark Leo',
              gradientStart: Color.fromARGB(255, 131, 243, 144),
              gradientEnd: Color.fromARGB(255, 170, 235, 207),
              bubbleTint: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          // 3
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 246, 157, 233),
            shadowGradientEnd: Color.fromARGB(255, 240, 191, 230),
            child: _CourseCard(
              title: 'Artificial Intelligence',
              description:
                  'Intelligence demonstrated by machines, unlike the natural intelligence displayed by humans and animals.',
              creator: 'Jung Jaehyun',
              gradientStart: Color.fromARGB(255, 246, 157, 233),
              gradientEnd: Color.fromARGB(255, 240, 191, 230),
              bubbleTint: Color.fromARGB(255, 153, 0, 255),
            ),
          ),

          // 4 (duplicate of 1–3 to make 6 items)
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 139, 174, 245),
            shadowGradientEnd: Color.fromARGB(255, 200, 220, 252),
            child: _CourseCard(
              title: 'Operating System',
              description:
                  'Learn the basic operating system abstractions, mechanisms, and their implementations.',
              creator: 'Mark Leo',
              gradientStart: Color.fromARGB(255, 139, 174, 245),
              gradientEnd: Color.fromARGB(255, 200, 220, 252),
              bubbleTint: Color.fromARGB(255, 0, 92, 240),
            ),
          ),

          // 5
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 131, 243, 144),
            shadowGradientEnd: Color.fromARGB(255, 170, 235, 207),
            child: _CourseCard(
              title: 'Operating System',
              description:
                  'Learn the basic operating system abstractions, and their implementation.',
              creator: 'Mark Leo',
              gradientStart: Color.fromARGB(255, 131, 243, 144),
              gradientEnd: Color.fromARGB(255, 170, 235, 207),
              bubbleTint: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          // 6
          PressableCard(
            borderRadius: 18,
            shadowGradientStart: Color.fromARGB(255, 246, 157, 233),
            shadowGradientEnd: Color.fromARGB(255, 240, 191, 230),
            child: _CourseCard(
              title: 'Artificial Intelligence',
              description:
                  'Intelligence demonstrated by machines, unlike the natural intelligence displayed by humans and animals.',
              creator: 'Jung Jaehyun',
              gradientStart: Color.fromARGB(255, 246, 157, 233),
              gradientEnd: Color.fromARGB(255, 240, 191, 230),
              bubbleTint: Color.fromARGB(255, 153, 0, 255),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String creator;
  final Color gradientStart;
  final Color gradientEnd;
  final Color bubbleTint;

  const _CourseCard({
    required this.title,
    required this.description,
    required this.creator,
    required this.gradientStart,
    required this.gradientEnd,
    this.bubbleTint = const Color(0xFF96A9DE),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // “Shadow floor”
        Positioned(
          left: 16,
          right: 16,
          bottom: -8,
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F6F89A5),
                  blurRadius: 26,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),

        // Card body: dynamic height (no fixed height)
        Container(
          constraints: const BoxConstraints(
            minHeight: 110,
          ), // 👈 keeps short cards tidy
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_kCardRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStart, gradientEnd],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // let content grow downward
            children: [
              const _DeviceIllustration(),
              const SizedBox(width: 14),

              // Texts expand vertically with content
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // allow height to fit content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title stays one line for crisp look
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Description wraps to any length
                    Text(
                      description,
                      softWrap: true,
                      // remove maxLines/ellipsis so it expands
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: _kTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Creator line
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: _kTextMuted,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'Created by '),
                          TextSpan(
                            text: creator,
                            style: const TextStyle(
                              color: _kPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Chevron aligned to top (so it doesn't stretch)
              Align(alignment: Alignment.topCenter),
            ],
          ),
        ),

        // Decorative bubbles/dots
        Positioned(
          left: 16,
          top: 10,
          child: _BubbleRow(tint: bubbleTint.withValues(alpha: .22)),
        ),
        Positioned(
          left: 44,
          bottom: 10,
          child: _BubbleRow(
            tint: bubbleTint.withValues(alpha: .16),
            small: true,
          ),
        ),
      ],
    );
  }
}

class _DeviceIllustration extends StatelessWidget {
  const _DeviceIllustration();

  @override
  Widget build(BuildContext context) {
    // Minimal vector-ish device trio
    return SizedBox(
      width: 110,
      height: 64,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 8,
            right: 8,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0x11000000),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 10,
            child: Container(
              width: 60,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFB7C5EA),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            left: 6,
            bottom: 16,
            child: Container(
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0x225B50C9)),
              ),
            ),
          ),
          Positioned(
            left: 56,
            bottom: 14,
            child: Container(
              width: 40,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF6E78C7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            left: 62,
            bottom: 20,
            child: Container(
              width: 28,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0x225B50C9)),
              ),
            ),
          ),
          Positioned(
            left: 42,
            bottom: 8,
            child: Container(
              width: 12,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF8B90D5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleRow extends StatelessWidget {
  final Color tint;
  final bool small;
  const _BubbleRow({required this.tint, this.small = false});

  @override
  Widget build(BuildContext context) {
    final s = small ? 4.0 : 6.0;
    return Row(
      children: [
        _dot(s, tint),
        const SizedBox(width: 8),
        _dot(s, tint),
        const SizedBox(width: 8),
        _dot(s, tint),
      ],
    );
  }

  Widget _dot(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

// ============================================================
// RIGHT SIDEBAR (wider) + pushed in + Functional Calendar
// ============================================================
class _RightSidebar extends StatelessWidget {
  const _RightSidebar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360, // wider
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // push from edge
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(color: _kDivider)),
          ),
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileHeader(),
              SizedBox(height: 18),
              _MonthCalendar(), // functional, navigable calendar
              SizedBox(height: 18),
              _OnlineUsers(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Christine Eva',
                style: TextStyle(
                  color: _kTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '1094881999',
                style: TextStyle(color: _kTextMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFD8E8FF),
          child: Icon(Icons.person, color: _kPrimary),
        ),
      ],
    );
  }
}

class _OnlineUsers extends StatelessWidget {
  const _OnlineUsers();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _BlockHeader(title: 'Online Users'),
        SizedBox(height: 16), // ↑ a bit more breathing room
        _UserRow(name: 'Maren Maureen', id: '1094831980'),
        _UserRow(name: 'Jennifer Jane', id: '1084817000'),
        _UserRow(name: 'Ryan Herwinds', id: '1084432080'),
        _UserRow(name: 'Kierra Culhane', id: '1084462022'),
      ],
    );
  }
}

class _BlockHeader extends StatelessWidget {
  final String title;
  const _BlockHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _kPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18, // ↑ bigger title
            letterSpacing: .2,
          ),
        ),
        const Spacer(),
        const Text(
          'See all',
          style: TextStyle(
            color: _kPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16, // ↑ bigger action text
          ),
        ),
      ],
    );
  }
}

class _UserRow extends StatelessWidget {
  final String name;
  final String id;

  const _UserRow({required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0, // ↑ taller row
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22, // ↑ bigger avatar
            backgroundColor: Color(0xFFE4F0FF),
            child: Icon(
              Icons.person,
              color: _kPrimary,
              size: 24,
            ), // ↑ bigger icon
          ),
          const SizedBox(width: 14), // ↑ spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kTextPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16, // ↑ bigger name
                    letterSpacing: .1,
                  ),
                ),
                const SizedBox(height: 4), // ↑ spacing name↔id
                Text(
                  id,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kTextMuted,
                    fontSize: 14, // ↑ bigger id
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10, // ↑ bigger status dot
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF6CA7DE),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Functional, navigable calendar (single global selection) ----------
class _MonthCalendar extends StatefulWidget {
  const _MonthCalendar();

  @override
  State<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<_MonthCalendar> {
  // Which month is being displayed
  DateTime _month = DateTime(2020, 11, 1);

  // ONE selected date for the entire calendar (global selection)
  DateTime? _selected; // e.g., DateTime(2020, 7, 1)

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final grid = _buildGrid(_month); // 6x7 (Monday-first)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              '${_abbr(_month.month)} ${_month.year}',
              style: const TextStyle(
                color: _kPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, color: _kTextMuted),
              splashRadius: 18,
              onPressed: () => setState(() {
                _month = DateTime(_month.year, _month.month - 1, 1);
                // Do NOT touch _selected — it’s global and persists
              }),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, color: _kTextMuted),
              splashRadius: 18,
              onPressed: () => setState(() {
                _month = DateTime(_month.year, _month.month + 1, 1);
                // Do NOT touch _selected — it’s global and persists
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdays
              .map(
                (w) => SizedBox(
                  width: 32,
                  child: Text(
                    w.substring(0, 2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _kTextMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        // Days grid
        Column(
          children: List.generate(6, (r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (c) {
                  final date = grid[r][c];

                  final inMonth =
                      date != null &&
                      date.year == _month.year &&
                      date.month == _month.month;

                  final isSelected =
                      date != null &&
                      _selected != null &&
                      date.year == _selected!.year &&
                      date.month == _selected!.month &&
                      date.day == _selected!.day;

                  return _DayCell(
                    day: date?.day,
                    isDimmed: date == null || !inMonth,
                    isSelected: isSelected,
                    onTap: (date == null || !inMonth)
                        ? null
                        : () => setState(() {
                            // Set ONE global selection
                            _selected = date;
                          }),
                  );
                }),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Build a Monday-first grid for the given month
  List<List<DateTime?>> _buildGrid(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Dart: Mon=1..Sun=7 -> 0..6 with Mon=0
    final startCol = (first.weekday - 1) % 7;

    final cells = List<DateTime?>.filled(42, null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells[startCol + d - 1] = DateTime(month.year, month.month, d);
    }
    return List.generate(6, (i) => cells.sublist(i * 7, i * 7 + 7));
  }

  static String _abbr(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[m - 1];
  }
}

class _DayCell extends StatelessWidget {
  final int? day;
  final bool isSelected;
  final bool isDimmed;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    this.isSelected = false,
    this.isDimmed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (day == null) return const SizedBox(width: 32, height: 32);

    final Widget content = isSelected
        ? Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _kPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isDimmed ? _kTextMuted : _kTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: content,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'LoginPage.dart';
import 'package:flutter/gestures.dart'; // 👈

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  final Map<String, Locale> languageMap = {
    'English (USA)': const Locale('en', 'US'),
    'Français': const Locale('fr', 'FR'),
    'العربية': const Locale('ar', 'TN'),
  };

  late String selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = languageMap.entries
        .firstWhere(
          (entry) => entry.value == context.locale,
          orElse: () => const MapEntry('English (USA)', Locale('en', 'US')),
        )
        .key;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dropdownLanguages = languageMap.keys
        .where((lang) => lang != selectedLanguage)
        .toList();

    final bool isPhone = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 196, 174, 173),
              Color.fromARGB(255, 144, 144, 201),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isPhone
              // PHONE: hide left panel
              ? SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Container(
                      height: context.locale.languageCode == 'ar' ? 650 : 620,
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _buildRightPanel(dropdownLanguages),
                    ),
                  ),
                )
              // TABLET/DESKTOP: two-column
              : Container(
                  height: context.locale.languageCode == 'ar' ? 650 : 620,
                  width: 1000,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildLeftPanel()),
                      Expanded(child: _buildRightPanel(dropdownLanguages)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ---------- LEFT PANEL ----------
  Widget _buildLeftPanel() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF6559F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'app_name'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'tagline'.tr(),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 230),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'left_banner'.tr(),
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    height: context.locale.languageCode == 'ar' ? 1.2 : 1.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'illustration_caption'.tr(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- RIGHT PANEL (scrollable to avoid overflow) ----------
  Widget _buildRightPanel(List<String> dropdownLanguages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: SingleChildScrollView(
        // 👈 added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: null,
                  isExpanded: true,
                  customButton: Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedLanguage,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFBDBDBD),
                        width: 2.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    overlayColor: WidgetStatePropertyAll(
                      Color.fromARGB(168, 189, 189, 189),
                    ),
                    height: 40,
                  ),
                  items: dropdownLanguages
                      .map(
                        (lang) => DropdownMenuItem<String>(
                          value: lang,
                          child: Text(
                            lang,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLanguage = value;
                      });
                      final newLocale = languageMap[value]!;
                      context.setLocale(newLocale);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'title'.tr(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildLabeledInput('full_name'.tr()),
            const SizedBox(height: 12),
            _buildLabeledInput('phone'.tr()),
            const SizedBox(height: 12),
            _buildLabeledInput('email'.tr()),
            const SizedBox(height: 12),
            _buildLabeledInput('password'.tr(), obscure: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'agree'.tr(),
                      style: const TextStyle(
                        color: Color.fromARGB(168, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'terms'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF6559F5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Color.fromARGB(168, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'privacy'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF6559F5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: StatefulBuilder(
                builder: (context, setStateBtn) {
                  bool isPressed = false;

                  return Listener(
                    onPointerDown: (_) => setStateBtn(() => isPressed = true),
                    onPointerUp: (_) => setStateBtn(() => isPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      decoration: BoxDecoration(
                        color: isPressed
                            // ignore: dead_code
                            ? const Color(0xFF5146C7)
                            : const Color(0xFF6559F5),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // Your action here
                          },
                          child: Center(
                            child: Text(
                              'sign_up'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color.fromRGBO(179, 176, 176, 1),
                    thickness: 1.2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'or_sign_up_with'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(184, 99, 98, 98),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Color.fromRGBO(179, 176, 176, 1),
                    thickness: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialCircle(icon: FontAwesomeIcons.facebookF, onTap: () {}),
                const SizedBox(width: 20),
                _SocialCircle(icon: FontAwesomeIcons.linkedinIn, onTap: () {}),
                const SizedBox(width: 20),
                _SocialCircle(icon: FontAwesomeIcons.google, onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: 'login_prompt'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 99, 98, 98),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: 'login'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6559F5),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, {bool obscure = false}) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: const Color.fromARGB(255, 206, 207, 207),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF6559F5), width: 2),
        ),
      ),
    );
  }
}

// SMALLER SOCIAL CIRCLE WIDGET
class _SocialCircle extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialCircle({required this.icon, required this.onTap});

  @override
  State<_SocialCircle> createState() => _SocialCircleState();
}

class _SocialCircleState extends State<_SocialCircle> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => isPressed = true),
      onPointerUp: (_) => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isPressed
              ? const Color(0xFF5146C7) // Darker on press
              : Colors.white, // Normal white circle
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 78, 78, 78),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: const Color(0xFFFFFFFF),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            splashColor: const Color.fromARGB(255, 62, 62, 62).withOpacity(0.2),
            highlightColor: const Color.fromARGB(255, 193, 192, 202),
            onTap: widget.onTap,
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 18,
                color: const Color(0xFF677489), // Icon color
              ),
            ),
          ),
        ),
      ),
    );
  }
}

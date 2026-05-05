import 'package:chat_application/providers/addChatProvider.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/providers/themProvider.dart';
import 'package:chat_application/providers/userProvider.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:chat_application/view/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profiledetails extends StatefulWidget {
  const Profiledetails({super.key});

  @override
  State<Profiledetails> createState() => _ProfiledetailsState();
}

class _ProfiledetailsState extends State<Profiledetails> {
  String _getInitials(String name) {
    if (name.isEmpty) return "??";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  void _handleLogout(BuildContext context) async {
    // 1. Capture the navigator before any awaits or unmounts
    final navigator = Navigator.of(context);

    // 2. Clear other providers (Userprovider clears itself during logout)
    context.read<Chatprovider>().clear();
    context.read<Requestprovider>().clear();
    context.read<addChatprovider>().clear();

    // 3. Perform the actual logout logic via Userprovider
    await context.read<Userprovider>().logout();

    // 4. Navigate away first
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Loginscreen()),
      (route) => false,
    );
    print("NAVIGATED TO LOGIN SCREEN");

    // 5. Reset home index for the next session
    Provider.of<Homeprovider>(context, listen: false).setIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    final userprov = Provider.of<Userprovider>(context);
    final user = userprov.currentUser;

    if (userprov.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 30,
                bottom: 40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary600, AppColors.primary500],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            backgroundImage: user.avatarUrl != null
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null
                                ? Text(
                                    _getInitials(user.name),
                                    style: AppTextStyles.displaySmall.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.email,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Profile Sections
            _buildSection(context, "Account Info", [
              _buildListTile(context, Icons.person_outline, "Name", user.name),
              _buildListTile(
                context,
                Icons.email_outlined,
                "Email",
                user.email,
              ),
              if (user.phoneNumber != null)
                _buildListTile(
                  context,
                  Icons.phone_outlined,
                  "Phone Number",
                  user.phoneNumber!,
                ),
            ]),

            _buildSection(context, "Settings & Privacy", [
              _buildListTile(
                context,
                Icons.notifications_none,
                "Notifications",
                "Manage alerts and sounds",
                onTap: () {},
              ),
              _buildListTile(
                context,
                Icons.lock_outline,
                "Security",
                "Privacy policy and security settings",
                onTap: () {},
              ),
              _buildDarkModeTile(context),
            ]),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                onTap: () => _handleLogout(context),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Sign out of your account"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 120,
            ), // Increased bottom spacing to prevent overlapping with the floating nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, size: 20)
            : null,
      ),
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    final themeProv = context.watch<Themprovider>();
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            themeProv.isDark ? Icons.dark_mode : Icons.light_mode,
            color: colorScheme.primary,
          ),
        ),
        title: const Text(
          'Dark Mode',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          themeProv.isDark ? 'Dark theme enabled' : 'Light theme enabled',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: CupertinoSwitch(
          value: themeProv.isDark,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          onChanged: (_) => context.read<Themprovider>().settheme(),
        ),
      ),
    );
  }
}

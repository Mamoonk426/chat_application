import 'package:chat_application/providers/addChatProvider.dart';
import 'package:chat_application/providers/chatProvider.dart';
import 'package:chat_application/providers/homeProvider.dart';
import 'package:chat_application/providers/requestProvider.dart';
import 'package:chat_application/providers/themProvider.dart';
import 'package:chat_application/providers/userProvider.dart';
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
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        backgroundImage: user.avatarUrl != null
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                        child: user.avatarUrl == null
                            ? Text(
                                _getInitials(user.name),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
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
            const SizedBox(height: 40),
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
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
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
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, size: 20)
          : null,
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    final themeProv = context.watch<Themprovider>();
    return ListTile(
      leading: Icon(
        themeProv.isDark ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text(
        'Dark Mode',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(themeProv.isDark ? 'Dark theme enabled' : 'Light theme enabled'),
      trailing: CupertinoSwitch(
        value: themeProv.isDark,
        activeTrackColor: Theme.of(context).colorScheme.primary,
        onChanged: (_) => context.read<Themprovider>().settheme(),
      ),
    );
  }
}

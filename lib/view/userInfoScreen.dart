import 'dart:async';
import 'package:chat_application/models/userModel.dart';
import 'package:chat_application/providers/addChatProvider.dart';
import 'package:chat_application/services/authServices.dart';
import 'package:chat_application/themes/app_theme.dart';
import 'package:chat_application/view/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/services/getUserServices.dart';
import 'package:provider/provider.dart';

class Userinfoscreen extends StatefulWidget {
  final Usermodel? user;
  final String? userId;

  const Userinfoscreen({super.key, this.user, this.userId});

  @override
  State<Userinfoscreen> createState() => _UserinfoscreenState();
}

class _UserinfoscreenState extends State<Userinfoscreen> {
  Usermodel? _user;
  bool _isLoading = true;
  StreamSubscription? _statusSubscription;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _user = widget.user;
      _isLoading = false;
      _listenToStatus(_user!.id);
    } else if (widget.userId != null) {
      _fetchUser(widget.userId!);
    }
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  void _listenToStatus(String uid) {
    _statusSubscription?.cancel();
    _statusSubscription = Authservices().listenUserStatus(uid).listen((
      statusMap,
    ) {
      if (mounted) {
        setState(() {
          _isOnline = statusMap?['status'] == 'Online';
        });
      }
    });
  }

  Future<void> _fetchUser(String uid) async {
    final fetched = await Getuserservices().getUserById(uid);
    if (!mounted) return;
    setState(() {
      _user = fetched;
      _isLoading = false;
    });
    if (fetched != null) {
      _listenToStatus(fetched.id);
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "??";
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) return (parts[0][0] + parts[1][0]).toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final addChatproviders = Provider.of<addChatprovider>(
      context,
      listen: false,
    );
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_user == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }
    final user = _user!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'User Info',
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
                  SizedBox(height: 10),
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
                        backgroundColor: AppColors.grey50,
                        child: Text(
                          _getInitials(user.name),
                          style: AppTextStyles.displaySmall.copyWith(
                            color: AppColors.primary500,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isOnline
                                ? AppColors.secondary500
                                : AppColors.grey400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isOnline ? "Online" : "Offline",
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Info Sections
            buildSection(context, "Contact Info", [
              buildListTile(context, Icons.email_outlined, "Email", user.email),
              if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                buildListTile(
                  context,
                  Icons.phone_outlined,
                  "Phone Number",
                  user.phoneNumber!,
                ),
            ]),
            const SizedBox(height: 32),
            // Start Chat Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Chatscreen(id: user.id, name: user.name),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: AppColors.secondary500,
                  foregroundColor: AppColors.primary900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.chat_bubble_rounded),
                label: const Text(
                  "Send Message",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildSection(
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

  Widget buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: const Color(0xFF1CBBB0), width: 4),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1CBBB0).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          subtitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          title,
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

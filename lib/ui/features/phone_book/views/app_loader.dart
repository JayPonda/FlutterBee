import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'adaptive_layout.dart';
import 'package:basics/domain/repositories/i_contact_repository.dart';
import 'package:basics/domain/models/contact_group.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Trigger initialization after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final repository = context.read<IContactRepository>();

    // Ensure base groups exist
    final groups = await repository.watchContactGroups().first;
    if (groups.isEmpty) {
      await _ensureInitialGroups(repository);
    }

    if (mounted) {
      // Wait a bit to show splash
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => const AdaptiveLayout()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _ensureInitialGroups(IContactRepository repository) async {
    final initialGroups = [
      ContactGroup(id: '0', label: 'All Contacts', title: 'All Contacts', contacts: []),
      ContactGroup(id: '1', label: 'Friends', title: 'Friends', contacts: []),
      ContactGroup(id: '2', label: 'Family', title: 'Family', contacts: []),
      ContactGroup(id: '3', label: 'Work', title: 'Work Colleagues', contacts: []),
    ];

    for (final group in initialGroups) {
      await repository.insertGroup(group);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Image.asset(
                      'assets/images/full-logo.png',
                      width: 280,
                      height: 280,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: const CupertinoActivityIndicator(
                        radius: 14,
                        color: Color(0xFF2F4BFF),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

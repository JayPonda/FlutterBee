import 'package:flutter/cupertino.dart';
import 'package:basics/PhoneBook/screens/adaptive_layout.dart';
import 'package:basics/PhoneBook/data/database/app_database.dart';
import 'package:basics/PhoneBook/data/repositories/drift_contact_repository.dart';
import 'package:basics/PhoneBook/data/repositories/i_contact_repository.dart';
import 'package:basics/PhoneBook/data/contact_groups_model.dart';
import 'package:basics/PhoneBook/data/models/contact_group.dart';

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

    _initialize();
  }

  Future<void> _initialize() async {
    // Only initialize if not already done (e.g. during hot restart)
    try {
      // Accessing a late variable before initialization throws a LateInitializationError
      // We can use this to check if we need to initialize
      contactGroupsModel.listsNotifier;
    } catch (_) {
      final db = AppDatabase();
      final repository = DriftContactRepository(db);
      contactGroupsModel = ContactGroupsModel(repository);
    }
    
    final repository = contactGroupsModel.repository;

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
    final allContactsGroup = ContactGroup(
      id: '0',
      label: 'All Contacts',
      title: 'All Contacts',
      contacts: [],
    );
    final friendsGroup = ContactGroup(
      id: '1',
      label: 'Friends',
      title: 'Friends',
      contacts: [],
    );
    final familyGroup = ContactGroup(
      id: '2',
      label: 'Family',
      title: 'Family',
      contacts: [],
    );
    final workGroup = ContactGroup(
      id: '3',
      label: 'Work',
      title: 'Work Colleagues',
      contacts: [],
    );

    await repository.insertGroup(allContactsGroup);
    await repository.insertGroup(friendsGroup);
    await repository.insertGroup(familyGroup);
    await repository.insertGroup(workGroup);
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Notice/notice_screen.dart';
import '../Problem/problem_screen.dart';
import '../Staff/staff_screen.dart';
import '../adminlogin/adminlogin.dart';
import '../event/event_screen.dart';
import '../maintenance/maintenance_screen.dart';
import '../screen/Feedback_Screen.dart';
import '../visitors/visitors_screen.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List users = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      var response = await http.get(
        Uri.parse("https://prakrutitech.xyz/ankita/get_all_users.php"),
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          users = data["data"];
          isLoading = false;
        });
      } else {
        setState(() {
          users = [];
          isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No users found")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load users")));
    }
  }

  Future<void> deleteUser(String id) async {
    await http.post(
      Uri.parse("https://prakrutitech.xyz/ankita/delete_user.php"),
      body: {"id": id},
    );
    loadUsers();
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  Widget dashboardCard(
    String title,
    IconData icon,
    List<Color> gradientColors,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),

            Spacer(),
            Text(
              title,
              style: TextStyle(
                color: Colors.blueGrey.shade900,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget dashboardUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.cyan.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await loadUsers();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(Icons.menu_rounded),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back"),
                        Text(
                          "Admin Dashboard",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30),

                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 18,
                  children: [
                    dashboardCard("Maintenance", Icons.build, [
                      Colors.teal,
                      Colors.cyan,
                    ], const MaintenanceScreen()),
                    dashboardCard("Events", Icons.event, [
                      Colors.indigo,
                      Colors.blue,
                    ], const EventsPage()),
                    dashboardCard("Notices", Icons.campaign, [
                      Colors.purple,
                      Colors.pink,
                    ], const Notice()),
                    dashboardCard("Staff", Icons.people, [
                      Colors.blue,
                      Colors.lightBlue,
                    ], const staff()),
                  ],
                ),

                SizedBox(height: 30),

                Text(
                  "Residents (${users.length})",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                isLoading
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (_, __) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user = users[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade500,
                                child: Text(
                                  (user["name"] ?? "U")[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(user["name"] ?? ""),
                              subtitle: Text(user["email"] ?? ""),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                              onTap: () {
                                _showUserDetailsBottomSheet(context, user);
                              },
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserDetailsBottomSheet(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                (user["name"] ?? "U")[0].toUpperCase(),
                style: const TextStyle(fontSize: 26, color: Colors.blue),
              ),
            ),

            SizedBox(height: 15),

            Text(
              user["name"] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.email, "Email", user["email"]),
                  SizedBox(height: 10),
                  _buildDetailRow(Icons.phone, "Phone", user["phone"]),
                  SizedBox(height: 10),
                  _buildDetailRow(Icons.home, "Flat No", user["flat_no"]),
                ],
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await deleteUser(user["id"]);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete User"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget _buildDetailRow(IconData icon, String title, String? value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$title: ${value ?? ''}",
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_selectedIndex == 0) {
      bodyContent = dashboardUI();
    } else if (_selectedIndex == 1) {
      bodyContent = VisitorsScreen();
    } else {
      bodyContent = FeedbackScreen();
    }
    ;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage your society",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.dashboard_rounded),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.report_problem_rounded),
              title: Text("Problems"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProblemScreen()),
                );
              },
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: Colors.red),
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences preference =
                    await SharedPreferences.getInstance();
                await preference.setBool("admin", false);

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: bodyContent,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.indigo.shade100,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.people), label: "Visitors"),
          NavigationDestination(icon: Icon(Icons.feedback), label: "Feedback"),
        ],
      ),
    );
  }
}

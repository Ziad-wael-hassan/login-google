import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nadaushd/login.dart';
import 'home.dart';

class ProfilePage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method to log out and navigate to LoginPage
  Future<void> _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Switch Account method
  Future<void> _switchAccount(BuildContext context) async {
    // Sign out the current user
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();

    // Once signed out, trigger the Google Sign-In again for a new account
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // If the user cancels login
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with new credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to HomePage or refresh ProfilePage after switch
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("Error during account switch: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? name = user?.displayName ?? 'User';
    String? email = user?.email ?? 'No Email';
    String? photoUrl =
        user?.photoURL ?? 'https://www.gravatar.com/avatar/?d=mp';

    return Scaffold(
      extendBodyBehindAppBar: true, // Makes AppBar float
      appBar: AppBar(
        backgroundColor: Color(0xFF18181B), // Primary Color
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFFFB8C00)),
            onPressed: () => _logOut(context), // Log out to login page
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background color
          Container(
            color: Color(0xFF18181B), // Background Color
          ),

          // Glassmorphism Profile Card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(photoUrl),
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Name
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),

                        // Email
                        Text(
                          email,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 20),

                        // Profile Details
                        Column(
                          children: [
                            _buildProfileTile(Icons.person, "Full Name", name),
                            _buildProfileTile(Icons.email, "Email", email),
                            _buildProfileTile(
                              Icons.verified_user,
                              "User ID",
                              user?.uid ?? "N/A",
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Switch Account Button
                        ElevatedButton.icon(
                          onPressed: () => _switchAccount(context),
                          icon: Icon(Icons.switch_account, color: Colors.white),
                          label: Text(
                            "Switch Account",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFB8C00), // Button Color
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build profile details row
  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}

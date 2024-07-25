// ***************************
// ***** file not needed *****
// ***************************

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _avatarUrl;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text.trim();
    final website = _websiteController.text.trim();
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) context.showSnackBar('Successfully updated profile!');
    } on PostgrestException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => const LoginPage()),
        // );
        // state.setPage(InitialPage());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }


  var pressedBack = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _loading ? null : _updateProfile,
            child: Text(_loading ? 'Saving...' : 'Update'),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {
              _signOut();
              appState.setPage(InitialPage());
            }, 
            child: const Text('Sign Out')
          ),
          TextButton(
            onPressed: () {
              print("deleting account");
            }, 
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /* Future<void> signUpNewUser() async {
    final AuthResponse res = await supabase.auth.signUp(
      email: 'example@email.com',
      password: 'example-password'
    );
  } */


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Registro Corredor"),),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text("E-mail"),
            ),
          ),

          SizedBox(height: 15,),

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              label: Text("Password"),
            ),
            obscureText: true,
          ),

          SizedBox(height: 25,),

          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              // signUpNewUser();
              supabase.auth.signUp(
                email: email,
                password: password,
              );
              appState.setPage(InitialPage());

              // try {
              //   final email = _emailController.text.trim();
              //   final password = _passwordController.text.trim();
              //   await supabase.auth.signUp(
              //     email: email,
              //     password: password
              //   );
              //   if (mounted) {
              //     appState.setPage(AddInfo());
              //   }
              // } on AuthException catch (error) {
              //   //if (mounted) context.showSnackBar(error.message, isError: true);
              // } catch (error) {
              //   // if (mounted) {
              //   //   context.showSnackBar('Unexpected error occurred', isError: true);
              //   // }
              // }
              
              //final name = _nameController.text.trim();
              //final apellido = _apellidoController.text.trim();
              //final userId = supabase.auth.currentUser!.id;
              

              // await supabase.from("profiles").update({
              //   "nombre(s)": name,
              //   "apellido": apellido,
              // }).eq("id", userId);

              print("Signing up");
            }, 
            child: Text("Registrarme")
          ),
        ],
      ),
    );
  }
}

class AddInfo extends StatefulWidget {
  const AddInfo({super.key});

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  final _nameController = TextEditingController();
  final _apellidoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: Text("Información Adicional"),),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text("Nombre/s"),
            ),
          ),

          SizedBox(height: 15,),

          TextFormField(
            controller: _apellidoController,
            decoration: const InputDecoration(
              label: Text("Apellido"),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              final apellido = _apellidoController.text.trim();
              final userId = supabase.auth.currentUser!.id;

              await supabase.from("profiles").update({
                "nombre(s)": name,
                "apellido": apellido,
              }).eq("id", userId);

              print("Signing up");
            }, 
            child: Text("Registrarme")
          ),
        ]
      )
    );
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SafeArea(
        child: /* SupaEmailAuth(
          //redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
          onSignInComplete: (response) {
            print(response);
            appState.setPage(HomeCorredorPage());
          },
          onSignUpComplete: (response) {
            appState.setPage(AddInfo());
          },
          metadataFields: [
            /* MetaDataField(
              prefixIcon: const Icon(Icons.person),
              label: 'Nombre de Usuario',
              key: 'username',
              validator: (val) {
                if (val == null || val.isEmpty) {
                return 'Please enter something';
                }
                return null;
              },
            ),
        
            MetaDataField(
              prefixIcon: const Icon(Icons.person),
              label: 'Nombre(s)',
              key: 'nombre',
              validator: (val) {
                if (val == null || val.isEmpty) {
                return 'Please enter something';
                }
                return null;
              },
            ),
        
            MetaDataField(
              prefixIcon: const Icon(Icons.person),
              label: 'Apellido',
              key: 'apellido',
              validator: (val) {
                if (val == null || val.isEmpty) {
                return 'Please enter something';
                }
                return null;
              },
            ), */
          ],
        ), */
        SupaEmailAuth(
          //redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
          onSignInComplete: (response) {},
          onSignUpComplete: (response) {},
          metadataFields: [
            MetaDataField(
            prefixIcon: const Icon(Icons.person),
            label: 'Username',
            key: 'username',
            validator: (val) {
                    if (val == null || val.isEmpty) {
                    return 'Please enter something';
                    }
                    return null;
                  },
                ),
            ],
        )
      ),
    );
  }
}

Future<void> signUpNewUser() async {
  final AuthResponse res = await supabase.auth.signUp(
    email: 'example@email.com',
    password: 'example-password'
  );
}
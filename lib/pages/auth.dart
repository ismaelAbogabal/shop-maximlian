import 'package:flutter/material.dart';
import 'package:programme/utils/data.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool isLogin = true;
  bool isLoading = false;
  String errorMessage = "";

  AnimationController _controller;

  final TextEditingController _email =
      TextEditingController(text: "soma@gmail.com");
  final TextEditingController _password =
      TextEditingController(text: "somasoma");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Sign up"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment(0, -.2),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(.5),
              BlendMode.colorDodge,
            ),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (errorMessage != null || errorMessage.isNotEmpty)
                Text(errorMessage,
                    style: TextStyle(color: Theme.of(context).errorColor)),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    borderSide: BorderSide(width: 3, color: Colors.deepOrange),
//                  ),
                ),
                validator: (String val) {
                  if (!val.trim().endsWith("@gmail.com")) {
                    return "invalid google mail";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _password,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.white,
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    borderSide: BorderSide(width: 3, color: Colors.deepOrange),
//                  ),
                ),
                validator: (String val) {
                  if (val.length < 6) {
                    return "Password mast be 6+ charachters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPassword(),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                child: Text("switch to ${isLogin ? "Sign up" : "Login"} page"),
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text(isLogin ? "LOGIN" : "SIGN UP"),
                      onPressed: confirmIt,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return SizeTransition(
      sizeFactor: _controller,
      child: FadeTransition(
        opacity: _controller,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (String val) {
            if (isLogin) return null;
            if (val != _password.text) {
              return "passwords dont match";
            }
            return null;
          },
        ),
      ),
    );
  }

  void confirmIt() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      authenticate(_email.text, _password.text, isLogin).then((val) {
        if (val.success) {
          Navigator.pushReplacementNamed(context, "/products");
        } else {
          setState(() {
            isLoading = false;
            errorMessage = val.error;
          });
        }
      });
    }
  }
}

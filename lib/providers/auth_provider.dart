import 'package:flutter/foundation.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
}

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final double balance;
  final double monthlyIncome;
  final double monthlyExpense;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.balance = 0.0,
    this.monthlyIncome = 0.0,
    this.monthlyExpense = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'balance': balance,
    'monthlyIncome': monthlyIncome,
    'monthlyExpense': monthlyExpense,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      balance: json['balance'] ?? 0.0,
      monthlyIncome: json['monthlyIncome'] ?? 0.0,
      monthlyExpense: json['monthlyExpense'] ?? 0.0,
    );
  }
}

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAuthenticating => _status == AuthStatus.authenticating;

  Future<bool> login(
    String email,
    String password, {
    double balance = 0.0,
    double monthlyIncome = 0.0,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      _user = User(
        id: '1',
        name: email.split('@')[0],
        email: email,
        balance: balance,
        monthlyIncome: monthlyIncome,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password, {
    double balance = 0.0,
    double monthlyIncome = 0.0,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('All fields are required');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (!email.contains('@')) {
        throw Exception('Please enter a valid email');
      }

      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        balance: balance,
        monthlyIncome: monthlyIncome,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.unauthenticated;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? photoUrl,
    double? balance,
    double? monthlyIncome,
    double? monthlyExpense,
  }) async {
    try {
      if (_user == null) {
        throw Exception('No user logged in');
      }

      await Future.delayed(const Duration(seconds: 1));

      _user = User(
        id: _user!.id,
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        photoUrl: photoUrl ?? _user!.photoUrl,
        balance: balance ?? _user!.balance,
        monthlyIncome: monthlyIncome ?? _user!.monthlyIncome,
        monthlyExpense: monthlyExpense ?? _user!.monthlyExpense,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      if (_user == null) {
        throw Exception('No user logged in');
      }

      await Future.delayed(const Duration(seconds: 1));

      if (oldPassword.isEmpty || newPassword.isEmpty) {
        throw Exception('Passwords cannot be empty');
      }

      if (newPassword.length < 6) {
        throw Exception('New password must be at least 6 characters');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email');
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> addFunds(double amount) async {
    try {
      if (_user == null) {
        throw Exception('No user logged in');
      }

      if (amount <= 0) {
        throw Exception('Amount must be positive');
      }

      await Future.delayed(const Duration(seconds: 1));

      final newBalance = (_user!.balance) + amount;
      await updateProfile(balance: newBalance);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> withdrawFunds(double amount) async {
    try {
      if (_user == null) {
        throw Exception('No user logged in');
      }

      if (amount <= 0) {
        throw Exception('Amount must be positive');
      }

      if (amount > (_user!.balance)) {
        throw Exception('Insufficient balance');
      }

      await Future.delayed(const Duration(seconds: 1));

      final newBalance = (_user!.balance) - amount;
      await updateProfile(balance: newBalance);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

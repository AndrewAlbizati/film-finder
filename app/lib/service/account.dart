import 'dart:convert';

class Account {
  String username;
  String email;
  String token;

  Account({
    required this.username,
    required this.email,
    required this.token,
  });

  Account copyWith({
    String? username,
    String? email,
    String? token,
  }) {
    return Account(
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'token': token,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
    );
  }

  factory Account.fromResponseBody(var jsonResponse) {
    return Account(
      email: jsonResponse['user']['email'],
      username: jsonResponse['user']['username'],
      token: jsonResponse['token'],
    );
  }

  factory Account.createGuest() {
    return Account(
      email: '',
      username: '',
      token: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(username: $username, email: $email, token: $token)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.token == token;
  }

  @override
  int get hashCode {
    return username.hashCode ^ email.hashCode ^ token.hashCode;
  }
}

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/advising_message.dart';
import '../models/user.dart';
import '../providers/app_session_provider.dart';

final advisingProvider = StateNotifierProvider<AdvisingNotifier, AdvisingState>((ref) {
  return AdvisingNotifier(ref);
});

class AdvisingState {
  final bool isLoading;
  final String? error;
  final User? advisor;
  final List<User> students;
  final List<AdvisingMessage> messages;

  AdvisingState({
    this.isLoading = false,
    this.error,
    this.advisor,
    this.students = const [],
    this.messages = const [],
  });

  AdvisingState copyWith({
    bool? isLoading,
    String? error,
    User? advisor,
    List<User>? students,
    List<AdvisingMessage>? messages,
  }) {
    return AdvisingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      advisor: advisor ?? this.advisor,
      students: students ?? this.students,
      messages: messages ?? this.messages,
    );
  }
}

class AdvisingNotifier extends StateNotifier<AdvisingState> {
  final Ref _ref;
  final String _baseUrl = 'http://localhost:3000/api/advising';

  AdvisingNotifier(this._ref) : super(AdvisingState());

  Future<void> loadAdvisingInfo() async {
    final session = _ref.read(appSessionControllerProvider);
    if (session is! AppSessionAuthenticated) return;

    state = state.copyWith(isLoading: true);
    try {
      if (session.user.mode == AppMode.student) {
        final response = await http.get(Uri.parse('$_baseUrl/advisor/${session.user.email}'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          state = state.copyWith(advisor: User.fromJson(data['advisor']));
        }
      } else {
        final response = await http.get(Uri.parse('$_baseUrl/students/${session.user.email}'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<User> students = (data['students'] as List)
              .map((s) => User.fromJson(s))
              .toList();
          state = state.copyWith(students: students);
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchMessages({String? otherUserEmail, bool isBroadcast = false}) async {
    final session = _ref.read(appSessionControllerProvider);
    if (session is! AppSessionAuthenticated) return;

    try {
      Uri url;
      if (otherUserEmail != null) {
        url = Uri.parse('$_baseUrl/messages?user1=${session.user.email}&user2=$otherUserEmail');
      } else {
        url = Uri.parse('$_baseUrl/messages?email=${session.user.email}&broadcast=true');
      }

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<AdvisingMessage> messages = (data['messages'] as List)
            .map((m) => AdvisingMessage.fromJson(m))
            .toList();
        state = state.copyWith(messages: messages);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> sendMessage({
    required String message,
    String? receiverEmail,
    bool isBroadcast = false,
  }) async {
    final session = _ref.read(appSessionControllerProvider);
    if (session is! AppSessionAuthenticated) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderEmail': session.user.email,
          'receiverEmail': receiverEmail,
          'message': message,
          'isBroadcast': isBroadcast,
        }),
      );

      if (response.statusCode == 200) {
        fetchMessages(otherUserEmail: receiverEmail, isBroadcast: isBroadcast);
        return true;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
    return false;
  }

  Future<bool> linkStudents(List<String> studentEmails) async {
    final session = _ref.read(appSessionControllerProvider);
    if (session is! AppSessionAuthenticated) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/link'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'advisorEmail': session.user.email,
          'studentEmails': studentEmails,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

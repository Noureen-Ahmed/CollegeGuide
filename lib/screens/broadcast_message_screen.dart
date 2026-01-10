import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/advising_provider.dart';
import 'package:go_router/go_router.dart';

class BroadcastMessageScreen extends ConsumerStatefulWidget {
  const BroadcastMessageScreen({super.key});

  @override
  ConsumerState<BroadcastMessageScreen> createState() => _BroadcastMessageScreenState();
}

class _BroadcastMessageScreenState extends ConsumerState<BroadcastMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  void _sendBroadcast() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    final success = await ref.read(advisingProvider.notifier).sendMessage(
      message: _controller.text.trim(),
      isBroadcast: true,
    );
    setState(() => _isSending = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent to all students')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Message'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'This message will be sent to ALL students under your advisement.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Type your announcement here...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendBroadcast,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSending 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Send Broadcast'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

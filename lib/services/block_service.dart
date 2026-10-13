import 'package:supabase_flutter/supabase_flutter.dart';

class BlockService {
  final _supabase = Supabase.instance.client;

  // Verificar si un usuario está bloqueado
  Future<bool> isUserBlocked(String targetUserId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return false;

    final response = await _supabase
        .from('user_blocks')
        .select()
        .eq('blocker_id', currentUserId)
        .eq('blocked_id', targetUserId)
        .maybeSingle();

    return response != null;
  }

  // Bloquear a un usuario
  Future<void> blockUser(String targetUserId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return;

    await _supabase.from('user_blocks').insert({
      'blocker_id': currentUserId,
      'blocked_id': targetUserId,
    });
  }

  // Desbloquear a un usuario
  Future<void> unblockUser(String targetUserId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return;

    await _supabase.from('user_blocks')
        .delete()
        .match({
          'blocker_id': currentUserId,
          'blocked_id': targetUserId,
        });
  }
}
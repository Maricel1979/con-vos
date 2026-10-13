import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:convos/services/block_service.dart';

class OtherProfileScreen extends StatefulWidget {
  final String targetUserId;
  const OtherProfileScreen({Key? key, required this.targetUserId})
    : super(key: key);

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _blockService = BlockService();

  bool _isLoading = true;
  bool _isBlocked = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _initProfileData();
  }

  Future<void> _initProfileData() async {
    await _registrarVisita();
    await _cargarDatosYBloqueo();
  }

  Future<void> _registrarVisita() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null || currentUserId == widget.targetUserId) return;

    try {
      await _supabase.from('profile_views').insert({
        'visited_user_id': widget.targetUserId,
        'visitor_user_id': currentUserId,
      });
    } catch (e) {
      debugPrint('Visita ya registrada o error menor: $e');
    }
  }

  Future<void> _cargarDatosYBloqueo() async {
    setState(() => _isLoading = true);
    try {
      final profileResponse = await _supabase
          .from('profiles')
          .select()
          .eq('id', widget.targetUserId)
          .maybeSingle();

      final blocked = await _blockService.isUserBlocked(widget.targetUserId);

      setState(() {
        _userData = profileResponse;
        _isBlocked = blocked;
      });
    } catch (e) {
      debugPrint('Error al cargar perfil ajeno: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBlockStatus() async {
    try {
      if (_isBlocked) {
        await _blockService.unblockUser(widget.targetUserId);
        setState(() => _isBlocked = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario desbloqueado con éxito')),
        );
      } else {
        bool? confirmar = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Bloquear usuario',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              '¿Estás seguro? Al bloquearlo ya no podrá ver tus transmisiones ni contactarte.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Bloquear',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );

        if (confirmar == true) {
          await _blockService.blockUser(widget.targetUserId);
          setState(() => _isBlocked = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario bloqueado correctamente')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al modificar bloqueo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _userData?['full_name'] ?? 'Usuario de CONVOS';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              _isBlocked ? Icons.lock_open : Icons.block,
              color: _isBlocked ? Colors.greenAccent : Colors.redAccent,
            ),
            tooltip: _isBlocked ? 'Desbloquear usuario' : 'Bloquear usuario',
            onPressed: _toggleBlockStatus,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _isBlocked
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _toggleBlockStatus,
                      icon: Icon(
                        _isBlocked ? Icons.lock_open : Icons.block,
                        color: _isBlocked
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                      label: Text(
                        _isBlocked ? 'Desbloquear Usuario' : 'Bloquear Usuario',
                        style: TextStyle(
                          color: _isBlocked
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

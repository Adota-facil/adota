import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/controllers/perfil_usuario_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:adota_facil/view/pages/login_view.dart';
import 'package:adota_facil/view/pages/meus_anuncios_view.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilUsuarioView extends StatefulWidget {
  const PerfilUsuarioView({super.key});

  @override
  State<PerfilUsuarioView> createState() => _PerfilUsuarioViewState();
}

class _PerfilUsuarioViewState extends State<PerfilUsuarioView> {
  late final PerfilUsuarioController _controller;
  late final UsuarioRepository _usuarioRepository;
  Stream<UsuarioModel?>? _streamUsuario;
  String? _usuarioIdDoStream;

  @override
  void initState() {
    super.initState();
    _usuarioRepository = UsuarioRepositoryImpl();
    _controller = PerfilUsuarioController(
      context.read<AuthController>(),
      _usuarioRepository,
    );
  }

  Stream<UsuarioModel?> _obterStreamUsuario(String usuarioId) {
    if (_streamUsuario == null || _usuarioIdDoStream != usuarioId) {
      _usuarioIdDoStream = usuarioId;
      _streamUsuario = _usuarioRepository.observarUsuario(usuarioId);
    }
    return _streamUsuario!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _construirItemInformacao({
    required String label,
    required String valor,
    required IconData icone,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
            ),
            child: Row(
              children: [
                Icon(icone, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Text(
                  valor,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirTelaNaoLogado() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Você ainda não tem uma conta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Entre ou crie uma conta pra favoritar pets e anunciar os seus.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const LoginView()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF9737),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Entrar / Criar conta',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCarregando() {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    if (!authController.logado) {
      _streamUsuario = null;
      _usuarioIdDoStream = null;
      return _construirTelaNaoLogado();
    }

    return StreamBuilder<UsuarioModel?>(
      stream: _obterStreamUsuario(authController.usuarioId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _construirCarregando();
        }

        final usuario = snapshot.data;
        if (usuario == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('Perfil não encontrado.')),
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => _construirCorpo(usuario),
        );
      },
    );
  }

  Widget _construirCorpo(UsuarioModel usuario) {
    final temFoto = usuario.fotoUrl.isNotEmpty || usuario.fotoBase64.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: temFoto
                              ? PetImageWidget(
                                  fotoBase64: usuario.fotoBase64,
                                  fotoUrl: usuario.fotoUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: const Color(0xFFFAFAFA),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blue,
                                  ),
                                ),
                        ),
                      ),
                      if (_controller.carregandoFoto)
                        Positioned.fill(
                          child: ClipOval(
                            child: Container(
                              color: Colors.black38,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              _controller.editarFotoPerfil(context, usuario),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    usuario.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    usuario.criadoEm != null
                        ? 'Membro desde ${usuario.criadoEm!.year}'
                        : '',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Meus Dados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            _construirItemInformacao(
              label: 'Nome Completo',
              valor: usuario.nome.isNotEmpty ? usuario.nome : '-',
              icone: Icons.person_outline,
            ),
            _construirItemInformacao(
              label: 'E-mail',
              valor: usuario.email.isNotEmpty ? usuario.email : '-',
              icone: Icons.email_outlined,
            ),
            _construirItemInformacao(
              label: 'WhatsApp',
              valor: (usuario.telefone != null && usuario.telefone!.isNotEmpty)
                  ? usuario.telefone!
                  : '-',
              icone: Icons.phone_android,
            ),
            Row(
              children: [
                Expanded(
                  child: _construirItemInformacao(
                    label: 'Estado',
                    valor: usuario.estado.isNotEmpty ? usuario.estado : '-',
                    icone: Icons.map_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _construirItemInformacao(
                    label: 'Cidade',
                    valor: usuario.cidade.isNotEmpty ? usuario.cidade : '-',
                    icone: Icons.location_city,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (usuario.ehAnunciante) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF9737)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MeusAnunciosView(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.pets, color: Color(0xFFEF9737)),
                  label: const Text(
                    'Meus Anúncios',
                    style: TextStyle(
                      color: Color(0xFFEF9737),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _controller.sairDaConta(context),
                child: const Text(
                  'Sair da Conta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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

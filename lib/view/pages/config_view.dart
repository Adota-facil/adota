import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final UsuarioRepository _usuarioRepository = UsuarioRepositoryImpl();

  Widget _construirSecao({required String titulo, required List<Widget> itens}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
          ),
          child: Column(children: itens),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _construirOpcaoClique({
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
    Color corIcone = Colors.blue,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(icone, color: corIcone, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget construirOpcaoAlternar({
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required bool valorAtual,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icone, color: Colors.blue, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: valorAtual,
            onChanged: onChanged,
            activeThumbColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Future<void> _alterarSenha(BuildContext context) async {
    final senhaAtualController = TextEditingController();
    final novaSenhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();

    final dados = await showDialog<(String, String)?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Alterar senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: senhaAtualController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha atual',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: novaSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar nova senha',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final senhaAtual = senhaAtualController.text.trim();
              final novaSenha = novaSenhaController.text;

              if (senhaAtual.isEmpty || novaSenha.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A nova senha deve ter pelo menos 6 caracteres.'),
                  ),
                );
                return;
              }
              if (novaSenha != confirmarSenhaController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('As senhas não coincidem.')),
                );
                return;
              }

              Navigator.of(dialogContext).pop((senhaAtual, novaSenha));
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    senhaAtualController.dispose();
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();

    if (dados == null || !context.mounted) return;

    final authController = context.read<AuthController>();
    final sucesso = await authController.alterarSenha(
      senhaAtual: dados.$1,
      novaSenha: dados.$2,
    );
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Senha alterada com sucesso.'
              : (authController.erro ?? 'Não foi possível alterar a senha.'),
        ),
      ),
    );
  }

  Future<void> _confirmarSaida(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja encerrar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmou != true || !context.mounted) return;

    await context.read<AuthController>().logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }

  Future<void> _alterarTipoPerfil(BuildContext context) async {
    final usuarioId = context.read<AuthController>().usuarioId;
    if (usuarioId == null) return;

    try {
      final usuario = await _usuarioRepository.buscarPorId(usuarioId);
      if (!context.mounted || usuario == null) return;

      final novoTipo = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          var tipoSelecionado = usuario.tipo;
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Tipo de perfil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: tipoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de perfil',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'adotante',
                        child: Text('Adotante'),
                      ),
                      DropdownMenuItem(
                        value: 'anunciante',
                        child: Text('Anunciante'),
                      ),
                      DropdownMenuItem(
                        value: 'ambos',
                        child: Text('Ambos'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => tipoSelecionado = valor);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(tipoSelecionado),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          );
        },
      );

      if (novoTipo == null || novoTipo == usuario.tipo || !context.mounted) {
        return;
      }

      final usuarioAtualizado = usuario.copyWith(
        tipo: novoTipo,
        tipoAnunciante: novoTipo == 'adotante'
            ? ''
            : (usuario.tipoAnunciante ?? 'Protetor Independente'),
      );
      await _usuarioRepository.salvar(usuarioAtualizado);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de perfil atualizado com sucesso.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível alterar o tipo de perfil.')),
      );
    }
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final senhaController = TextEditingController();
    final senha = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir conta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Essa ação é permanente e não pode ser desfeita. Informe sua '
              'senha para continuar.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha atual',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (senhaController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Informe sua senha.')),
                );
                return;
              }
              Navigator.of(dialogContext).pop(senhaController.text);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    senhaController.dispose();

    if (senha == null || !context.mounted) return;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Tem certeza que deseja excluir permanentemente sua conta e seus '
          'dados?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sim, excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmou != true || !context.mounted) return;

    final authController = context.read<AuthController>();
    final sucesso = await authController.excluirConta(senha: senha);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso
              ? 'Conta excluída.'
              : (authController.erro ?? 'Não foi possível excluir a conta.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurações',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Gerencie as preferências e segurança do seu aplicativo:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _construirSecao(
              titulo: 'Segurança',
              itens: [
                _construirOpcaoClique(
                  icone: Icons.lock_outline,
                  titulo: 'Alterar Senha',
                  subtitulo: 'Atualize sua credencial de acesso',
                  onTap: () => _alterarSenha(context),
                ),
              ],
            ),
            if (authController.logado)
              _construirSecao(
                titulo: 'Conta',
                itens: [
                  _construirOpcaoClique(
                    icone: Icons.switch_account_outlined,
                    titulo: 'Tipo de Perfil',
                    subtitulo: 'Escolha entre adotante, anunciante ou ambos',
                    onTap: () => _alterarTipoPerfil(context),
                  ),
                  _construirOpcaoClique(
                    icone: Icons.logout,
                    titulo: 'Sair da Conta',
                    subtitulo: 'Encerrar a sessão neste dispositivo',
                    corIcone: Colors.red,
                    onTap: () => _confirmarSaida(context),
                  ),
                ],
              ),
            if (authController.logado)
              _construirSecao(
                titulo: 'Zona de Perigo',
                itens: [
                  _construirOpcaoClique(
                    icone: Icons.delete_forever_outlined,
                    titulo: 'Excluir Conta',
                    subtitulo:
                        'Apagar permanentemente seus dados do aplicativo',
                    corIcone: Colors.red,
                    onTap: () => _confirmarExclusao(context),
                  ),
                ],
              ),
            Center(
              child: Text(
                'Adota Fácil v1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String _tipo = 'adotante';
  String _tipoAnunciante = 'Protetor Independente';
  bool _senhaVisivel = false;

  static const _tiposAnunciante = ['Protetor Independente', 'ONG', 'Abrigo'];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _estadoController.dispose();
    _cidadeController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final sucesso = await authController.cadastrar(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
      tipo: _tipo,
      tipoAnunciante: _tipo == 'adotante' ? null : _tipoAnunciante,
      telefone: _telefoneController.text.trim().isEmpty
          ? null
          : _telefoneController.text.trim(),
      estado: _estadoController.text.trim(),
      cidade: _cidadeController.text.trim(),
    );

    if (!mounted) return;
    if (sucesso) {
      Navigator.of(context)
        ..pop() // fecha a tela de Cadastro
        ..pop(); // fecha a tela de Login também — já está logado
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.erro ?? 'Erro ao cadastrar.')),
      );
    }
  }

  Future<void> _cadastrarComGoogle() async {
    final authController = context.read<AuthController>();
    final sucesso = await authController.loginComGoogle(
      tipo: _tipo,
      tipoAnunciante: _tipo == 'adotante' ? null : _tipoAnunciante,
      telefone: _telefoneController.text.trim().isEmpty
          ? null
          : _telefoneController.text.trim(),
      estado: _estadoController.text.trim(),
      cidade: _cidadeController.text.trim(),
    );

    if (!mounted) return;
    if (sucesso) {
      Navigator.of(context)
        ..pop()
        ..pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.erro ?? 'Erro ao entrar com Google.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final precisaTipoAnunciante = _tipo != 'adotante';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF9737)),
        title: const Text(
          'Criar conta',
          style: TextStyle(
            color: Color(0xFFEF9737),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'Informe seu nome.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe seu e-mail.';
                  }
                  if (!valor.contains('@')) return 'E-mail inválido.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _estadoController,
                      decoration: const InputDecoration(
                        labelText: 'Estado (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return 'Crie uma senha.';
                  if (valor.length < 6) return 'Mínimo de 6 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: !_senhaVisivel,
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor != _senhaController.text) {
                    return 'As senhas não coincidem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Você quer...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              _seletorTipo(),
              if (precisaTipoAnunciante) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _tipoAnunciante,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de anunciante',
                    border: OutlineInputBorder(),
                  ),
                  items: _tiposAnunciante
                      .map(
                        (tipo) =>
                            DropdownMenuItem(value: tipo, child: Text(tipo)),
                      )
                      .toList(),
                  onChanged: (valor) =>
                      setState(() => _tipoAnunciante = valor!),
                ),
              ],
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: authController.carregando ? null : _cadastrarComGoogle,
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Criar conta com Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF4285F4)),
                  foregroundColor: const Color(0xFF4285F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: authController.carregando ? null : _cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF9737),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: authController.carregando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Criar conta',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seletorTipo() {
    const opcoes = {
      'adotante': 'Adotar',
      'anunciante': 'Anunciar pets',
      'ambos': 'Ambos',
    };
    return Wrap(
      spacing: 8,
      children: opcoes.entries.map((entrada) {
        final selecionado = _tipo == entrada.key;
        return ChoiceChip(
          label: Text(entrada.value),
          selected: selecionado,
          onSelected: (_) => setState(() => _tipo = entrada.key),
          selectedColor: const Color(0xFFEF9737).withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: selecionado ? const Color(0xFFA45600) : Colors.black87,
            fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
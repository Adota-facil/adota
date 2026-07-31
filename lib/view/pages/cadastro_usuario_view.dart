import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();

  OutlineInputBorder _estiloBorda() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
    );
  }

  Widget _construirCampo({
    required String label,
    required String dica,
    IconData? icone,
    bool ocultarTexto = false,
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
          TextFormField(
            obscureText: ocultarTexto,
            decoration: InputDecoration(
              hintText: dica,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
              prefixIcon: icone != null
                  ? Icon(icone, color: Colors.blue)
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              enabledBorder: _estiloBorda(),
              focusedBorder: _estiloBorda().copyWith(
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: "Bem vindo! \n Eduardo"),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bem vindo ao Adota Pet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Digite seus dados para realizar o cadastro:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _construirCampo(
                label: 'Seu nome*',
                dica: 'Digite seu nome completo',
                icone: Icons.person,
              ),
              _construirCampo(
                label: 'CPF*',
                dica: '000.000.000-00',
                icone: Icons.badge_outlined,
              ),
              _construirCampo(
                label: 'Email*',
                dica: 'exemplo@email.com',
                icone: Icons.email,
              ),
              _construirCampo(
                label: 'Confirmação de Email*',
                dica: 'Repita o email inserido',
                icone: Icons.mail_outline,
              ),
              _construirCampo(
                label: 'Whatsapp*',
                dica: '(00) 00000-0000',
                icone: Icons.phone,
              ),
              Row(
                children: [
                  Expanded(
                    child: _construirCampo(
                      label: 'Cidade*',
                      dica: 'Ex: Garanhuns',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _construirCampo(
                      label: 'Estado*',
                      dica: 'Ex: Pernambuco',
                    ),
                  ),
                ],
              ),
              _construirCampo(
                label: 'Senha*',
                dica: 'Crie uma senha forte',
                icone: Icons.lock,
                ocultarTexto: true,
              ),
              _construirCampo(
                label: 'Confirmação de Senha*',
                dica: 'Repita a senha criada',
                icone: Icons.lock_outline,
                ocultarTexto: true,
              ),
              Transform.translate(
                offset: Offset(0, -8),
                child: Text(
                  'Deve ter pelo menos 8 caracteres, incluindo letras e números.',
                  style: TextStyle(color: Colors.black38, fontSize: 11),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: const Text(
                    'Concluir Cadastro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
